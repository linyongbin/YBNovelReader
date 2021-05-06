//
//  YBSearchCell.m
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/29.
//

#import "YBSearchCell.h"

@interface YBSearchCell()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *chapterLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation YBSearchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    typeof(self) __weak weakSelf = self;
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.authorLabel];
    [self.contentView addSubview:self.chapterLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.lineView];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
    }];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.equalTo(weakSelf.nameLabel);
    }];
    [self.chapterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel);
        make.bottom.mas_equalTo(-15);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.authorLabel);
        make.bottom.equalTo(weakSelf.chapterLabel);
        make.left.greaterThanOrEqualTo(weakSelf.chapterLabel.mas_right).offset(10);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(1);
    }];
}

- (void)setModel:(YBSearchModel *)model{
    _model = model;
    self.nameLabel.text = model.bookName;
    self.authorLabel.text = [NSString stringWithFormat:@"作者：%@",model.bookAuthor];
    self.chapterLabel.text = [NSString stringWithFormat:@"最新章节：%@",model.chapterNew];
    self.timeLabel.text = [NSString stringWithFormat:@"更新时间：%@",model.updateDate];
}


#pragma mark - 懒加载
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor ybBlackColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
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

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor ybGrayColor];
        _timeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _timeLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor ybBackGroundColor];
    }
    return _lineView;
}
@end
