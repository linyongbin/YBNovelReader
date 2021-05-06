//
//  YBReadConfigManager.m
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/30.
//

#import "YBReadConfigManager.h"

@implementation YBReadConfigManager

+ (YBReadConfigManager *)sharedInstance {
    static YBReadConfigManager *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        if (!sharedInstance) {
            sharedInstance = [[self alloc] init];
            sharedInstance.fontSize = 16;
            sharedInstance.lineSpace = sharedInstance.fontSize-6;
            sharedInstance.background = [UIImage imageNamed:@"theme2_read_bg"];
//            sharedInstance.firstLineHeadIndent = sharedInstance.fontSize * 2;
            sharedInstance.brightness = kConfigMaxBrightnessValue;
//            sharedInstance.theme = RDWhiteTheme;
//            sharedInstance.pageType = RDRealTypePage;
        }
    });

    return sharedInstance;
}

-(CGFloat)chapterFontSize
{
    return self.fontSize+10;
}

-(CGFloat)chapterLineSpace
{
    return self.lineSpace+30;
}


@end
