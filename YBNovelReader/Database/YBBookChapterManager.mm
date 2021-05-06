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

@implementation YBBookChapterManager

+(NSArray *)getBriefCharptersWithBookId:(NSString *)bookId{
    return [[YBDatabaseManager sharedInstance].database getObjectsOnResults:{YBBookChapterModel.charpterId,YBBookChapterModel.bookName,YBBookChapterModel.bookId} fromTable:kCharpterTable where:YBBookChapterModel.bookId.is(bookId) orderBy:YBBookChapterModel.charpterId.order(WCTOrderedAscending)];
}

+(BOOL)isExsitWithBookId:(NSString *)bookId
{
    YBBookChapterModel *model = [[YBDatabaseManager sharedInstance].database getOneObjectOnResults:{YBBookChapterModel.primaryId} fromTable:kCharpterTable where:YBBookChapterModel.bookId.is(bookId)];
    return model?YES:NO;
}

+(BOOL)isExsitWithBookId:(NSString *)bookId charpterId:(NSString *)charpterId
{
    YBBookChapterModel *model = [[YBDatabaseManager sharedInstance].database getOneObjectOnResults:{YBBookChapterModel.primaryId} fromTable:kCharpterTable where:YBBookChapterModel.bookId.is(bookId)&&YBBookChapterModel.charpterId.is(charpterId)];
    return model?YES:NO;
}


+(YBBookChapterModel *)getCharpterWithBookId:(NSString *)bookId charpterId:(NSString *)charpterId{
    return [[YBDatabaseManager sharedInstance].database getOneObjectOfClass:YBBookChapterModel.class fromTable:kCharpterTable where:YBBookChapterModel.bookId.is(bookId)&&YBBookChapterModel.charpterId.is(charpterId)];
}

+(NSString *)getFirstCharpterIdWirhBookId:(NSString *)bookId{
    return [[YBDatabaseManager sharedInstance].database getOneValueOnResult:YBBookChapterModel.charpterId.min() fromTable:kCharpterTable where:YBBookChapterModel.bookId.is(bookId)];
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

+(void)slientDownWithBookId:(NSString *)bookId charpterIds:(NSArray *)charpters
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //判断章节是否存在，如果存在不下载
        NSMutableArray *downloads = [NSMutableArray array];
        for (NSString *charpter in charpters) {
            YBBookChapterModel *model = [YBBookChapterManager getCharpterWithBookId:bookId charpterId:charpter];
            if (model.chapterContent.length==0) {
                [downloads addObject:charpter];
                [[YBNetwork sharedManager] getBookChapterDetailWithUrl:model.charpterId WithBlock:^(YBRequestResult * _Nonnull result, NSError * _Nonnull error) {
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
            }
            else{
                [self insertObjectWithCharpters:charpterModel];
            }
        }
        return YES;
    }];
}

+(void)deleteAllCharpterWithBookId:(NSString *)bookId{
    [[YBDatabaseManager sharedInstance].database deleteObjectsFromTable:kCharpterTable where:YBBookChapterModel.bookId.is(bookId)];
}

+(void)getCharpterWithBookId:(NSString *)bookId complete:(void(^)(BOOL success,YBBookChapterModel *model))complete
{
    BOOL isExist = [YBBookChapterManager isExsitWithBookId:bookId];
    if (isExist) {
        NSString *charpterId = [YBBookChapterManager getFirstCharpterIdWirhBookId:bookId];
         [self getCharpterWithBookId:bookId charpterId:charpterId complete:complete];
    }
    else{
        [self getCharpterWithBookId:bookId charpterId:@"" complete:complete];
    }
}

+(void)getCharpterWithBookId:(NSString *)bookId charpterId:(NSString *)charpterId complete:(void(^)(BOOL success,YBBookChapterModel *model))complete{
    YBBookChapterModel *charpter = [YBBookChapterManager getCharpterWithBookId:bookId charpterId:charpterId];
    if (charpter.chapterContent.length==0) {
        [[YBNetwork sharedManager] getBookChapterDetailWithUrl:charpterId WithBlock:^(YBRequestResult * _Nonnull result, NSError * _Nonnull error) {
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
