//
//  YBBookDetailManager.h
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/30.
//

#import <Foundation/Foundation.h>

@class YBBookDetailModel;
NS_ASSUME_NONNULL_BEGIN

@interface YBBookDetailManager : NSObject
/// 插入或替换书籍
+(void)insertOrReplaceModel:(YBBookDetailModel *)model;
/// 获取书籍信息
+(YBBookDetailModel *)getReadRecordWithBookId:(NSString *)bookId;
/// 更新阅读时间
+(void)updateReadTime:(YBBookDetailModel *)model;
/// 删除书籍
+(void)removeBookFromBookShelfWithBookId:(NSString *)bookId;

/// 获取所有书架上的书籍
+(NSArray *)getAllOnBookshelf;

@end

NS_ASSUME_NONNULL_END
