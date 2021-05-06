//
//  YBNetwork.h
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/29.
//

#import <Foundation/Foundation.h>
#import "YBRequestResult.h"
#import "YBResultError.h"

NS_ASSUME_NONNULL_BEGIN

@interface YBNetwork : NSObject

///单例
+ (YBNetwork *)sharedManager;

#pragma mark - 搜索书籍
/// 搜索书籍
/// @param parameters {searchkey=?}
/// @param block 回调
- (NSURLSessionDataTask *)searchBook:(NSDictionary *)parameters WithBlock:(void (^)(YBRequestResult *result,NSError * error))block;

/// 书籍详情
/// @param urlStr 书本链接
/// @param block 回调
- (NSURLSessionDataTask *)getBookDetailWithUrl:(NSString *)urlStr WithBlock:(void (^)(YBRequestResult *result,NSError * error))block;

/// 章节详情
/// @param urlStr 书本链接
/// @param block 回调
- (NSURLSessionDataTask *)getBookChapterDetailWithUrl:(NSString *)urlStr WithBlock:(void (^)(YBRequestResult *result,NSError * error))block;
@end

NS_ASSUME_NONNULL_END
