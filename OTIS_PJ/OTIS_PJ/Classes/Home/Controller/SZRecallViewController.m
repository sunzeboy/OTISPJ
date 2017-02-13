//
//  SZRecallViewController.m
//  OTIS_PJ
//
//  Created by sunze on 2017/1/19.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

#import "SZRecallViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "CustomIOSAlertView.h"
#import<CommonCrypto/CommonDigest.h>



@interface SZRecallViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic , strong) JSContext *context;

@property (nonatomic , copy) NSString *qrCode;

@end

@implementation SZRecallViewController
-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSURLRequest *request= [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.30.157/CallBack/main.html"]];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@?userName=%@&passWord=%@&tabType=0",SZOuterNetworkCallback,[OTISConfig EmployeeID],[self md5:[OTISConfig userPW]]];
    NSURLRequest *request= [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    self.webView.delegate = self;
    [self.webView loadRequest:request];
    
}

- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        [output appendFormat:@"%02x", digest[i]];
    }
    
    
    [output deleteCharactersInRange:NSMakeRange(30, 2)];
    
    return output;
}

#pragma - mark UIWebViewDelegate



-(void)webViewDidStartLoad:(UIWebView *)webView {
    
    SZLog(@"webViewDidStartLoad");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    SZLog(@"webViewDidFinishLoad");
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"--------%@", exceptionValue);
    };
    
    
    WEAKSELF
    self.context[@"popVc"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
        
    };
    
    self.context[@"scanQrcode"] = ^(){
        [weakSelf ZhiFuBaoStyle];
        
    };
   // self.context[@"qrcodeResult"] = ^NSString *(NSString *qrcode){
     //   return weakSelf.qrCode;
    //};
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:@"提示"
                                                                                 dialogContents:@"打开网页失败，请确保网络连接正常，稍后返回主功能页面！"
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        [alertView close];
        [self.navigationController popViewControllerAnimated:YES];
    };
    [alertView show];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}


#pragma mark --模仿支付宝
- (void)ZhiFuBaoStyle
{
    
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 60;
    style.xScanRetangleOffset = 30;
    
    if ([UIScreen mainScreen].bounds.size.height <= 480 )
    {
        //3.5inch 显示的扫码缩小
        style.centerUpOffset = 40;
        style.xScanRetangleOffset = 20;
    }
    
    
    style.alpa_notRecoginitonArea = 0.6;
    
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 2.0;
    style.photoframeAngleW = 16;
    style.photoframeAngleH = 16;
    
    style.isNeedShowRetangle = NO;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    
    //使用的支付宝里面网格图片
    UIImage *imgFullNet = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_full_net"];
    
    style.animationImage = imgFullNet;
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    
    WEAKSELF
    vc.SuccessBlock = ^(SZQRCodeProcotolitem *item){
        
        weakSelf.qrCode = item.UNIT_NO;
        JSValue *function = [self.context objectForKeyedSubscript:@"qrcodeResult"];
        JSValue *result = [function callWithArguments:@[item.UNIT_NO]];
    };
    vc.style = style;
    //vc.isOpenInterestRect = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
