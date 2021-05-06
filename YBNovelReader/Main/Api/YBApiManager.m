//
//  YBApiManager.m
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/29.
//

#import "YBApiManager.h"
#import "AFNetworking.h"

@interface YBApiManager()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation YBApiManager


- (AFHTTPSessionManager *)sessionManager{
    if (!_sessionManager) {
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:QHBaseUrl]];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/html", @"text/plain",@"application/x-javascript",@"application/javascript",nil];

        /**
         - `Accept-Language` with the contents of `NSLocale +preferredLanguages`
         - `User-Agent` with the contents of various bundle identifiers and OS designations
         @discussion To add or remove default request headers, use `setValue:forHTTPHeaderField:`.*/
        [_sessionManager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
        [_sessionManager.requestSerializer setValue:@"zh-CN,zh;q=0.9,en-US;q=0.8,en;q=0.7" forHTTPHeaderField:@"Accept-Language"];
//        [_sessionManager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9" forHTTPHeaderField:@"Accept"];
//        [_sessionManager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//        [_sessionManager.requestSerializer setValue:@"_abcde_qweasd=0; bdshare_firstime=1619571426073; UM_distinctid=17917a8e60d4af-04d8ab7f252a0e-11396054-240000-17917a8e60e685; CNZZDATA1253551727=189406830-1619596469-%7C1619596469; Hm_lvt_169609146ffe5972484b0957bd1b46d6=1619571426,1619578769,1619668448; Hm_lpvt_169609146ffe5972484b0957bd1b46d6=1619672303" forHTTPHeaderField:@"Cookie"];
    }
    return _sessionManager;
}

+ (YBApiManager *)sharedManager {
    static YBApiManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YBApiManager alloc] init];
    });
    return manager;
}

- (AFHTTPSessionManager *)buildAFHTTPSessionManager:(BOOL)isJsonParameter {
//    if (isJsonParameter) {
//        self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:0];
//    }else{
//        self.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    }
    self.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
//    if ([QHGlobalManager sharedManager].token.length) {
//        [self.sessionManager.requestSerializer setValue:[QHGlobalManager sharedManager].token forHTTPHeaderField:@"Authorization"];
//    }
//    
//    [self.sessionManager.requestSerializer setValue:@"04e6abb0c8cc448a91061e49ed50a4eb" forHTTPHeaderField:@"x-app-id"];
//    [self.sessionManager.requestSerializer setValue:@"04e6abb0c8cc448a91061e49ed50a4eb" forHTTPHeaderField:@"x-app-secret"];
    return self.sessionManager;
}

- (NSURLSessionDataTask *)getStartRequestWithApiPath:(NSString *)apiPath isJsonParameter:(BOOL)isJsonParameter parameters:(NSDictionary * _Nullable)parameters modelClass:(Class _Nullable)modelClass WithBlock:(void (^)(YBRequestResult *result, NSError * error))block {
    AFHTTPSessionManager *sessionManager = [self buildAFHTTPSessionManager:isJsonParameter];
    NSLog(@"请求头：%@",sessionManager.requestSerializer.HTTPRequestHeaders);
    NSLog(@"\nURL地址:%@%@\n请求字段:%@",sessionManager.baseURL,apiPath,parameters);
    return [sessionManager GET:apiPath parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"URL:%@",apiPath);
        if (block) {
            YBRequestResult *model = [[YBRequestResult alloc] initWithDictionary:responseObject modelClass:modelClass];
            block(model, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
        if (block) {
            block(nil, error);
        }
    }];
}

- (NSURLSessionDataTask *)postStartRequestWithApiPath:(NSString *)apiPath isJsonParameter:(BOOL)isJsonParameter parameters:(NSDictionary * _Nullable)parameters modelClass:(Class _Nullable)modelClass WithBlock:(void (^)(YBRequestResult *result, NSError * error))block {
    AFHTTPSessionManager *sessionManager = [self buildAFHTTPSessionManager:isJsonParameter];
    NSLog(@"请求头：%@",sessionManager.requestSerializer.HTTPRequestHeaders);
    NSLog(@"\nURL地址:%@%@\n请求字段:%@",sessionManager.baseURL,apiPath,parameters);
    return [sessionManager POST:apiPath parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"URL:%@",apiPath);
        if (block) {
            YBRequestResult *model = [[YBRequestResult alloc] initWithDictionary:responseObject modelClass:modelClass];
            block(model, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
        if (block) {
            block(nil, error);
        }
    }];
}

@end
