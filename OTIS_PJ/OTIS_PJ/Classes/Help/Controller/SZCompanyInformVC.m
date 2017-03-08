//
//  SZCompanyInformVC.m
//  OTIS_PJ
//
//  Created by 杜亚伟 on 2017/3/6.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

#import "SZCompanyInformVC.h"
#import <WebKit/WebKit.h>
@interface SZCompanyInformVC ()

@property(nonatomic,weak) WKWebView* wkWebview;

@end

@implementation SZCompanyInformVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"企业通知";
    [self cleanCacheAndCookie];
    WKWebView* webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    self.wkWebview = webView;
    [self.wkWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.otisoess.com:22283/newsview/"]]];
}

/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}
@end
