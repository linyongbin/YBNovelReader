//
//  YBReadParser.h
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kTopMargin (40+SafeAreaTopHeight)
#define kBottomMargin (40+SafeAreaBottomHeight)
#define kLeftMargin 20
#define kRightMargin 20

@interface YBReadParser : NSObject

+(void)paginateWithContent:(NSString *)content charpter:(NSString *)charpter bounds:(CGRect)bounds complete:(void(^)(NSAttributedString *content,NSArray *pages))complete;


+(NSString *)getShowContent:(NSString *)content charpter:(NSString *)charpter;

/// 解析内容属性
+(NSDictionary *)paraserFontArrribute:(YBReadConfigManager *)config;

/// 解析章节属性
+(NSDictionary *)paraserChapterFontArrribute:(YBReadConfigManager *)config;

@end

NS_ASSUME_NONNULL_END
