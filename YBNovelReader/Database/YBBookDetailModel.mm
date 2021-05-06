//
//  YBBookDetailModel.m
//  YBNovelReader
//
//  Created by 林勇彬 on 2021/4/29.
//

#import "YBBookDetailModel+WCTTableCoding.h"
#import "YBBookDetailModel.h"
#import "TFHpple.h"
#import <WCDB.h>

@implementation YBBookDetailModel


WCDB_IMPLEMENTATION(YBBookDetailModel)

WCDB_SYNTHESIZE_COLUMN(YBBookDetailModel, bookId, "bookId") // Custom column name
WCDB_SYNTHESIZE_COLUMN(YBBookDetailModel, bookImage, "bookImage")
WCDB_SYNTHESIZE_COLUMN(YBBookDetailModel, bookName, "bookName")
WCDB_SYNTHESIZE_COLUMN(YBBookDetailModel, bookAuthor, "bookAuthor")
WCDB_SYNTHESIZE_COLUMN(YBBookDetailModel, bookIntro, "bookIntro")
WCDB_SYNTHESIZE_COLUMN(YBBookDetailModel, bookUrl, "bookUrl")
WCDB_SYNTHESIZE_COLUMN(YBBookDetailModel, charpterModel, "charpterModel")
WCDB_SYNTHESIZE_COLUMN(YBBookDetailModel, page, "page")
WCDB_SYNTHESIZE_COLUMN(YBBookDetailModel, readTime, "readTime")

WCDB_PRIMARY(YBBookDetailModel, bookId)

- (id)analysisWithData:(id)data{
    TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:data];
    //[15]
    TFHppleElement *bookUrl = [xpathParser searchWithXPathQuery:@"//meta[@property='og:novel:read_url']/@content"].firstObject;
    TFHppleElement *author = [xpathParser searchWithXPathQuery:@"//meta[@property='og:novel:author']/@content"].firstObject;
    TFHppleElement *intro = [xpathParser searchWithXPathQuery:@"//meta[@property='og:description']/@content"].firstObject;

    TFHppleElement *name = [xpathParser searchWithXPathQuery:@"//meta[@property='og:title']/@content"].firstObject;
    TFHppleElement *image = [xpathParser searchWithXPathQuery:@"//meta[@property='og:image']/@content"].firstObject;
    TFHppleElement *time = [xpathParser searchWithXPathQuery:@"//*[@id='info']/p[3]/text()"].firstObject;
    TFHppleElement *chapter = [xpathParser searchWithXPathQuery:@"//*[@id='info']/p[4]/a/text()"].firstObject;
    NSArray *chapters = [xpathParser searchWithXPathQuery:@"//*[@id='list']/dl/dd"];

    self.bookName = name.content;
    self.bookAuthor = author.content;
    self.bookImage = image.content;
    self.bookIntro = intro.content;
    self.updateDate = time.content;
    self.chapterNew = chapter.content;
    self.bookUrl = bookUrl.content;
    self.bookId = bookUrl.content;
    
    NSMutableArray *array = [NSMutableArray array];
    for (TFHppleElement *model in chapters) {
        YBBookChapterModel *chapterModel = [[YBBookChapterModel alloc] init];
        TFHppleElement *chapterName = [model searchWithXPathQuery:@"//text()"].firstObject;
        TFHppleElement *chapterUrl = [model searchWithXPathQuery:@"//a/@href"].firstObject;
        chapterModel.chapterName = chapterName.content;
        chapterModel.charpterId = chapterUrl.content;
        chapterModel.bookName = name.content;
        chapterModel.author = author.content;
        chapterModel.bookId = bookUrl.content;
        [array addObject:chapterModel];
    }
    self.charpterList = array;
    return self;
}

-(BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    if ([object isKindOfClass:self.class]){
        YBBookDetailModel *model = object;
           if (self.bookId == model.bookId && self.bookId!=0) {
               return YES;
           }
    }
   
    return NO;
}

@end
