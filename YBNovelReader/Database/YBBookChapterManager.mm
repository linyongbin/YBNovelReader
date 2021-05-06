//
//  YBBookChapterManager.m
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/30.
//

#import "YBBookChapterManager.h"
#import "YBDatabaseManager.h"
#import "YBBookChapterModel.h"
#import "YBBookChapterModel+WCTTableCoding.h"
#import "YBNetwork.h"
#import "YBBookDetailManager.h"
#import "YBBookDetailModel.h"

@implementation YBBookChapterManager

+(NSArray *)getBriefCharptersWithBookId:(NSInteger)bookId{
    return [[YBDatabaseManager sharedInstance].database getObjectsOnResults:{YBBookChapterModel.charpterId,YBBookChapterModel.chapterName,YBBookChapterModel.bookId} fromTable:kCharpterTable where:YBBookChapterModel.bookId.is(bookId)];// orderBy:YBBookChapterModel.charpterId.order(WCTOrderedAscending)
}

+(BOOL)isExsitWithBookId:(NSInteger)bookId
{
    YBBookChapterModel *model = [[YBDatabaseManager sharedInstance].database getOneObjectOnResults:{YBBookChapterModel.primaryId} fromTable:kCharpterTable where:YBBookChapterModel.bookId.is(bookId)];
    return model?YES:NO;
}

+(BOOL)isExsitWithBookId:(NSInteger)bookId charpterId:(NSInteger)charpterId
{
    YBBookChapterModel *model = [[YBDatabaseManager sharedInstance].database getOneObjectOnResults:{YBBookChapterModel.primaryId} fromTable:kCharpterTable where:YBBookChapterModel.bookId.is(bookId)&&YBBookChapterModel.charpterId.is(charpterId)];
    return model?YES:NO;
}


+(YBBookChapterModel *)getCharpterWithBookId:(NSInteger)bookId charpterId:(NSInteger)charpterId{
    return [[YBDatabaseManager sharedInstance].database getOneObjectOfClass:YBBookChapterModel.class fromTable:kCharpterTable where:YBBookChapterModel.bookId.is(bookId)&&YBBookChapterModel.charpterId.is(charpterId)];
}

+(NSInteger)getFirstCharpterIdWirhBookId:(NSInteger)bookId{
    return [[[YBDatabaseManager sharedInstance].database getOneValueOnResult:YBBookChapterModel.charpterId.min() fromTable:kCharpterTable where:YBBookChapterModel.bookId.is(bookId)] integerValue];
}

+ (void)updateCharpterContentWithModel:(YBBookChapterModel *)model{
    BOOL success = [[YBDatabaseManager sharedInstance].database updateRowsInTable:kCharpterTable onProperty:YBBookChapterModel.chapterContent withObject:model where:YBBookChapterModel.bookId.is(model.bookId)&&YBBookChapterModel.charpterId.is(model.charpterId)];
    if (success) {
        NSLog(@"%@-%@ 更新成功",model.bookName,model.chapterName);
    }else{
        NSLog(@"%@-%@ 更新失败",model.bookName,model.chapterName);
    }
//    [[YBDatabaseManager sharedInstance].database updateRowsInTable:kCharpterTable onProperty:YBBookChapterModel.chapterContent withValue:model.bookId where:YBBookChapterModel.bookId.is(model.bookId)&&YBBookChapterModel.charpterId.is(model.charpterId)];
}

+(void)slientDownWithBookId:(NSInteger)bookId charpterIds:(NSArray *)charpters
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //判断章节是否存在，如果存在不下载
        NSMutableArray *downloads = [NSMutableArray array];
        for (NSNumber *charpter in charpters) {
            YBBookChapterModel *model = [YBBookChapterManager getCharpterWithBookId:bookId charpterId:charpter.integerValue];
            if (model && model.chapterContent.length==0) {
                [[YBNetwork sharedManager] getBookChapterDetailWithUrl:model.charpterUrl WithBlock:^(YBRequestResult * _Nonnull result, NSError * _Nonnull error) {
                    if ([YBResultError hasErrorWithReslut:result error:error]) {
                        return;
                    }
                    model.chapterContent = result.data;
                    [YBBookChapterManager updateCharpterContentWithModel:model];
                }];
            }
        }
    });
    
}

+(void)insertObjectWithCharpters:(YBBookChapterModel *)charpter
{
    charpter.primaryId = [NSString stringWithFormat:@"%zd%zd",charpter.bookId,charpter.charpterId];
    BOOL success = [[YBDatabaseManager sharedInstance].database insertOrReplaceObject:charpter into:kCharpterTable];
    if (success) {
        NSLog(@"%@-存储成功",charpter.chapterName);
    }else{
        NSLog(@"%@-存储失败",charpter.chapterName);
    }
}

+(void)insertObjectsWithCharpters:(NSArray *)charpters{
    if (charpters.count == 0) {
        return;
    }
    [[YBDatabaseManager sharedInstance].database runTransaction:^BOOL{
        for (YBBookChapterModel *charpterModel in charpters) {
            YBBookChapterModel *model = [self getCharpterWithBookId:charpterModel.bookId charpterId:charpterModel.charpterId];
            if (model) {
                if (charpterModel.chapterContent.length>0) {
                    [self updateCharpterContentWithModel:charpterModel];
                }
            }else{
                [self insertObjectWithCharpters:charpterModel];
            }
        }
        return YES;
    }];
}

+(void)deleteAllCharpterWithBookId:(NSInteger)bookId{
    [[YBDatabaseManager sharedInstance].database deleteObjectsFromTable:kCharpterTable where:YBBookChapterModel.bookId.is(bookId)];
}

+(void)getCharpterWithBookId:(NSInteger)bookId complete:(void(^)(BOOL success,YBBookChapterModel *model))complete
{
    BOOL isExist = [YBBookChapterManager isExsitWithBookId:bookId];
    if (isExist) {
        NSInteger charpterId = [YBBookChapterManager getFirstCharpterIdWirhBookId:bookId];
         [self getCharpterWithBookId:bookId charpterId:charpterId complete:complete];
    }
    else{
        [self getCharpterWithBookId:bookId charpterId:0 complete:complete];
    }
}

+(void)getCharpterWithBookId:(NSInteger)bookId charpterId:(NSInteger)charpterId complete:(void(^)(BOOL success,YBBookChapterModel *model))complete{
    YBBookChapterModel *charpter = [YBBookChapterManager getCharpterWithBookId:bookId charpterId:charpterId];
    if (!charpter) {
        YBBookDetailModel *record = [YBBookDetailManager getReadRecordWithBookId:bookId];
        for (YBBookChapterModel *model in record.charpterList) {
            if (charpterId == model.charpterId) {
                charpter = model;
            }
        }
    }
    if (charpter.chapterContent.length==0) {
        [[YBNetwork sharedManager] getBookChapterDetailWithUrl:charpter.charpterUrl WithBlock:^(YBRequestResult * _Nonnull result, NSError * _Nonnull error) {
            if ([YBResultError hasErrorWithReslut:result error:error]) {
                if (complete) {
                    complete(NO,nil);
                }
                return;
            }
            charpter.chapterContent = result.data;
            [YBBookChapterManager updateCharpterContentWithModel:charpter];
            if (complete) {
                complete(YES,charpter);
            }
        }];
    }else if(charpter){
        if (complete) {
            complete(YES,charpter);
        }
    }
}
@end
