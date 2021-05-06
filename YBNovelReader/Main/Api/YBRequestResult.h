//
//  YBRequestResult.h
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YBRequestResult : NSObject

@property (nonatomic) id data;
@property (nonatomic, strong) NSArray *datas;


- (instancetype)initWithDictionary:(id)dict
                        modelClass:(Class _Nullable)modelClass;

@end

NS_ASSUME_NONNULL_END
