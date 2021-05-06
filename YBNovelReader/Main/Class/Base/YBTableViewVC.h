//
//  YBTableViewVC.h
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/29.
//

#import "YBBaseVC.h"
#import "MJRefresh.h"

NS_ASSUME_NONNULL_BEGIN

@interface YBTableViewVC : YBBaseVC<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, copy) NSNumber *pageSize;
@property (nonatomic, copy) NSNumber *totalCount;
@property (nonatomic, copy) NSNumber *currentPage;
@property (nonatomic, assign) BOOL isReload;
@property (nonatomic, assign) BOOL hasNextPage;
/// 是否关闭自动刷新功能，默认NO
@property (nonatomic, assign) BOOL isCloseAutoRefresh;

- (void)reLoadData;
- (void)setupPullToRefresh;
@end

NS_ASSUME_NONNULL_END
