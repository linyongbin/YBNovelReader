//
//  YBBookDetailModel.m
//  YBNovelReader
//
//  Created by 林勇彬 on 2021/4/29.
//

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
    TFHppleElement *name = [xpathParser searchWithXPathQuery:@"//*[@id='info']/h1/text()"].firstObject;
    TFHppleElement *author = [xpathParser searchWithXPathQuery:@"//*[@id='info']/p[1]/text()"].firstObject;
    TFHppleElement *image = [xpathParser searchWithXPathQuery:@"//*[@id='fmimg']/img/@src"].firstObject;
    TFHppleElement *intro = [xpathParser searchWithXPathQuery:@"//*[@id='intro']/p[2]/text()"].firstObject;
    TFHppleElement *time = [xpathParser searchWithXPathQuery:@"//*[@id='info']/p[3]/text()"].firstObject;
    TFHppleElement *chapter = [xpathParser searchWithXPathQuery:@"//*[@id='info']/p[4]/a/text()"].firstObject;
    NSArray *chapters = [xpathParser searchWithXPathQuery:@"//*[@id='list']/dl/dd"];

    self.bookName = name.content;
    self.bookAuthor = author.content;
    self.bookImage = image.content;
    self.bookIntro = intro.content;
    self.updateDate = time.content;
    self.chapterNew = chapter.content;
    
    NSMutableArray *array = [NSMutableArray array];
    for (TFHppleElement *model in chapters) {
        YBBookChapterModel *chapterModel = [[YBBookChapterModel alloc] init];
        TFHppleElement *chapterName = [model searchWithXPathQuery:@"//text()"].firstObject;
        TFHppleElement *chapterUrl = [model searchWithXPathQuery:@"//a/@href"].firstObject;
        chapterModel.chapterName = chapterName.content;
        chapterModel.charpterId = chapterUrl.content;
        [array addObject:chapterModel];
    }
    self.charpterList = array;
    return self;
}

@end
