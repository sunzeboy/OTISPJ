//
//  SZVersionWebViewController.m
//  OTIS_PJ
//
//  Created by sunze on 16/9/27.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZVersionWebViewController.h"
#import "MBProgressHUD.h"

@interface SZVersionWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation SZVersionWebViewController

-(UIWebView *)webView{

    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _webView.delegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"版本说明";
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[SZOuterNetwork stringByAppendingString:@"VersionInfo_IP.html"]]]];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    SZLog(@"web start load!");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    SZLog(@"web finish load!");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}



@end
