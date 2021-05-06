//
//  YBDatabaseManager.m
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/30.
//

#import "YBDatabaseManager.h"

@implementation YBDatabaseManager

+ (YBDatabaseManager *)sharedInstance
{
    static YBDatabaseManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!sharedInstance) {
            sharedInstance = [[self alloc] init];
            sharedInstance.database = [[WCTDatabase alloc]initWithPath:[PATH_DOCUMENT stringByAppendingPathComponent:kBookDatabase]];
            [sharedInstance.database createTableAndIndexesOfName:kBookrackTable withClass:NSClassFromString(@"YBBookDetailModel")];
            [sharedInstance.database createTableAndIndexesOfName:kCharpterTable withClass:NSClassFromString(@"YBBookChapterModel")];
        }
    });
    
    return sharedInstance;
}

@end
