//
//  MRAliWebPayVC.m
//  MeariSDKDemo
//
//  Created by Meari on 2020/8/26.
//  Copyright © 2020 Meari. All rights reserved.
//

#import "MRAliWebPayVC.h"
#import <WebKit/WebKit.h>
@interface MRAliWebPayVC ()<WKNavigationDelegate>{
    BOOL _paySuccess;
    BOOL _isSuccess;
}
// 支付成功后返回的url

// 网页视图
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation MRAliWebPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    // Do any additional setup after loading the view.
    [self initNotification];
}

- (void)initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payNotificateAction:) name:@"Notification_AlipayWeb_Call_Back" object:nil];
}
#pragma mark --- WKNavigationDelegate
// 打开支付宝app
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *urlStr = navigationAction.request.URL.absoluteString;
    
    NSLog(@"decidePolicyForNavigationAction = %@ ", urlStr);
    if ([urlStr hasPrefix:@"alipays://"] || [urlStr hasPrefix:@"alipay://"] || [urlStr containsString:@"https://itunes.apple.com"]) {
        NSURL* alipayURL = [self changeURLSchemeStr:urlStr];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:alipayURL options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:^(BOOL success) {}];
        } else {
            [[UIApplication sharedApplication] openURL:alipayURL];
        }
    }
    // 拦截支付成功后的地址
    if ([urlStr containsString:self.paySuccessUrl] && !_isSuccess) {
        NSLog(@"Alipay 支付成功");
        _isSuccess = YES;
    }
    // 判断是否成功支付
    NSString *doc = @"document.body.outerHTML";
    [webView evaluateJavaScript:doc
              completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
                  if ([htmlStr containsString:@"支付成功"]) {
                      NSLog(@"Alipay 支付成功");
                      _paySuccess = YES;
                  }
              }] ;
    
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSString *removeIconJS = @"document.getElementsByClassName(\"result-back J-guide-back\")[0].remove()";
    [webView evaluateJavaScript:removeIconJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if (error) {
        }
    }];
    
     if (webView.title) {
         self.title = self.webView.title;
     }
}
#pragma mark --- 跳回app
// 改变fromAppUrlScheme
-(NSURL*)changeURLSchemeStr:(NSString*)urlStr{
    NSString* tmpUrlStr = urlStr.copy;
    if([urlStr containsString:@"fromAppUrlScheme"]) {
        tmpUrlStr = [tmpUrlStr stringByRemovingPercentEncoding];
        NSDictionary* tmpDic = [self dictionaryWithUrlString:tmpUrlStr];
        NSString* tmpValue = [tmpDic valueForKey:@"fromAppUrlScheme"];
        tmpUrlStr = [[tmpUrlStr stringByReplacingOccurrencesOfString:tmpValue withString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]] mutableCopy];
        tmpUrlStr = [[tmpUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] mutableCopy];
    }
    NSURL * newURl = [NSURL URLWithString:tmpUrlStr];
    return newURl;
}
-(NSDictionary*)dictionaryWithUrlString:(NSString*)urlStr{
    if(urlStr && urlStr.length&& [urlStr rangeOfString:@"?"].length==1) {
        NSArray *array = [urlStr componentsSeparatedByString:@"?"];
        if(array && array.count==2) {
            NSString*paramsStr = array[1];
            if(paramsStr.length) {
                NSString* paramterStr = [paramsStr stringByRemovingPercentEncoding];
                NSData *jsonData = [paramterStr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
                return responseDic;
            }
        }
    }
    return nil;
}
// 处理编码字符串
- (NSString*)URLDecodedString:(NSString*)str {
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

- (void)payNotificateAction:(NSNotification *)nofi {
    if (_isSuccess) return;
    NSURL *url = nofi.object;
    if ([url.host isEqualToString:@"safepay"]) {
        NSString * urlNeedJsonStr = url.absoluteString;
        NSArray * afterComArray = [urlNeedJsonStr componentsSeparatedByString:@"?"];
        NSString * lastStr = [self URLDecodedString:afterComArray.lastObject];
        NSData *data = [lastStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];

        if ([dict[@"memo"][@"ResultStatus"] integerValue] == 9000) {
            _isSuccess = YES;
            NSLog(@"Alipay web 支付成功");
        } else {
            NSLog(@"Alipay web 支付失败");
        }
    }
}

#pragma mark ---

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        configuration.userContentController = userContentController;
        // js偏好设置
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.javaScriptEnabled = YES;
        preferences.minimumFontSize = 8;
        configuration.preferences = preferences;

        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, WY_ScreenWidth, WY_ScreenHeight - WY_StatusBar_H) configuration:configuration];
        _webView.navigationDelegate = self;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                           timeoutInterval:20];
        [_webView loadRequest:request];
    }
    return _webView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
