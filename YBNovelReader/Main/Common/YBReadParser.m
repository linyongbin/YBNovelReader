//
//  YBReadParser.m
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/30.
//

#import "YBReadParser.h"
#import <CoreText/CoreText.h>

@implementation YBReadParser


+(void)paginateWithContent:(NSString *)content charpter:(NSString *)charpter bounds:(CGRect)bounds complete:(void(^)(NSAttributedString *content,NSArray *pages))complete
{
    
    NSMutableArray *pageArray = [NSMutableArray array];
    CTFramesetterRef frameSetter;
    CGPathRef path;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString  alloc] initWithString:[charpter stringByAppendingString:@"\n"]];
    NSDictionary *charpterAttribute = [YBReadParser paraserChapterFontArrribute:[YBReadConfigManager sharedInstance]];
    [attrString setAttributes:charpterAttribute range:NSMakeRange(0, attrString.length)];
    
    NSMutableAttributedString *contentAttr = [[NSMutableAttributedString  alloc] initWithString:content];
    NSDictionary *contentAttribute = [YBReadParser paraserFontArrribute:[YBReadConfigManager sharedInstance]];
    [contentAttr setAttributes:contentAttribute range:NSMakeRange(0, contentAttr.length)];
    
    
    [attrString appendAttributedString:contentAttr];
    
    
    frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
    path = CGPathCreateWithRect(bounds, NULL);
    
    int currentOffset = 0;
    int currentInnerOffset = 0;
    BOOL hasMorePages = YES;
    // 防止死循环，如果在同一个位置获取CTFrame超过2次，则跳出循环
    int preventDeadLoopSign = currentOffset;
    int samePlaceRepeatCount = 0;
    
    while (hasMorePages) {
        if (preventDeadLoopSign == currentOffset) {
            
            ++samePlaceRepeatCount;
            
        } else {
            
            samePlaceRepeatCount = 0;
        }
        
        if (samePlaceRepeatCount > 1) {
            // 退出循环前检查一下最后一页是否已经加上
            if (pageArray.count == 0) {
                [pageArray addObject:@(currentOffset)];
            }
            else {
                
                NSUInteger lastOffset = [[pageArray lastObject] integerValue];
                
                if (lastOffset != currentOffset) {
                    [pageArray addObject:@(currentOffset)];
                }
            }
            break;
        }
        
        [pageArray addObject:@(currentOffset)];
        
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(currentInnerOffset, 0), path, NULL);
        CFRange range = CTFrameGetVisibleStringRange(frame);
        if ((range.location + range.length) != attrString.length) {
            
            currentOffset += range.length;
            currentInnerOffset += range.length;
            
        } else {
            // 已经分完，提示跳出循环
            hasMorePages = NO;
        }
        if (frame) CFRelease(frame);
    }
    
    CGPathRelease(path);
    CFRelease(frameSetter);
    if (complete) {
        complete(attrString,pageArray.copy);
    }
}

+(NSString *)getShowContent:(NSString *)content charpter:(NSString *)charpter
{
    return [[NSString stringWithFormat:@"%@\n",charpter] stringByAppendingString:content];
}

+(NSDictionary *)paraserFontArrribute:(YBReadConfigManager *)config
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = config.fontColor;
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:config.fontSize];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = config.lineSpace;
//    paragraphStyle.alignment = NSTextAlignmentJustified;
//    paragraphStyle.firstLineHeadIndent = config.firstLineHeadIndent
    paragraphStyle.paragraphSpacing = config.lineSpace+2;
    dict[NSParagraphStyleAttributeName] = paragraphStyle;
    return [dict copy];
}

/// 解析章节属性
+(NSDictionary *)paraserChapterFontArrribute:(YBReadConfigManager *)config
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = config.fontColor;
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:config.chapterFontSize];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = config.chapterLineSpace;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    dict[NSParagraphStyleAttributeName] = paragraphStyle;
    return [dict copy];
}

@end
