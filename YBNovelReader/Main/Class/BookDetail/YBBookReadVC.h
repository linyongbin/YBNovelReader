//
//  YBBookReadVC.h
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/30.
//

#import "YBBaseVC.h"
@class YBBookChapterModel,YBBookReadVC;

NS_ASSUME_NONNULL_BEGIN

@protocol YBBookReadVCDelegate <NSObject>

-(void)lastPage:(YBBookReadVC *)controller;

-(void)nextPage:(YBBookReadVC *)controller;

-(void)invokeMenu:(YBBookReadVC *)controller;

@end

@interface YBBookReadVC : YBBaseVC

@property (nonatomic,assign,readonly) NSInteger page;   //当前阅读的页数
@property (nonatomic,assign,readonly) NSInteger charpterIndex; //当前阅读章节的索引

@property (nonatomic,strong,readonly) NSAttributedString *content;  //内容
@property (nonatomic,strong,readonly) NSString *charpter;       //章节
@property (nonatomic,assign,readonly) NSInteger totalPage;      //总页数
@property (nonatomic,assign,readonly) NSInteger totalCharpter;  //总章节

@property (nonatomic,strong) YBBookChapterModel *charpterModel;    //当前阅读的章节
@property (nonatomic,strong) NSAttributedString *charpterContent;   //当前章节的所有内容包括标题
@property (nonatomic,strong) NSArray *pages;        //分页信息

@property (nonatomic,weak) id<YBBookReadVCDelegate> delegate;

/// 设置内容显示
/// @param charpter 章节
/// @param content 内容
/// @param page 当前页数
/// @param totalPage 章节总页数
/// @param chaprterIndex 当前章节数
/// @param totalCharpter 总章节数
-(void)setCharpter:(NSString *)charpter content:(NSAttributedString *)content page:(NSInteger)page totalPage:(NSInteger)totalPage charpterIndex:(NSInteger)chaprterIndex totalCharpter:(NSInteger)totalCharpter;
@end

NS_ASSUME_NONNULL_END
