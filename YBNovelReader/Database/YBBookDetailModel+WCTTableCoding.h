//
//  YBBookDetailModel+WCTTableCoding.h
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/30.
//

#import "YBBookDetailModel.h"
#import <WCDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface YBBookDetailModel (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(bookId)
WCDB_PROPERTY(bookImage)
WCDB_PROPERTY(bookName)
WCDB_PROPERTY(bookAuthor)
WCDB_PROPERTY(bookIntro)
WCDB_PROPERTY(bookUrl)

WCDB_PROPERTY(charpterModel)
WCDB_PROPERTY(page)
WCDB_PROPERTY(readTime)

@end

NS_ASSUME_NONNULL_END
