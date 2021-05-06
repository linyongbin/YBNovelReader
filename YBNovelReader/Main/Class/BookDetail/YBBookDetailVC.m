//
//  YBBookDetailVC.m
//  YBNovelReader
//
//  Created by 林勇彬 on 2021/4/29.
//

#import "YBBookDetailVC.h"
#import "YBBookDetailModel.h"
#import <UIImageView+WebCache.h>
#import <TABAnimated.h>
#import "YBBookDetailManager.h"
#import "YBBookChapterManager.h"
#import "YBBookReadPageVC.h"

@interface YBBookDetailVC ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *bookImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *chapterLabel;
@property (nonatomic, strong) UILabel *introLabel;
@property (nonatomic, strong) UIButton *joinBookrackBtn;
@property (nonatomic, strong) UIButton *readBookBtn;

@property (nonatomic, strong) YBBookDetailModel *bookDetailModel;
@end

@implementation YBBookDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详情";
    [self setupView];
    [self getBookDetail];
}

- (void)setupView{
    __weak typeof(self) weakSelf = self;
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.joinBookrackBtn];
    [self.view addSubview:self.readBookBtn];
    [self.scrollView addSubview:self.bookImageView];
    [self.scrollView addSubview:self.nameLabel];
    [self.scrollView addSubview:self.authorLabel];
    [self.scrollView addSubview:self.chapterLabel];
    [self.scrollView addSubview:self.introLabel];
    [self.joinBookrackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.bottom.mas_equalTo(-SafeAreaBottomHeight);
        make.height.mas_equalTo(52);
    }];
    [self.readBookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view);
        make.top.bottom.width.equalTo(weakSelf.joinBookrackBtn);
        make.left.equalTo(weakSelf.joinBookrackBtn.mas_right);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.top.mas_equalTo(SafeAreaTopHeight);
        make.bottom.equalTo(weakSelf.joinBookrackBtn.mas_top);
    }];
    [self.bookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(10);
        make.top.equalTo(weakSelf.scrollView).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(150);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bookImageView);
        make.left.equalTo(weakSelf.bookImageView.mas_right).offset(10);
        make.right.equalTo(weakSelf.view).offset(-15);
    }];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.nameLabel);
        make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(10);
    }];
    [self.chapterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.nameLabel);
        make.top.equalTo(weakSelf.authorLabel.mas_bottom).offset(10);
    }];
    [self.introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.nameLabel);
        make.top.equalTo(weakSelf.chapterLabel.mas_bottom).offset(10);
        make.bottom.mas_equalTo(weakSelf.scrollView);
    }];
    
    self.view.tabAnimated = TABViewAnimated.new;
    self.view.tabAnimated.superAnimationType = TABViewSuperAnimationTypeShimmer;
    self.view.tabAnimated.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
        manager.animation(1).width(100);
        manager.animation(2).width(80);
        manager.animation(3).width(120);
    };
}

- (void)getBookDetail{
    __weak typeof(self) weakSelf = self;
//    [MBProgressHUD showLoading];
    
    NSLog(@"start = %f",CACurrentMediaTime());
    [self.view tab_startAnimationWithCompletion:^{
        NSLog(@"end =%f",CACurrentMediaTime());
        [[YBNetwork sharedManager] getBookDetailWithUrl:self.bookUrl WithBlock:^(YBRequestResult * _Nonnull result, NSError * _Nonnull error) {
//            [MBProgressHUD hideHUD];
            [self.view tab_endAnimationEaseOut];
            if ([YBResultError hasErrorWithReslut:result error:error]) {
                return;
            }
            YBBookDetailModel *bookDetailModel = result.data;
            [weakSelf.bookImageView sd_setImageWithURL:[NSURL URLWithString:bookDetailModel.bookImage]];
            weakSelf.nameLabel.text = bookDetailModel.bookName;
            weakSelf.introLabel.text = bookDetailModel.bookIntro;
            weakSelf.authorLabel.text = bookDetailModel.bookAuthor;
            weakSelf.chapterLabel.text = bookDetailModel.chapterNew;
            weakSelf.bookDetailModel = bookDetailModel;
        }];
    }];
}

- (void)clickJoinBookrack{
    [YBBookDetailManager insertOrReplaceModel:self.bookDetailModel];
}

- (void)clickReadBook{
    typeof(self) __weak weakSelf = self;
    [MBProgressHUD showLoading];
    YBBookDetailModel *record = [YBBookDetailManager getReadRecordWithBookId:self.bookDetailModel.bookId];
    if (!record) {
        [YBBookDetailManager insertOrReplaceModel:self.bookDetailModel];
        record = self.bookDetailModel;
    }
    [YBBookChapterManager insertObjectsWithCharpters:record.charpterList];
    YBBookReadPageVC *controller = [[YBBookReadPageVC alloc] init];
       if (record.charpterModel) {
           [MBProgressHUD hideHUD];
           //存在阅读记录
           controller.bookDetail = record;
           [YBBookDetailManager updateReadTime:record];
           [weakSelf.navigationController pushViewController:controller animated:YES];
       }else{
           YBBookChapterModel *chapter =  record.charpterList.firstObject;
           [YBBookChapterManager getCharpterWithBookId:record.bookId charpterId:chapter.charpterId complete:^(BOOL success, YBBookChapterModel * _Nonnull model) {
               [MBProgressHUD hideHUD];
               if (success) {
                   record.charpterModel = model;
                   [YBBookDetailManager insertOrReplaceModel:record];
                   controller.bookDetail = record;
                   [weakSelf.navigationController pushViewController:controller animated:YES];
               }
           }];
       }
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = YES;
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (UIImageView *)bookImageView{
    if (!_bookImageView) {
        _bookImageView = [[UIImageView alloc] init];
        _bookImageView.layer.masksToBounds = YES;
        _bookImageView.layer.cornerRadius = 4;
        _bookImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bookImageView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor ybBlackColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:20];
    }
    return _nameLabel;
}

- (UILabel *)authorLabel{
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.textColor = [UIColor ybBlackColor];
        _authorLabel.font = [UIFont systemFontOfSize:14];
    }
    return _authorLabel;
}

- (UILabel *)chapterLabel{
    if (!_chapterLabel) {
        _chapterLabel = [[UILabel alloc] init];
        _chapterLabel.textColor = [UIColor ybDarkgrayColor];
        _chapterLabel.font = [UIFont systemFontOfSize:12];
    }
    return _chapterLabel;
}

- (UILabel *)introLabel{
    if (!_introLabel) {
        _introLabel = [[UILabel alloc] init];
        _introLabel.textColor = [UIColor ybGrayColor];
        _introLabel.font = [UIFont systemFontOfSize:14];
        _introLabel.numberOfLines = 0;
    }
    return _introLabel;
}

- (UIButton *)joinBookrackBtn{
    if (!_joinBookrackBtn) {
        _joinBookrackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _joinBookrackBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_joinBookrackBtn setTitle:@"加入书架" forState:UIControlStateNormal];
        [_joinBookrackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_joinBookrackBtn setBackgroundColor:[UIColor ybMainColor]];
        [_joinBookrackBtn addTarget:self action:@selector(clickJoinBookrack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _joinBookrackBtn;
}

- (UIButton *)readBookBtn{
    if (!_readBookBtn) {
        _readBookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _readBookBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_readBookBtn setTitle:@"立即阅读" forState:UIControlStateNormal];
        [_readBookBtn setTitleColor:[UIColor ybBlackColor] forState:UIControlStateNormal];
        [_readBookBtn addTarget:self action:@selector(clickReadBook) forControlEvents:UIControlEventTouchUpInside];
    }
    return _readBookBtn;
}
@end
