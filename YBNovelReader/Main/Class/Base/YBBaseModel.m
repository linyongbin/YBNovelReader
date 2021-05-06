//
//  YBBaseModel.m
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/29.
//

#import "YBBaseModel.h"
#import <YYModel.h>
@implementation YBBaseModel

- (id)analysisWithData:(id)data{
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}

- (NSUInteger)hash {
    return [self yy_modelHash];
}

- (BOOL)isEqual:(id)object {
    return [self yy_modelIsEqual:object];
}

@end
