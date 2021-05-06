//
//  YBBookChapterModel.h
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YBBookChapterModel : NSObject
@property (nonatomic,copy) NSString *primaryId;

@property (nonatomic, copy) NSString *chapterName;
@property (nonatomic, copy) NSString *charpterId;
@property (nonatomic, copy) NSString *chapterContent;

//数据库存储使用
@property (nonatomic,assign) NSInteger bookId;
@property (nonatomic,strong) NSString *bookName;
@property (nonatomic,strong) NSString *author;
@end

NS_ASSUME_NONNULL_END
