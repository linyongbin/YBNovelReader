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
+(NSArray *)getBriefCharptersWithBookId:(NSInteger)bookId;

+(void)insertObjectsWithCharpters:(NSArray *)charpters;

+(void)updateCharpterContentWithModel:(YBBookChapterModel *)model;

+(void)slientDownWithBookId:(NSInteger)bookId charpterIds:(NSArray *)charpters;

/// 从第一章开始阅读返回第一章
/// @param bookId 书籍id
/// @param complete 回调
+(void)getCharpterWithBookId:(NSInteger)bookId complete:(void(^)(BOOL success,YBBookChapterModel *model))complete;

/// 从某一章节开始阅读
/// @param bookId 书籍id
/// @param charpterId 阅读的章节
/// @param complete 回调
+(void)getCharpterWithBookId:(NSInteger)bookId charpterId:(NSInteger)charpterId complete:(void(^)(BOOL success,YBBookChapterModel *model))complete;

/// 获取章节信息
/// @param bookId bookid
/// @param charpterId charpterid
+(YBBookChapterModel *)getCharpterWithBookId:(NSInteger)bookId charpterId:(NSInteger)charpterId;

/// 获取书籍的第一章Id
/// @param bookId 书籍Id
+(NSInteger)getFirstCharpterIdWirhBookId:(NSInteger)bookId;

/// 删除本地记录书籍
/// @param bookId 书籍ID
+(void)deleteAllCharpterWithBookId:(NSInteger)bookId;
@end

NS_ASSUME_NONNULL_END
