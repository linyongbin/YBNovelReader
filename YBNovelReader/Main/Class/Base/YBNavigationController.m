//
//  YBNavigationController.m
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/29.
//

#import "YBNavigationController.h"

@interface YBNavigationController ()

@end

@implementation YBNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}


@end
