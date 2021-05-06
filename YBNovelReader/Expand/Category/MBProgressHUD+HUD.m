//
//  MBProgressHUD+HUD.m
//  QHSJDS
//
//  Created by linyongbin on 2020/10/30.
//

#import "MBProgressHUD+HUD.h"
#import "YBUtil.h"
@implementation MBProgressHUD (HUD)

+ (void)showMessage:(NSString *)message{
    [self hideHUD];
    UIView *view = [YBUtil getCurrentWindow];
    MBProgressHUD *toastHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    toastHUD.userInteractionEnabled = NO;
    toastHUD.mode = MBProgressHUDModeCustomView;
    toastHUD.label.text = message;
    toastHUD.label.numberOfLines = 0;
    toastHUD.label.textColor = [UIColor ybBlackColor];
    toastHUD.bezelView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    toastHUD.removeFromSuperViewOnHide = YES;
    [toastHUD hideAnimated:YES afterDelay:2];
}

+ (void)showLoading:(NSString *)message {
    [self hideHUD];
    UIView *view = [YBUtil getCurrentWindow];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.label.numberOfLines = 0;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(hideHUD)];
    [hud addGestureRecognizer:tapGesture];
}

+ (void)showLoading{
    [self showLoading:@""];
}

#pragma mark 移除hud
+ (void)hideHUD{
    UIView *view = [YBUtil getCurrentWindow];
    [self hideHUDForView:view animated:YES];
}

@end
