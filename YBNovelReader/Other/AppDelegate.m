//
//  AppDelegate.m
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/29.
//

#import "AppDelegate.h"
#import "AFTabBarViewController.h"
#import "YBSearchVC.h"
#import "YBBookrackVC.h"
#import <TABAnimated.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 设置主窗口,并设置根控制器
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self TABAnimatedConfig];
    [self showMainVC];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)showMainVC{
    AFTabBarViewController *pMainVC = [[AFTabBarViewController alloc] init];
    pMainVC.propViewControllerClasses = @[NSClassFromString(@"YBSearchVC"),NSClassFromString(@"YBBookrackVC")];
    pMainVC.propTabBarNormalImages = @[@"tabbar_Home_unSelected",@"tabbar_library_unSelected"];
    pMainVC.propTabBarSelectedImages = @[@"tabbar_Home_selected",@"tabbar_library_selected"];
    pMainVC.propTabBarTitles = @[@"搜索",@"书架"];
    self.window.rootViewController = pMainVC;
}

- (void)TABAnimatedConfig{
    [[TABAnimated sharedAnimated] initWithOnlySkeleton];
//    [TABAnimated sharedAnimated].openAnimationTag = YES;
}
@end
