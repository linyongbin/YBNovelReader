//
//  YBBaseModel.h
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YBBaseModel : NSObject <NSCopying, NSCoding>

- (id)analysisWithData:(id)data;

@end

NS_ASSUME_NONNULL_END
