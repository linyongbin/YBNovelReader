//
//  YBApiManager.h
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/29.
//

#import <Foundation/Foundation.h>
#import "YBRequestResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface YBApiManager : NSObject


/// 单例
+ (YBApiManager *)sharedManager;

/// GET请求
/// @param apiPath url地址
/// @param isJsonParameter 是否是json数据请求
/// @param parameters 请求参数
/// @param modelClass 回调数据模型
/// @param block 回调
- (NSURLSessionDataTask *)getStartRequestWithApiPath:(NSString *)apiPath isJsonParameter:(BOOL)isJsonParameter parameters:(NSDictionary * _Nullable)parameters modelClass:(Class _Nullable)modelClass WithBlock:(void (^)(YBRequestResult *result ,NSError * error))block;

/// POST请求
/// @param apiPath url地址
/// @param isJsonParameter 是否是json数据请求
/// @param parameters 请求参数
/// @param modelClass 回调数据模型
/// @param block 回调
- (NSURLSessionDataTask *)postStartRequestWithApiPath:(NSString *)apiPath isJsonParameter:(BOOL)isJsonParameter parameters:(NSDictionary * _Nullable)parameters modelClass:(Class _Nullable)modelClass WithBlock:(void (^)(YBRequestResult *result ,NSError * error))block;

@end

NS_ASSUME_NONNULL_END
