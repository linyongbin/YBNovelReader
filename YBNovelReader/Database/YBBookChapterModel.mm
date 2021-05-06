//
//  YBBookChapterModel.m
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/30.
//

#import "YBBookChapterModel+WCTTableCoding.h"
#import "YBBookChapterModel.h"
#import <WCDB.h>
#import "TFHpple.h"

@implementation YBBookChapterModel

WCDB_IMPLEMENTATION(YBBookChapterModel)
WCDB_SYNTHESIZE_COLUMN(YBBookChapterModel, primaryId,"primaryId")
WCDB_SYNTHESIZE_COLUMN(YBBookChapterModel, charpterId,"charpterId")
WCDB_SYNTHESIZE_COLUMN(YBBookChapterModel, chapterName,"chapterName")
WCDB_SYNTHESIZE_COLUMN(YBBookChapterModel, chapterContent,"chapterContent")
WCDB_SYNTHESIZE_COLUMN(YBBookChapterModel, bookId,"bookId")
WCDB_SYNTHESIZE_COLUMN(YBBookChapterModel, bookName,"bookName")
WCDB_SYNTHESIZE_COLUMN(YBBookChapterModel, author,"author")

WCDB_PRIMARY(YBBookChapterModel, primaryId)

-(NSString *)primaryId
{
    if (!_primaryId) {
        _primaryId = [NSString stringWithFormat:@"%@%@",_bookId,_charpterId];
    }
    return _primaryId;
}

- (NSString *)analysisWithData:(id)data{
    TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:data];
    NSArray *contents = [xpathParser searchWithXPathQuery:@"//*[@id='content']/text()"];
    NSMutableString *content = [NSMutableString string];
    for (TFHppleElement *model in contents) {
        [content appendString:model.content];
    }
    return content;
}

-(BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    if ([object isKindOfClass:self.class]) {
        YBBookChapterModel *model = object;
           if (self.charpterId == model.charpterId && self.charpterId!=0) {
               return YES;
           }
    }
   
    return NO;
}

@end
