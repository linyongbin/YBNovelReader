//
//  YBBookReadPageVC.m
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/30.
//

#import "YBBookReadPageVC.h"
#import "YBBookReadVC.h"
#import "YBBookChapterModel.h"
#import "YBReadParser.h"
#import "YBBookDetailManager.h"
#import "YBBookChapterManager.h"
#import <objc/message.h>

@implementation UIPageViewController (EnlargeTapRegion)
-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return NO;
    }
    return YES;
}

//- (id)_validatedViewControllersForTransitionWithViewControllers:(id)arg1 animated:(bool)arg2 {
//    id ret = nil;
//    @try {
//        Class spc = self.superclass;
//        SEL vsel = @selector(_validatedViewControllersForTransitionWithViewControllers:animated:);
//        if (vsel && [spc instancesRespondToSelector:vsel]) {
//            struct objc_super sp = {self,spc};
//            ret = ((id(*)(struct objc_super *,SEL,id,BOOL))objc_msgSendSuper)(&sp, vsel,arg1,arg2);
//        }
//    } @catch (NSException *exception) {
//        NSLog(@"%@",exception);
//    } @finally {
//        NSLog(@"翻页");
//    }
//    return ret;
//}

@end


@interface RDReadPageView : UIView
@property (nonatomic,strong) UIView *brightnessView;
@end

@implementation RDReadPageView
-(void)addSubview:(UIView *)view
{
    if (view != self.brightnessView && self.brightnessView) {
        NSInteger index = [self.subviews indexOfObject:self.brightnessView];
        if (index != NSNotFound) {
            [self insertSubview:view atIndex:index];
        }
        else{
            [super addSubview:view];
        }
    }
    else{
        [super addSubview:view];
    }
}
@end

@interface YBBookReadPageVC ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,YBBookReadVCDelegate>
@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (nonatomic,strong) NSArray <YBBookChapterModel *>*charpters;    //简短的章节信息，不包含内容
@property (nonatomic,strong) UIView *brightnessView;
@end

@implementation YBBookReadPageVC

-(void)loadView
{
    UIView *view = [[RDReadPageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = view;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.navigationController.navigationBar.hidden) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    [self addChildViewController:self.pageViewController];
    self.charpters = [YBBookChapterManager getBriefCharptersWithBookId:self.bookDetail.bookId];
    self.charpters = self.charpters.count?self.charpters:self.bookDetail.charpterList;
    [self initSteup];
    
    
    
//    RDReadPageView *view = (RDReadPageView *)self.view;
//    view.brightnessView = self.brightnessView;
//
//    [self.view addSubview:self.brightnessView];
    
}


#pragma mark - load
-(void)initSteup{
    [YBReadParser paginateWithContent:self.bookDetail.charpterModel.chapterContent charpter:self.bookDetail.charpterModel.chapterName bounds:CGRectMake(0, 0, ScreenWidth-kLeftMargin-kRightMargin, ScreenHeight-kTopMargin-kBottomMargin) complete:^(NSAttributedString * _Nonnull content, NSArray * _Nonnull pages) {
        [self.pageViewController setViewControllers:@[[self p_creatReadController:self.bookDetail.charpterModel.chapterName content:[self p_getCurPageContentWithContent:content page:[self p_safePage:self.bookDetail.page totalPages:pages.count] pages:pages] page:[self p_safePage:self.bookDetail.page totalPages:pages.count] totalPage:pages.count charpterIndex:[self p_getCurCharpterWithCharpter:self.bookDetail.charpterModel] totalCharpter:self.charpters.count charpterModel:self.bookDetail.charpterModel charpterContent:content pages:pages]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }];
    //默认加载上一章或下一章的数据
    [self p_downloads];
}

-(void)p_downloads{
    NSInteger index = [self p_getCurCharpterWithCharpter:self.bookDetail.charpterModel];
    NSMutableArray *charpters = [NSMutableArray array];
    if (index == 0) {
        //第一页
        if (self.charpters.count>2) {
            YBBookChapterModel *model1 = self.charpters[1];
            YBBookChapterModel *model2 = self.charpters[2];
            [charpters addObjectsFromArray:@[@(model1.charpterId),@(model2.charpterId)]];
        }
    }
    else if (index == self.charpters.count-1){
        //最后一页
        if (self.charpters.count>2) {
            YBBookChapterModel *model1 = self.charpters[index-2];
            YBBookChapterModel *model2 = self.charpters[index-1];
            [charpters addObjectsFromArray:@[@(model1.charpterId),@(model2.charpterId)]];
        }
    }
    else{
        //中间页
        YBBookChapterModel *model1 = self.charpters[index-1];
        YBBookChapterModel *model2 = self.charpters[index+1];
        [charpters addObjectsFromArray:@[@(model1.charpterId),@(model2.charpterId)]];
    }
    [YBBookChapterManager slientDownWithBookId:self.bookDetail.bookId charpterIds:charpters.copy];
}

-(void)p_saveRecord
{
    NSInteger charpterId = self.bookDetail.charpterModel.charpterId;
    
    YBBookReadVC *readController = self.pageViewController.viewControllers.firstObject;
    self.bookDetail.charpterModel = readController.charpterModel;
    self.bookDetail.page = readController.page;
    [YBBookDetailManager insertOrReplaceModel:self.bookDetail];
    
    if (charpterId !=self.bookDetail.charpterModel.charpterId && self.bookDetail.page == 0) {
        //新的一章
        [self p_downloads];
    }
    
}

#pragma mark - 创建新页面
-(YBBookReadVC *)p_creatReadController:(NSString *)charpter content:(NSAttributedString *)content page:(NSInteger)page totalPage:(NSInteger)totalPage charpterIndex:(NSInteger)index totalCharpter:(NSInteger)total charpterModel:(YBBookChapterModel *)charpterModel charpterContent:(NSAttributedString *)charpterContent pages:(NSArray *)pages;
{
    return [self p_creatReadController:charpter content:content page:page totalPage:totalPage charpterIndex:index totalCharpter:total charpterModel:charpterModel charpterContent:charpterContent pages:pages mirror:NO];
}

-(YBBookReadVC *)p_creatReadController:(NSString *)charpter content:(NSAttributedString *)content page:(NSInteger)page totalPage:(NSInteger)totalPage charpterIndex:(NSInteger)index totalCharpter:(NSInteger)total charpterModel:(YBBookChapterModel *)charpterModel charpterContent:(NSAttributedString *)charpterContent pages:(NSArray *)pages mirror:(BOOL)mirror
{
    YBBookReadVC *readController = [[YBBookReadVC alloc] init];
//    readController.mirror = mirror;
    [readController setCharpter:charpter content:content page:page totalPage:totalPage charpterIndex:index totalCharpter:total];
    readController.charpterContent = charpterContent;
    readController.charpterModel = charpterModel;
    readController.pages = pages;
    readController.delegate = self;
    return readController;
}

#pragma mark - UIPageViewContrillerDelegate

/**
 *  @brief 该方法会在 UIPageViewController 翻页效果出发之后，尚未完成时执行
 *
 *  @param pageViewController      翻页控制器
 *  @param finished                动画完成
 *  @param previousViewControllers 前一个控制器(非当前)
 *  @param completed               转场动画执行完
 */
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    if (completed) {
        [self p_saveRecord];
    }
    if (completed && finished) {                //这里需要注意的是.如果用用户翻页未完成 又回来了将,不进入判断,这里看需求注释
        // 转场动画完成，开启用户交互
        pageViewController.view.userInteractionEnabled = YES;
    }
}

/**
     *  @brief 转场动画即将开始
    *
    *  @param pageViewController     翻页控制器
    *  @param pendingViewControllers 即将展示的控制器
    */
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    // 转场动画未执行完，关闭用户交互
    pageViewController.view.userInteractionEnabled = NO;
}

#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    return [self p_afterOrBeforeWithViewController:viewController before:YES];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
   return [self p_afterOrBeforeWithViewController:viewController before:NO];
    
}


/// 返回前一个或者后一个控制器
/// @param controller 当前控制区内
/// @param before 是否是前一个控制器
-(UIViewController *)p_afterOrBeforeWithViewController:(UIViewController *)controller before:(BOOL)before{
    return [self p_afterOrBeforeWithViewController:controller before:before mirror:NO];

}

-(UIViewController *)p_afterOrBeforeWithViewController:(UIViewController *)controller before:(BOOL)before mirror:(BOOL)mirror{
    YBBookReadVC *currentController = (YBBookReadVC *)controller;
    NSInteger page = currentController.page;   //当前页数
    NSInteger charpter = currentController.charpterIndex; //当前章节
    YBBookChapterModel *charpterModel = currentController.charpterModel;   //当前章节信息
    NSAttributedString *charpterContent = currentController.charpterContent;    //当前章节内容
    NSArray *pages = currentController.pages;       //分页信息数组
    
    
    UIPageViewControllerNavigationDirection direction;
    if (before) {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    else{
        direction = UIPageViewControllerNavigationDirectionForward;
    }
    
    BOOL animate = YES;
    if (before) {
        if (page == 0 && charpter == 0) {
           //第一章，第一页，不用做任何处理
            return nil;
        }
    }
    else{
        if (page == pages.count-1 && charpter == self.charpters.count-1) {
            //最后一张最后一页，不用做任何处理
            return nil;
        }
    }
    if (!self.charpters.count) {
        return nil;
    }
    if ((before && (page == 0)) || (!before && (page == pages.count-1))) {
        //上一章的数据 或者下一章的数据
        NSInteger charpterId;
        if (before) {
            charpterId = self.charpters[charpter-1].charpterId;
        }else{
            charpterId = self.charpters[charpter+1].charpterId;
        }
        
        YBBookChapterModel *otherCharpterModel = [YBBookChapterManager getCharpterWithBookId:self.bookDetail.bookId charpterId:charpterId];
        NSInteger charpterIndex = [self p_getCurCharpterWithCharpter:otherCharpterModel];
        if (otherCharpterModel.chapterContent.length == 0) {
            //内容不存在
            __block YBBookReadVC * readController;
            [[YBNetwork sharedManager] getBookChapterDetailWithUrl:otherCharpterModel.charpterUrl WithBlock:^(YBRequestResult * _Nonnull result, NSError * _Nonnull error) {
                if ([YBResultError hasErrorWithReslut:result error:error]) {
                    return;
                }
                NSString *contentStr = result.data;
                [YBReadParser paginateWithContent:contentStr charpter:otherCharpterModel.chapterName bounds:CGRectMake(0, 0, ScreenWidth-kLeftMargin-kRightMargin, ScreenHeight-kTopMargin-kBottomMargin) complete:^(NSAttributedString * _Nonnull content, NSArray * _Nonnull pages) {
                    if (before) {
                        //上一章
                        YBBookReadVC * readController = [self p_creatReadController:otherCharpterModel.chapterName content:[self p_getCurPageContentWithContent:content page:pages.count-1 pages:pages] page:pages.count-1 totalPage:pages.count charpterIndex:charpterIndex totalCharpter:self.charpters.count charpterModel:otherCharpterModel charpterContent:content pages:pages];
                        YBBookReadVC * mirror_readController = [self p_creatReadController:otherCharpterModel.chapterName content:[self p_getCurPageContentWithContent:content page:pages.count-1 pages:pages] page:pages.count-1 totalPage:pages.count charpterIndex:charpterIndex totalCharpter:self.charpters.count charpterModel:otherCharpterModel charpterContent:content pages:pages mirror:YES];
                        [self.pageViewController setViewControllers:@[readController,mirror_readController] direction:direction animated:animate completion:nil];
                    }
                    else{
                        //下一章
                        YBBookReadVC * mirror_readController = [self p_creatReadController:currentController.charpter content:currentController.content page:currentController.page totalPage:currentController.totalPage charpterIndex:currentController.charpterIndex totalCharpter:currentController.totalCharpter charpterModel:currentController.charpterModel charpterContent:currentController.charpterContent pages:currentController.pages mirror:YES];
                        //后一页
                        YBBookReadVC * readController = [self p_creatReadController:otherCharpterModel.chapterName content:[self p_getCurPageContentWithContent:content page:0 pages:pages] page:0 totalPage:pages.count charpterIndex:charpterIndex totalCharpter:self.charpters.count charpterModel:otherCharpterModel charpterContent:content pages:pages];
                        [self.pageViewController setViewControllers:@[readController,mirror_readController] direction:direction animated:animate completion:nil];
                        
                    }
                    
                
                    [self p_saveRecord];
                }];
            }];
            return readController;
        }else{
            //需要重新分页
            __block YBBookReadVC *readController = nil;
            [YBReadParser paginateWithContent:otherCharpterModel.chapterContent charpter:otherCharpterModel.bookName bounds:CGRectMake(0, 0, ScreenWidth-kLeftMargin-kRightMargin, ScreenHeight-kTopMargin-kBottomMargin) complete:^(NSAttributedString * _Nonnull content, NSArray * _Nonnull pages) {
                readController = [self p_creatReadController:otherCharpterModel.chapterName content:[self p_getCurPageContentWithContent:content page:before?pages.count-1:0 pages:pages] page:before?pages.count-1:0 totalPage:pages.count charpterIndex:charpterIndex totalCharpter:self.charpters.count charpterModel:otherCharpterModel charpterContent:content pages:pages mirror:mirror];
        
                
            }];
            return readController;
        }
        

    }
    else{
        YBBookReadVC *readController = [self p_creatReadController:charpterModel.chapterName content:[self p_getCurPageContentWithContent:charpterContent page:before?page-1:page+1 pages:pages] page:before?page-1:page+1 totalPage:pages.count charpterIndex:charpter totalCharpter:self.charpters.count charpterModel:charpterModel charpterContent:charpterContent pages:pages mirror:mirror];
        return readController;
        
    }
}

#pragma mark - YBBookReadVCDelegate
-(void)nextPage:(YBBookReadVC *)controller
{
//    [self p_setAfterOrBeforeViewControllerWithBefore:NO];
//    [self p_saveRecord];
}

-(void)lastPage:(YBBookReadVC *)controller
{
//    [self p_setAfterOrBeforeViewControllerWithBefore:YES];
//    [self p_saveRecord];
}

-(void)invokeMenu:(YBBookReadVC *)controller
{
//    if (self.menuView.superview) {
//        _isShowStatusBar = NO;
//        [self setNeedsStatusBarAppearanceUpdate];
//        [self.menuView dismiss];
//    }
//    else{
//        _isShowStatusBar = YES;
//        [self setNeedsStatusBarAppearanceUpdate];
//        self.menuView = [[RDMenuView alloc] init];
//        self.menuView.delegate = self;
//        self.menuView.charpters = self.charpters;
//        self.menuView.book = self.bookDetail;
//        [self.menuView showInView:self.view];
//    }
    
//    if (!self.navigationController.navigationBar.hidden) {
        [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBar.hidden animated:YES];
//    }
}

#pragma mark - page
-(NSInteger)p_safePage:(NSInteger)page totalPages:(NSInteger)pages{
    if (page<0) {
        page = 0;
    }
    if (page>= pages) {
        page = pages-1;
    }
    return page;
}

-(NSAttributedString *)p_getCurPageContentWithContent:(NSAttributedString *)conetnt page:(NSInteger)page pages:(NSArray *)pages{
    return [self p_subGetCurPageContentWithContent:conetnt page:page pages:pages];
}

-(NSAttributedString *)p_subGetCurPageContentWithContent:(NSAttributedString *)conetnt page:(NSInteger)page pages:(NSArray *)pages{
    NSInteger index = page;
    NSInteger loc = [pages[index] integerValue];
    NSInteger len = 0;
    if (index<pages.count-1) {
        len = [pages[index+1] integerValue] - loc;
    }
    else{
        len = conetnt.length - loc;
    }
    return [conetnt attributedSubstringFromRange:NSMakeRange(loc, len)];

}

#pragma mark - 懒加载
-(UIPageViewController *)pageViewController
{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        _pageViewController.doubleSided = YES;
        [self.view addSubview:_pageViewController.view];
    }
    return _pageViewController;
}

-(UIView *)brightnessView{
    if (!_brightnessView) {
        _brightnessView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _brightnessView.backgroundColor = [UIColor blackColor];
        _brightnessView.alpha = kConfigMaxBrightnessValue - [YBReadConfigManager sharedInstance].brightness;
        _brightnessView.userInteractionEnabled = NO;
    }
    return _brightnessView;
}

//当前章节索引
-(NSInteger)p_getCurCharpter
{
    return [self.charpters indexOfObject:self.bookDetail.charpterModel];
}

//当前章节索引
-(NSInteger)p_getCurCharpterWithCharpter:(YBBookChapterModel *)model
{
    for (NSInteger i=0; i<self.charpters.count; i++) {
        YBBookChapterModel *chapter = self.charpters[i];
        if (chapter.charpterId == model.charpterId) {
            return i;
        }
    }
    return 0;
}
@end
