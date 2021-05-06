//
//  RDReadProgressView.h
//  Reader
//
//  Created by yuenov on 2019/11/19.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YBBookChapterModel;
@class YBBookDetailModel;
NS_ASSUME_NONNULL_BEGIN
@protocol RDReadProgressViewDelegate <NSObject>
-(void)sliderToCharpter:(YBBookChapterModel *)charpter;
@end

@interface RDReadProgressView : UIView
//章节总数
@property (nonatomic,strong) NSArray <YBBookChapterModel *> *charpters;
//阅读进度
@property (nonatomic,strong) YBBookDetailModel *book;

@property (nonatomic,weak) id<RDReadProgressViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
