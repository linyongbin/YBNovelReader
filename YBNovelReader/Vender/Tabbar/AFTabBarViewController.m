//
//  MainViewController.m
//  TabBarController
//
//  Created by 李鑫浩 on 16/6/1.
//  Copyright © 2016年 李鑫浩. All rights reserved.
//

#import "AFTabBarViewController.h"
#import "YBNavigationController.h"

CGFloat const fTabBarHeight = 49.0f;
CGFloat const fTabBarHeightX = 83.0f;
@interface AFTabBarViewController ()
{
    UIImageView *m_pTabBarBgImageV;
    AFTabBarItem *m_pSelectedBtn;
}
@property (nonatomic) id logoutObserver;


@end

@implementation AFTabBarViewController{
//    UserShareInfo *userShare;
}

- (id)init
{
    if ([super init])
    {
        [self LoadTabBar];
    }
    return self;
}

-(void)dealloc {
    
//    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
//    [notificationCenter removeObserver:self.logoutObserver name:QHRECEIVER_LOGOUTNotification object:nil];
//    [notificationCenter removeObserver:self.pushObserver name:@"RECEIVE_NEW_PUSH" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.hidden = YES;
    
//    typeof(self) __weak weakSelf = self;
//    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
//    self.logoutObserver = [notificationCenter addObserverForName:QHRECEIVER_LOGOUTNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
//        [[QHGlobalManager sharedManager] logout];
//        [QHAlertView showAlertWithTitle:@"请先登录！" message:nil cancel:nil affirm:@"确认" WithController:self WithBlock:^(NSInteger index) {
//            QHLoginVC *vc = [[QHLoginVC alloc] init];
//            vc.tabBarVC = weakSelf;
//            YBNavigationController *nvc = [[YBNavigationController alloc]initWithRootViewController:vc];
//            nvc.modalPresentationStyle = UIModalPresentationFullScreen;
//            [weakSelf presentViewController:nvc animated:YES completion:nil];
//        }];
//    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self ResetTabBarItemFrame];
//    [[ApiManager sharedManager] getCartCount:@{@"version" : API_VERSION} WithBlock:^(TXRequestResult *result, NSError *error) {
//        if (result.code == 0) {
//            NSString *count = result.data[@"quantity"];
//            [self SetBadgeNum:count.integerValue withType:0 andIndex:3];
//        }
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- private method
- (void)LoadTabBar
{
    m_pTabBarBgImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - fTabBarHeight, self.view.frame.size.width, fTabBarHeight)];
    if (Device_Is_iPhoneX) {
        m_pTabBarBgImageV.frame = CGRectMake(0, self.view.frame.size.height - fTabBarHeightX, self.view.frame.size.width, fTabBarHeightX);
    }
    m_pTabBarBgImageV.backgroundColor = [UIColor whiteColor];
    m_pTabBarBgImageV.userInteractionEnabled = YES;
    [self.view addSubview:m_pTabBarBgImageV];
    
    for (NSInteger i = 0; i < 5; i ++)
    {
        AFTabBarItem *pItemBtn = [[AFTabBarItem alloc] init];
        pItemBtn.frame = CGRectZero;
        pItemBtn.fHeightScale = 1.0f;
        [pItemBtn setTitleColor:kTitleNormalColor forState:UIControlStateNormal];
        [pItemBtn setTitleColor:kTitleSelectedColo forState:UIControlStateSelected];
        pItemBtn.titleLabel.font = kTitleFont;
        pItemBtn.tag = 100 + i;
        [pItemBtn addTarget:self action:@selector(SelectViewControllerItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [m_pTabBarBgImageV addSubview:pItemBtn];
        
    }
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    line.backgroundColor = [UIColor ybLineColor];
    [m_pTabBarBgImageV addSubview:line];
}

- (void)ResetTabBarItemFrame
{
    AFTabBarItem *pItemBtn = [m_pTabBarBgImageV viewWithTag:100];
    if (![NSStringFromCGRect(pItemBtn.frame) isEqualToString:NSStringFromCGRect(CGRectZero)])
    {
        return;
    }
    CGFloat fWidth = self.view.frame.size.width / _propViewControllerClasses.count;
    for (NSInteger i = 0; i < _propViewControllerClasses.count; i ++)
    {
        AFTabBarItem *pItemBtn = [m_pTabBarBgImageV viewWithTag:100 + i];
        pItemBtn.frame = CGRectMake(fWidth * i, 0, fWidth, fTabBarHeight);
        
        if (i == 0)
        {
            [self SelectViewControllerItem:pItemBtn];
        }
        
    }
}


#pragma mark -- property method
- (void)setPropViewControllerClasses:(NSArray *)propViewControllerClasses
{
    _propViewControllerClasses = propViewControllerClasses;
    
    NSMutableArray *arrViewController = [NSMutableArray array];
    for (NSInteger i = 0; i < propViewControllerClasses.count; i ++)
    {
        if ([[propViewControllerClasses[i] class] isSubclassOfClass:[UIViewController class]])
        {
            Class class = (Class)propViewControllerClasses[i];
            UIViewController *pVC = [[class alloc]init];
            YBNavigationController *pNVC = [[YBNavigationController alloc] initWithRootViewController:pVC];
            [arrViewController addObject:pNVC];
        }
    }
    [self setViewControllers:arrViewController];
}

- (void)setPropTabBarBackGroundImage:(UIImage *)propTabBarBackGroundImage
{
//    UIImage *image = [UIImage imageNamed:@"chat_send_nor"];
//    
//    // 设置端盖的值
//    CGFloat top = image.size.height * 0.5;
//    CGFloat left = image.size.width * 0.5;
//    CGFloat bottom = image.size.height * 0.5;
//    CGFloat right = image.size.width * 0.5;
//    
//    // 设置端盖的值
//    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
//    // 设置拉伸的模式
//    UIImageResizingMode mode = UIImageResizingModeStretch;
//    
//    // 拉伸图片
//    UIImage *newImage = [image resizableImageWithCapInsets:edgeInsets resizingMode:mode];
    m_pTabBarBgImageV.image = propTabBarBackGroundImage;
}

- (void)setPropTabBarNormalImages:(NSArray *)propTabBarNormalImages
{
    _propTabBarNormalImages = propTabBarNormalImages;
    for (NSInteger i = 0; i < propTabBarNormalImages.count; i ++)
    {
        AFTabBarItem *pItemBtn = [m_pTabBarBgImageV viewWithTag:100 + i];
        [pItemBtn setImage:[UIImage imageNamed:propTabBarNormalImages[i]] forState:UIControlStateNormal];
    }
}

- (void)setPropTabBarSelectedImages:(NSArray *)propTabBarSelectedImages
{
    _propTabBarSelectedImages = propTabBarSelectedImages;
    for (NSInteger i = 0; i < propTabBarSelectedImages.count; i ++)
    {
        AFTabBarItem *pItemBtn = [m_pTabBarBgImageV viewWithTag:100 + i];
        [pItemBtn setImage:[UIImage imageNamed:propTabBarSelectedImages[i]] forState:UIControlStateSelected];
    }
}

- (void)setPropTabBarTitles:(NSArray *)propTabBarTitles
{
    _propTabBarTitles = propTabBarTitles;
    for (NSInteger i = 0; i < propTabBarTitles.count; i ++)
    {
        AFTabBarItem *pItemBtn = [m_pTabBarBgImageV viewWithTag:100 + i];
        pItemBtn.fHeightScale = 0.43f;
        [pItemBtn setTitle:propTabBarTitles[i] forState:UIControlStateNormal];
        [pItemBtn setTitle:propTabBarTitles[i] forState:UIControlStateSelected];
        [pItemBtn setTitleColor:[UIColor ybMainColor] forState:UIControlStateSelected];
    }
}

#pragma mark -- target method
- (void)SelectViewControllerItem:(AFTabBarItem *)argBtn
{
    NSLog(@"点击了 %@",argBtn.titleLabel.text);
    if (m_pSelectedBtn != argBtn){
        [self setSelectedIndex:argBtn.tag - 100];
        m_pSelectedBtn.selected = NO;
        argBtn.selected = YES;
        m_pSelectedBtn = argBtn;
        YBNavigationController *pCurrentNVC = self.selectedViewController;
        if ([pCurrentNVC.viewControllers firstObject] != [pCurrentNVC topViewController]){
            [self HideTabBar];
        }else{
            [self ShowTabBar];
        }
    }
}
#pragma mark -- public method
- (void)SelectControllerIndex:(NSInteger)argIndex
{
    AFTabBarItem *pItemBtn = [m_pTabBarBgImageV viewWithTag:argIndex + 100];
    [self SelectViewControllerItem:pItemBtn];
}

- (void)SetBadgeNum:(NSInteger)argNum withType:(AFBadgeShowType)argType andIndex:(NSInteger)argIndex
{
    AFTabBarItem *pItemBtn = [m_pTabBarBgImageV viewWithTag:argIndex + 100];
    [pItemBtn SetBadgeNum:argNum withType:argType];
}

- (void)HideTabBar
{
    YBNavigationController *pCurrentNVC = self.selectedViewController;
    UIViewController *pCurrentViewController = [pCurrentNVC.viewControllers firstObject];
    [pCurrentViewController.view addSubview:m_pTabBarBgImageV];
}

- (void)ShowTabBar
{
    [self.view addSubview:m_pTabBarBgImageV];
}

- (NSString *)getURLTarget:(NSString *)url {
    NSString *targetString;
    if (url.length > 0) {
        NSRange range = [url rangeOfString:@"?"];
        if (range.length == 0) {
            targetString = url;
        }else{
            targetString = [url substringToIndex:range.location];
        }
        NSLog(@"targetString == %@",targetString);
    }else{
        targetString = @"";
    }
    return targetString;
}

- (NSMutableDictionary *)getURLParameters:(NSString *)url {
    // 查找参数
    NSRange range = [url rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 截取参数
    NSString *parametersString = [url substringFromIndex:range.location + 1];
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            id existValue = [params valueForKey:key];
            if (existValue != nil) {
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    [params setValue:items forKey:key];
                } else {
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
            } else {
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    }else {
        // 单个参数
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        // 设置值
        [params setValue:value forKey:key];
    }
    return params;
}

@end
