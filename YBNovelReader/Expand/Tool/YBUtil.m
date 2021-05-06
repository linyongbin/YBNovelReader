//
//  YBUtil.m
//  YBNovelReader
//
//  Created by 林勇彬 on 2021/4/29.
//

#import "YBUtil.h"

@implementation YBUtil

#pragma mark - 控制器
+ (UIWindow *)getCurrentWindow{
    if (@available(iOS 13.0, *)) {
        return [UIApplication sharedApplication].windows.firstObject;
    }else{
        return [UIApplication sharedApplication].keyWindow;
    }
}

+ (UIViewController *)getCurrentVC {
    UIWindow *window = [self getCurrentWindow];
    if (!window) {
        return nil;
    }
    UIView *tempView;
    for (UIView *subview in window.subviews) {
        if ([[subview.classForCoder description] isEqualToString:@"UILayoutContainerView"]) {
            tempView = subview;
            break;
        }
    }
    if (!tempView) {
        tempView = [window.subviews lastObject];
    }
    
    id nextResponder = [tempView nextResponder];
    while (![nextResponder isKindOfClass:[UIViewController class]] || [nextResponder isKindOfClass:[UINavigationController class]] || [nextResponder isKindOfClass:[UITabBarController class]]) {
        tempView =  [tempView.subviews firstObject];
        
        if (!tempView) {
            return nil;
        }
        nextResponder = [tempView nextResponder];
    }
    return  (UIViewController *)nextResponder;
}

+ (UIViewController *)getCurrentVCWithView:(UIView *)control{
    UIResponder *next = control.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next);
    return nil;
}

@end
