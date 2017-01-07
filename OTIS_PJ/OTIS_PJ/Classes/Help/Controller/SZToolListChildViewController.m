//
//  SZToolListChildViewController.m
//  OTIS_PJ
//
//  Created by jQ on 16/6/8.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZToolListChildViewController.h"
#import "MBProgressHUD.h"

@interface SZToolListChildViewController ()<UIWebViewDelegate>
@property(retain,nonatomic) IBOutlet UIWebView *toolwebview;
@property(nonatomic,strong) NSURL * toolUrl;
@end

@implementation SZToolListChildViewController
- (BOOL)shouldAutorotate{
    
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame =CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _toolwebview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT-100)];
    _toolwebview.scalesPageToFit = YES;
    [_toolwebview setDelegate:self];
    [self.view addSubview:_toolwebview];
    //编辑URL
    [self urlEdit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//URL编辑方法
-(void)urlEdit{
    NSString * urlAttend = SZNetwork;
    NSString * urlFinal;
    if(self.index ==0){
        //必须工具
        urlFinal = [urlAttend stringByAppendingString:@"ToolsListIndex4.html"];
    }else if(self.index ==1){
        //常用工具
        urlFinal = [urlAttend stringByAppendingString:@"ToolsListIndex.html"];
    }else if(self.index ==2){
        //专用工具－直升梯
        urlFinal = [urlAttend stringByAppendingString:@"ToolsListIndex1.html"];
    }else if(self.index ==3){
        //专用工具－扶梯和人行道
        urlFinal = [urlAttend stringByAppendingString:@"ToolsListIndex2.html"];
    }else if(self.index ==4){
        //不常用工具
        urlFinal = [urlAttend stringByAppendingString:@"ToolsListIndex3.html"];
    }
    _toolUrl = [NSURL URLWithString:urlFinal];
    //根据URL载入页面
    NSURLRequest *request= [NSURLRequest requestWithURL:_toolUrl];
    [_toolwebview loadRequest:request];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    SZLog(@"web start load!");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    SZLog(@"web finish load!");
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}

-(void)webView:(UIWebView *)webView didFailLoadWithError:( NSError *)error{
    SZLog(@"web error :%@",error);
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
