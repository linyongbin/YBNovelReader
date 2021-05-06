//
//  UIColor+APP.h
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (APP)
/// 0x0D3B4B
+ (UIColor *)ybMainColor;
/// 0x333333
+ (UIColor *)ybBlackColor;
/// 0x666666
+ (UIColor *)ybDarkgrayColor;
/// 0x999999
+ (UIColor *)ybGrayColor;
/// 0xE5E5E5
+ (UIColor *)ybLineColor;
/// 0xEFEFF4
+ (UIColor *)ybBackGroundColor;

+ (UIColor *)colorWithMacHexString:(NSString *)hexString;
@end

NS_ASSUME_NONNULL_END
