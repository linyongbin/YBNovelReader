//
//  YBSearchModel.h
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YBSearchModel : NSObject

@property (nonatomic, copy) NSString *bookName;
@property (nonatomic, copy) NSString *bookUrl;
@property (nonatomic, copy) NSString *bookAuthor;
/// 最新章节
@property (nonatomic, copy) NSString *chapterNew;
@property (nonatomic, copy) NSString *updateDate;
@end

NS_ASSUME_NONNULL_END
