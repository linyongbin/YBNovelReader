//
//  YBRequestResult.m
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/29.
//

#import "YBRequestResult.h"
#import <YYModel.h>
#import "YBBaseModel.h"
@implementation YBRequestResult

- (instancetype)initWithDictionary:(id)dict
                        modelClass:(Class _Nullable)modelClass{
    if ([dict isKindOfClass:[NSData class]] && modelClass) {
        //(YBBaseModel *)
        id data = [[modelClass alloc] analysisWithData:dict];
        if ([data isKindOfClass:[NSArray class]]) {
            self.datas = data;
        }else{
            self.data = data;
        }
    }else{
        self.data = dict;
    }
    return self;
}

@end
