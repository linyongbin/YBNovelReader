//
//  RDMenuView.h
//  Reader
//
//  Created by yuenov on 2019/11/13.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDReadToolBar.h"
#import "RDReadTopBar.h"
@class YBBookDetailModel;
@class YBBookChapterModel;
@class RDMenuView;
NS_ASSUME_NONNULL_BEGIN
@protocol RDReadCatalogViewDelegate;
@protocol RDReadProgressViewDelegate;
@protocol RDReadTopBarDelegate;
@protocol RDReadSetViewDelegate;
@protocol RDMenuViewDelegate <NSObject,RDReadCatalogViewDelegate,RDReadProgressViewDelegate,RDReadTopBarDelegate,RDReadSetViewDelegate>
-(void)cancelShowMenu:(RDMenuView *)menu;
@end


@interface RDMenuView : UIView
@property (nonatomic,strong) RDReadToolBar *toolBar;
@property (nonatomic,strong) RDReadTopBar *topBar;
@property (nonatomic,weak) id<RDMenuViewDelegate> delegate;
/**********Data Source*********/
//章节总数
@property (nonatomic,strong) NSArray <YBBookChapterModel *> *charpters;
//阅读进度
@property (nonatomic,strong) YBBookDetailModel *book;
-(void)showInView:(UIView *)view;
-(void)dismiss;
-(void)showInView:(UIView *)view complete:(void(^)(void))complete;
-(void)dismissComplete:(void(^)(void))complete;
@end

NS_ASSUME_NONNULL_END
