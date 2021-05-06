//
//  YBUtil.h
//  YBNovelReader
//
//  Created by 林勇彬 on 2021/4/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YBUtil : NSObject
+ (UIWindow *)getCurrentWindow;

+ (UIViewController *)getCurrentVC;
+ (UIViewController *)getCurrentVCWithView:(UIView *)control;
@end

NS_ASSUME_NONNULL_END
