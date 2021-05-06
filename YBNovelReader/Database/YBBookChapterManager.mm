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

+(NSArray *)getBriefCharptersWithBookId:(NSInteger)bookid{
    return [[YBDatabaseManager sharedInstance].database getObjectsOnResults:{YBBookChapterModel.charpterId,YBBookChapterModel.bookName,YBBookChapterModel.bookId} fromTable:kCharpterTable where:YBBookChapterModel.bookId.is(bookid) orderBy:YBBookChapterModel.charpterId.order(WCTOrderedAscending)];
}


+(BOOL)isExsitWithBookId:(NSInteger)bookid
{
    YBBookChapterModel *model = [[YBDatabaseManager sharedInstance].database getOneObjectOnResults:{YBBookChapterModel.primaryId} fromTable:kCharpterTable where:YBBookChapterModel.bookId.is(bookid)];
    return model?YES:NO;
}

+(BOOL)isExsitWithBookId:(NSInteger)bookid charpterId:(NSString *)charpterId
{
    YBBookChapterModel *model = [[YBDatabaseManager sharedInstance].database getOneObjectOnResults:{YBBookChapterModel.primaryId} fromTable:kCharpterTable where:YBBookChapterModel.bookId.is(bookid)&&YBBookChapterModel.charpterId.is(charpterId)];
    return model?YES:NO;
}


+(YBBookChapterModel *)getCharpterWithBookId:(NSInteger)bookId charpterId:(NSString *)charpterId{
    return [[YBDatabaseManager sharedInstance].database getOneObjectOfClass:YBBookChapterModel.class fromTable:kCharpterTable where:YBBookChapterModel.bookId.is(bookId)&&YBBookChapterModel.charpterId.is(charpterId)];
}

+(NSString *)getFirstCharpterIdWirhBookId:(NSInteger)bookId{
    return [[YBDatabaseManager sharedInstance].database getOneValueOnResult:YBBookChapterModel.charpterId.min() fromTable:kCharpterTable where:YBBookChapterModel.bookId.is(bookId)];
}

+ (void)updateCharpterContentWithModel:(YBBookChapterModel *)model{
    [[YBDatabaseManager sharedInstance].database updateRowsInTable:kCharpterTable onProperty:YBBookChapterModel.chapterContent withObject:model where:YBBookChapterModel.bookId.is(model.bookId)&&YBBookChapterModel.charpterId.is(model.charpterId)];
}

+(void)slientDownWithBookId:(NSInteger)bookId charpterIds:(NSArray *)charpters
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
    [[YBDatabaseManager sharedInstance].database insertOrReplaceObject:charpter into:kCharpterTable];
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

+(void)deleteAllCharpterWithBookId:(NSInteger)bookid{
    [[YBDatabaseManager sharedInstance].database deleteObjectsFromTable:kCharpterTable where:YBBookChapterModel.bookId.is(bookid)];
}

+(void)getCharpterWithBookId:(NSInteger)bookId complete:(void(^)(BOOL success,YBBookChapterModel *model))complete
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

+(void)getCharpterWithBookId:(NSInteger)bookId charpterId:(NSString *)charpterId complete:(void(^)(BOOL success,YBBookChapterModel *model))complete{
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
    }else{
        if (complete) {
            complete(YES,charpter);
        }
    }
}
@end
