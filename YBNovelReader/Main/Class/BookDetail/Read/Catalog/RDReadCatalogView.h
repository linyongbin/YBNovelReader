//
//  RDReadCatalogView.h
//  Reader
//
//  Created by yuenov on 2019/11/20.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YBBookDetailModel;
@class YBBookChapterModel;
@protocol RDReadCatalogCellDelegate;
NS_ASSUME_NONNULL_BEGIN
@protocol RDReadCatalogViewDelegate <NSObject,RDReadCatalogCellDelegate>

@end

@interface RDReadCatalogView : UIView
@property (nonatomic,strong) NSArray <YBBookChapterModel *>*charpters;
@property (nonatomic,strong) YBBookDetailModel *book;
@property (nonatomic,weak) id <RDReadCatalogViewDelegate>delegate;
@property (nonatomic,copy) void(^clickBg)(void);
-(void)show;
-(void)dismiss;
@end

NS_ASSUME_NONNULL_END
