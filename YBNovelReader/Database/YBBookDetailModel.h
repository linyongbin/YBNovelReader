//
//  YBBookDetailModel.h
//  YBNovelReader
//
//  Created by 林勇彬 on 2021/4/29.
//

#import <Foundation/Foundation.h>
#import "YBBookChapterModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YBBookDetailModel : NSObject
@property (nonatomic, assign) NSInteger bookId;
@property (nonatomic, copy) NSString *bookName;
@property (nonatomic, copy) NSString *bookAuthor;
@property (nonatomic, copy) NSString *bookImage;
@property (nonatomic, copy) NSString *bookIntro;
@property (nonatomic, copy) NSString *bookUrl;
/// 最新章节
@property (nonatomic, copy) NSString *chapterNew;
@property (nonatomic, copy) NSString *updateDate;
@property (nonatomic, strong) NSArray *charpterList;

/// 当前观看的章节下标
@property (nonatomic, assign) NSInteger currentChapter;
//添加到书架时的阅读进度
@property (nonatomic,strong) YBBookChapterModel *charpterModel;  //当前阅读的章节
@property (nonatomic,assign) NSInteger page;        //当前阅读的进度
@property (nonatomic,assign) NSTimeInterval readTime;   //阅读的最后时间
@end

NS_ASSUME_NONNULL_END
