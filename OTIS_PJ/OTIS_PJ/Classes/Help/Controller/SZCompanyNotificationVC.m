//
//  SZCompanyNotificationVC.m
//  OTIS_PJ
//
//  Created by 杜亚伟 on 2017/3/8.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

#import "SZCompanyNotificationVC.h"
#import <WebKit/WebKit.h>
@interface SZCompanyNotificationVC ()

@end

@implementation SZCompanyNotificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"企业通知";
    WKWebView* webview = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webview];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.otisoess.com:22283/newsview/"]]];
}

@end
