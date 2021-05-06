//
//  YBResultError.h
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YBResultError : NSObject
+ (BOOL)hasErrorWithReslut:(id)data error:(NSError *)error;
@end

NS_ASSUME_NONNULL_END
