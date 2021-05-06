//
//  YBBookrackVC.m
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/29.
//

#import "YBBookrackVC.h"
#import "YBSearchCell.h"
#import "YBBookDetailVC.h"
#import "YBBookDetailManager.h"
#import "YBBookDetailModel.h"
#import "MJRefresh.h"
#import "YBBookReadPageVC.h"
#import "AFTabBarViewController.h"

@interface YBBookrackVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation YBBookrackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"书架";
    [self setupView];
}

- (void)setupView{
    typeof(self) __weak weakSelf = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.top.mas_equalTo(SafeAreaTopHeight);
        make.bottom.mas_equalTo(-SafeAreaBottomHeight);
    }];
    [self reLoadData];
}

- (void)reLoadData{
    [self.tableView.mj_header endRefreshing];
    [self.dataList removeAllObjects];
    [self.dataList addObjectsFromArray:[YBBookDetailManager getAllOnBookshelf]];
    [self.tableView reloadData];
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *orderListCell = @"YBSearchCell";
    YBSearchCell *cell = (YBSearchCell *)[tableView dequeueReusableCellWithIdentifier:orderListCell];
    if (cell == nil) {
        cell = [[YBSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderListCell];
    }
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YBBookDetailModel *model = self.dataList[indexPath.row];
    if (model.charpterModel) {
        YBBookReadPageVC *controller = [[YBBookReadPageVC alloc] init];
        controller.bookDetail = model;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        YBBookDetailVC *vc = [[YBBookDetailVC alloc] init];
        vc.bookUrl = model.bookUrl;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [(AFTabBarViewController *)self.tabBarController HideTabBar];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    typeof(self) __weak weakSelf = self;
    YBBookDetailModel *model = self.dataList[indexPath.row];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [YBBookDetailManager removeBookFromBookShelfWithBookId:model.bookId];
        [weakSelf.dataList removeObject:model];
        [weakSelf.tableView reloadData];
    }];
    deleteAction.backgroundColor = [UIColor ybMainColor];
    return @[deleteAction];
}

#pragma mark - 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        //暂定列表宽高，以防Masonry警告⚠️
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor ybBackGroundColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        typeof(self) __weak weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf reLoadData];
        }];
    }
    return _tableView;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
@end
