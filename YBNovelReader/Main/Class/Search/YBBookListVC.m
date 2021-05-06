//
//  YBBookListVC.m
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/29.
//

#import "YBBookListVC.h"
#import "YBSearchCell.h"
#import "YBBookDetailVC.h"

@interface YBBookListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation YBBookListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"搜索结果";
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
    YBSearchModel *model = self.dataList[indexPath.row];
    YBBookDetailVC *vc = [[YBBookDetailVC alloc] init];
    vc.bookUrl = model.bookUrl;
    [self.navigationController pushViewController:vc animated:YES];
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
    }
    return _tableView;
}

@end
