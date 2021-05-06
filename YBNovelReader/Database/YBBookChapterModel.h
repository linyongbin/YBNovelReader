//
//  YBBookChapterModel.h
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/30.
//

#import "YBBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YBBookChapterModel : YBBaseModel
@property (nonatomic,copy) NSString *primaryId;

@property (nonatomic, copy) NSString *chapterName;
@property (nonatomic, copy) NSString *charpterId;
@property (nonatomic, copy) NSString *chapterContent;

//数据库存储使用
@property (nonatomic,copy) NSString *bookId;
@property (nonatomic,copy) NSString *bookName;
@property (nonatomic,copy) NSString *author;
@end

NS_ASSUME_NONNULL_END
