//
//  RDReadTopBar.h
//  Reader
//
//  Created by yuenov on 2019/11/13.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBBookDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol RDReadTopBarDelegate <NSObject>
-(void)backAction;
-(void)downloadAction;
-(void)qusetionAction;
-(void)reloadAction;
@end

@interface RDReadTopBar : UIView
@property (nonatomic,weak) id<RDReadTopBarDelegate>delegate;
//阅读进度
@property (nonatomic,strong) YBBookDetailModel *record;
@end

NS_ASSUME_NONNULL_END
