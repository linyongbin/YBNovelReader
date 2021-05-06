//
//  YBBaseTableViewCell.m
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/29.
//

#import "YBBaseTableViewCell.h"

@implementation YBBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
