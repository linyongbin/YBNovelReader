//
//  YBBookDetailManager.m
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/30.
//

#import "YBBookDetailManager.h"
#import "YBBookDetailModel.h"
#import "YBBookDetailModel+WCTTableCoding.h"
#import "YBDatabaseManager.h"
#import "YBBookChapterManager.h"

@implementation YBBookDetailManager

+(void)insertOrReplaceModel:(YBBookDetailModel *)model{
    YBBookDetailModel *bookModel = [self getLastBook];
    if ([bookModel.bookName isEqualToString:model.bookName]) {
        return;
    }
        
    model.bookId = bookModel?bookModel.bookId+1:1;
    model.readTime = [NSDate date].timeIntervalSince1970;
    [[YBDatabaseManager sharedInstance].database insertOrReplaceObject:model into:kBookrackTable];
    [YBBookChapterManager insertObjectsWithCharpters:model.charpterList];
}

+(void)updateBookshelfState:(YBBookDetailModel *)model{
    model.readTime = [NSDate date].timeIntervalSince1970;
    [[YBDatabaseManager sharedInstance].database updateRowsInTable:kBookrackTable onProperties:{YBBookDetailModel.readTime} withObject:model where:YBBookDetailModel.bookId.is(model.bookId)];
}

+(void)updateReadTime:(YBBookDetailModel *)model{
    model.readTime = [NSDate date].timeIntervalSince1970;
    [[YBDatabaseManager sharedInstance].database updateRowsInTable:kBookrackTable onProperties:YBBookDetailModel.readTime withObject:model where:YBBookDetailModel.bookId.is(model.bookId)];
}

+(NSArray *)getAllOnBookshelf{
    return [[YBDatabaseManager sharedInstance].database getObjectsOfClass:YBBookDetailModel.class fromTable:kBookrackTable orderBy:YBBookDetailModel.readTime.order(WCTOrderedDescending)];
}

+(YBBookDetailModel *)getLastBook{
    return [[YBDatabaseManager sharedInstance].database getOneObjectOnResults:{YBBookDetailModel.bookId.max(),YBBookDetailModel.bookName} fromTable:kBookrackTable];
}

/// 获取书籍信息
+(YBBookDetailModel *)getReadRecordWithBookId:(NSInteger)bookid{
    return [[YBDatabaseManager sharedInstance].database getOneObjectOfClass:YBBookDetailModel.class fromTable:kBookrackTable where:YBBookDetailModel.bookId.is(bookid)];
}
/// 删除书籍
+(void)removeBookFromBookShelfWithBookId:(NSInteger)bookid{
    [[YBDatabaseManager sharedInstance].database deleteObjectsFromTable:kBookrackTable where:YBBookDetailModel.bookId.is(bookid)];
    [YBBookChapterManager deleteAllCharpterWithBookId:bookid];
}

@end
