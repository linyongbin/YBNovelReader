//
//  YBDatabaseManager.h
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/30.
//

#import "YBBaseModel.h"
#import <WCDB.h>
#define kBookDatabase @"book"
#define kBookrackTable @"bookrack"
#define kCharpterTable @"chapter"

NS_ASSUME_NONNULL_BEGIN

@interface YBDatabaseManager : YBBaseModel

@property (nonatomic,strong) WCTDatabase *database;

+ (YBDatabaseManager *)sharedInstance;
@end

NS_ASSUME_NONNULL_END
