//
//  YBResultError.m
//  YBNovelReader
//
//  Created by linyongbin on 2021/4/29.
//

#import "YBResultError.h"
#import "YBRequestResult.h"

@implementation YBResultError

+ (BOOL)hasErrorWithReslut:(id)data error:(NSError *)error {
    if ((data == nil || [data isKindOfClass:[NSNull class]]) && error) {
        [self showError:error];
        return YES;
    }
    
    return NO;
}


+ (void)showError:(NSError *)error{
    if (!error) {
        return;
    }
    
    NSString *message = @"";
    message = (error.userInfo != nil) ? error.userInfo[NSLocalizedDescriptionKey] : nil;
    NSLog(@"服务器报错  %zd",error.code);
    switch (error.code) {
        case NSURLErrorUnknown:
            message = @"发生未知网络错误";
            break;
        case NSURLErrorCancelled:
            message = @"网络错误取消请求";
            break;
        case NSURLErrorBadURL:
            message = @"错误的URL地址";
            break;
        case NSURLErrorTimedOut:
            message = @"网络请求超时";
            break;
        case NSURLErrorUnsupportedURL:
            message = @"不支持的URL请求";
            break;
        case NSURLErrorCannotFindHost:
            message = @"无法找到服务器";
            break;
        case NSURLErrorCannotConnectToHost:
            message = @"连接服务器失败";
            break;
        case NSURLErrorNetworkConnectionLost:
            message = @"没有网络连接";
            break;
        case NSURLErrorDNSLookupFailed:
            message = @"DNS解析失败";
            break;
        case NSURLErrorHTTPTooManyRedirects:
            message = @"网络请求重定向太多";
            break;
        case NSURLErrorResourceUnavailable:
            message = @"请求资源不可用";
            break;
        case NSURLErrorNotConnectedToInternet:
            message = @"没有网络连接";
            break;
        case NSURLErrorRedirectToNonExistentLocation:
            message = @"重定向失败";
            break;
        case NSURLErrorBadServerResponse:
            message = @"服务器响应错误";
            break;
        case 3840:
            message = @"服务器正在更新，请稍后！";
            break;
        default:
#ifdef DEBUG
            message = [error description];
#else
            message = [error localizedDescription];
#endif
            break;
    }
    
    if (!message || !message.length) {
        message = NSLocalizedString(@"ErrorData", @"ErrorData");
    }
    
//    [MBProgressHUD showMessage:message];
}

@end
