//
//  QHCommonDefine.h
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/29.
//

#ifndef QHCommonDefine_h
#define QHCommonDefine_h

//获取设备的物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//获取设备的物理宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define  FIT(x)         (ScreenWidth / 375.0 * (x))

//判断是否有刘海
#define Device_Is_iPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define PlaceholderImage [UIImage imageNamed:@"ic_defaultImage"]//默认

#define SafeAreaTopHeight (Device_Is_iPhoneX ? 88 : 64)
#define SafeAreaTop (Device_Is_iPhoneX ? 44 : 20)
#define SafeAreaBottomHeight (Device_Is_iPhoneX ? 34 : 0)

#define QHNotifacation [NSNotificationCenter defaultCenter]

//rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) UIColorFromRGBA(rgbValue,1)
#define UIColorFromRGBA(rgbValue,A) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:A]


#define  adjustsContentInsets(scrollView)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
}\
_Pragma("clang diagnostic pop") \
} while (0)

// path
#define PATH_APP_HOME       NSHomeDirectory()
#define PATH_TEMP           NSTemporaryDirectory()
#define PATH_BUNDLE         [[NSBundle mainBundle] bundlePath]
#define PATH_CACHES         [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
#define PATH_LIBRARY        [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]
#define PATH_DOCUMENT       [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

//
//#define WXUniversalLink @"https://www.qhuolink.com"
//#define WXMiniProgramID @"gh_de1d70083506"
//#define WXAppKey @"wx035a9c5d1d9bf7e7"
//#define JPushKey @"e6cfd9774d84d78a7e2abf2a"
//#define ZhiChiAppKey @"ee94f9d0ff174334924fe9280c3be3cc"
#define QHBaseUrl @"http://www.xbiquge.la"


#endif /* QHCommonDefine_h */
