//
//  YBBookChapterManager.h
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/30.
//

#import <Foundation/Foundation.h>
@class YBBookChapterModel;
NS_ASSUME_NONNULL_BEGIN

@interface YBBookChapterManager : NSObject

/// 不包含章节内容的章节信息
+(NSArray *)getBriefCharptersWithBookId:(NSString *)bookId;

+(void)insertObjectsWithCharpters:(NSArray *)charpters;

+(void)updateCharpterContentWithModel:(YBBookChapterModel *)model;

+(void)slientDownWithBookId:(NSString *)bookId charpterIds:(NSArray *)charpters;

/// 从第一章开始阅读返回第一章
/// @param bookId 书籍id
/// @param complete 回调
+(void)getCharpterWithBookId:(NSString *)bookId complete:(void(^)(BOOL success,YBBookChapterModel *model))complete;

/// 从某一章节开始阅读
/// @param bookId 书籍id
/// @param charpterId 阅读的章节
/// @param complete 回调
+(void)getCharpterWithBookId:(NSString *)bookId charpterId:(NSString *)charpterId complete:(void(^)(BOOL success,YBBookChapterModel *model))complete;

/// 获取章节信息
/// @param bookId bookid
/// @param charpterId charpterid
+(YBBookChapterModel *)getCharpterWithBookId:(NSString *)bookId charpterId:(NSString *)charpterId;

/// 获取书籍的第一章Id
/// @param bookId 书籍Id
+(NSString *)getFirstCharpterIdWirhBookId:(NSString *)bookId;

/// 删除本地记录书籍
/// @param bookid 书籍ID
+(void)deleteAllCharpterWithBookId:(NSString *)bookId;
@end

NS_ASSUME_NONNULL_END
