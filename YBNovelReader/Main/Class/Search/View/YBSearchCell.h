//
//  YBSearchCell.h
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/29.
//

#import "YBBaseTableViewCell.h"
#import "YBSearchModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YBSearchCell : YBBaseTableViewCell
@property (nonatomic, strong) YBSearchModel *model;
@end

NS_ASSUME_NONNULL_END
