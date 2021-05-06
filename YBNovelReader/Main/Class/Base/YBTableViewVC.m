//
//  YBTableViewVC.m
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/29.
//

#import "YBTableViewVC.h"

@interface YBTableViewVC ()

@end

@implementation YBTableViewVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupPullToRefresh];
    self.totalCount = @0;
    self.pageSize = @0;
    self.currentPage = @0;
}

/**
 * 设置下拉,上拉刷新
 */
- (void)setupPullToRefresh{
    UITableView *tbv = [self targetTableView];
    tbv.delegate = self;
    tbv.dataSource = self;
    tbv.separatorStyle = UITableViewCellSeparatorStyleNone;
    tbv.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reLoadData];
    }];
    tbv.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadData];
    }];
    if (!self.isCloseAutoRefresh) {
        [tbv.mj_header beginRefreshing];
    }
}

- (void)loadData {
    NSAssert(NO, @"子类必须重写该方法");
}

- (UITableView *)targetTableView {
    NSAssert(NO, @"子类必须重写该方法");
    return nil;
}

#pragma mark - 列表刷新action
- (void)reLoadData {
    self.currentPage = @0;
    self.totalCount = @0;
    [self loadData];
}

- (BOOL)isReload {
    _isReload = (self.totalCount.integerValue == 0);
    return _isReload;
}

- (BOOL)hasNextPage {
    _hasNextPage = self.totalCount.integerValue <= 0 ?
    YES : self.currentPage.integerValue < self.totalCount.integerValue;
    return _hasNextPage;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSAssert(NO, @"子类必须重写该方法");
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(NO, @"子类必须重写该方法");
    return nil;
}

#pragma mark - 懒加载
- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
@end
