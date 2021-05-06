//
//  YBBookChapterModel+WCTTableCoding.h
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/30.
//

#import "YBBookChapterModel.h"
#import <WCDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface YBBookChapterModel (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(primaryId)
WCDB_PROPERTY(charpterId)
WCDB_PROPERTY(charpterUrl)
WCDB_PROPERTY(chapterName)
WCDB_PROPERTY(chapterContent)
WCDB_PROPERTY(bookId)
WCDB_PROPERTY(bookName)
WCDB_PROPERTY(author)

@end

NS_ASSUME_NONNULL_END
