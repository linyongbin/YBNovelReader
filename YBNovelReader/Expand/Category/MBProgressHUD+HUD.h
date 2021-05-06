//
//  MBProgressHUD+HUD.h
//  QHSJDS
//
//  Created by linyongbin on 2020/10/30.
//

#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (HUD)
#pragma mark 在指定的view上显示hud
+ (void)showMessage:(NSString *)message;

#pragma mark 在window上显示hud
+ (void)showLoading;
+ (void)showLoading:(NSString *)message;

#pragma mark 移除hud
+ (void)hideHUD;
@end

NS_ASSUME_NONNULL_END
