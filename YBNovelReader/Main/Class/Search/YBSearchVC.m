//
//  YBSearchVC.m
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/29.
//

#import "YBSearchVC.h"
#import "YBSearchModel.h"
#import "YBBookListVC.h"
#import "AFTabBarViewController.h"

@interface YBSearchVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *searchView;
@end

@implementation YBSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"搜索";
    [self setupView];
}

- (void)setupView{
    typeof(self) __weak weakSelf = self;
    [self.view addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(30);
    }];
}

#pragma mark - api
- (void)searchBook{
    typeof(self) __weak weakSelf = self;
    [MBProgressHUD showLoading];
    [[YBNetwork sharedManager] searchBook:@{@"searchkey":self.searchView.text?:@""} WithBlock:^(YBRequestResult * _Nonnull result, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        if ([YBResultError hasErrorWithReslut:result error:error]) {
            return;
        }
        NSArray *books = result.datas;
        NSLog(@"books:%zd",books.count);
        YBBookListVC *vc = [[YBBookListVC alloc] init];
        vc.dataList = books;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        [(AFTabBarViewController *)self.tabBarController HideTabBar];
    }];
}

#pragma mark - 代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchBook];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 懒加载
- (UITextField *)searchView{
    if (!_searchView) {
        _searchView = [[UITextField alloc] init];
        _searchView.font = [UIFont systemFontOfSize:14];
        _searchView.textColor = [UIColor ybBlackColor];
        _searchView.placeholder = @"请输入书籍名称";
        _searchView.returnKeyType = UIReturnKeySearch;
        _searchView.delegate = self;
        _searchView.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _searchView;
}
@end
