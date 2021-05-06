//
//  YBDatabaseManager.h
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/30.
//

#import <Foundation/Foundation.h>
#import <WCDB.h>
#define kBookDatabase @"book"
#define kCharpterTable @"chapter"
#define kBookrackTable @"bookrack"

NS_ASSUME_NONNULL_BEGIN

@interface YBDatabaseManager : NSObject

@property (nonatomic,strong) WCTDatabase *database;

+ (YBDatabaseManager *)sharedInstance;
@end

NS_ASSUME_NONNULL_END