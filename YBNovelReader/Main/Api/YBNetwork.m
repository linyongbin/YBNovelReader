//
//  YBNetwork.m
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/29.
//

#import "YBNetwork.h"
#import "YBApiManager.h"

@implementation YBNetwork

///单例
+ (YBNetwork *)sharedManager {
    static YBNetwork *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YBNetwork alloc] init];
    });
    return manager;
}

#pragma mark - 搜索书籍
/// 搜索书籍
/// @param parameters {searchkey=?}
/// @param block 回调
- (NSURLSessionDataTask *)searchBook:(NSDictionary *)parameters WithBlock:(void (^)(YBRequestResult *result,NSError * error))block{
    return [[YBApiManager sharedManager] postStartRequestWithApiPath:@"modules/article/waps.php" isJsonParameter:NO parameters:parameters modelClass:NSClassFromString(@"YBSearchModel") WithBlock:block];
}

/// 书籍详情
/// @param urlStr 书本链接
/// @param block 回调
- (NSURLSessionDataTask *)getBookDetailWithUrl:(NSString *)urlStr WithBlock:(void (^)(YBRequestResult *result,NSError * error))block{
    return [[YBApiManager sharedManager] getStartRequestWithApiPath:urlStr isJsonParameter:NO parameters:nil modelClass:NSClassFromString(@"YBBookDetailModel") WithBlock:block];
}

/// 章节详情
/// @param urlStr 书本链接
/// @param block 回调
- (NSURLSessionDataTask *)getBookChapterDetailWithUrl:(NSString *)urlStr WithBlock:(void (^)(YBRequestResult *result,NSError * error))block{
    return [[YBApiManager sharedManager] getStartRequestWithApiPath:urlStr isJsonParameter:NO parameters:nil modelClass:NSClassFromString(@"YBBookChapterModel") WithBlock:block];
}
@end
