//
//  YBSearchModel.m
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/29.
//

#import "YBSearchModel.h"
#import "TFHpple.h"

@implementation YBSearchModel

- (NSArray *)analysisWithData:(id)data{
    TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:data];
    NSMutableArray *itemArray = [NSMutableArray arrayWithArray:[xpathParser searchWithXPathQuery:@"//table[@class='grid']/tr"]];
    [itemArray removeObjectAtIndex:0];
    
    NSMutableArray *analysis = [NSMutableArray array];
    for (TFHppleElement *elementModel in itemArray) {
        TFHppleElement *name = [elementModel searchWithXPathQuery:@"//td[@class='even']/a/text()"].firstObject;
        TFHppleElement *url = [elementModel searchWithXPathQuery:@"//td[@class='even']/a/@href"].firstObject;
        TFHppleElement *author = [elementModel searchWithXPathQuery:@"//td[@class='even']/text()"].firstObject;
        TFHppleElement *chapter = [elementModel searchWithXPathQuery:@"//td[@class='odd']/a/text()"].firstObject;
        TFHppleElement *date = [elementModel searchWithXPathQuery:@"//td[@align='center']/text()"].firstObject;
        
        YBSearchModel *model = [[YBSearchModel alloc] init];
        model.bookName = name.content;
        model.bookUrl = url.content;
        model.bookAuthor = author.content;
        model.chapterNew = chapter.content;
        model.updateDate = date.content;
        [analysis addObject:model];
    }
    return analysis;
}

@end
