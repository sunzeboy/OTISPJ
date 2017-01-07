//
//  SZSignatureBoardViewController.m
//  OTIS_PJ
//
//  Created by jQ on 16/5/9.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZSignatureBoardViewController.h"
#import "SZSignatureWall.h"
//#import "SZSignDetailBottomOperationView.h"
#import "CustomIOSAlertView.h"


@interface SZSignatureBoardViewController ()
@property (weak, nonatomic) IBOutlet SZSignatureWall *drawView;
@property (weak, nonatomic) IBOutlet UIView *frameView;


@end

@implementation SZSignatureBoardViewController

-(void)viewDidDisappear:(BOOL)animated{

    SZLog(@"viewDidDisappear");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = SZLocal(@"title.signViewController");

    
    
    
}


//使用这里的代码也是oK的。 这里利用 NSInvocation 调用 对象的消息
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([[UIDevice currentDevice]respondsToSelector:@selector(setOrientation:)]) {
        
        SEL selector = NSSelectorFromString(@"setOrientation:");
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        
        [invocation setSelector:selector];
        
        [invocation setTarget:[UIDevice currentDevice]];
        
        int val = UIInterfaceOrientationLandscapeLeft;//横屏
        
        [invocation setArgument:&val atIndex:2];
        
        [invocation invoke];
        
    }
}







- (BOOL)shouldAutorotate{
    return NO;
}
//强制旋转屏幕-e
- (IBAction)btnRefreshClick:(id)sender {
    [_drawView clear];
}

- (IBAction)btnSaveClick:(id)sender {
    [self saveClicked];
}
//清除处理
- (void)refreshClicked{
    [_drawView clear];
}



#pragma mark - 保存
- (void)saveClicked{
    if (self.drawView.pathArr.count > 0) {

        CGSize size = CGSizeMake(_drawView.bounds.size.width, _drawView.bounds.size.height);
    // 截屏
    // 开启上下文
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    
    // 获取上下文
        CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 渲染图层
        [self.drawView.layer renderInContext:ctx];
    
    // 获取上下文中的图片
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        

    // 关闭上下文
        UIGraphicsEndImageContext();
        // 调整分辨率
        CGSize newSize = CGSizeMake(610, 388);
        UIGraphicsBeginImageContext (newSize);
        [image drawInRect : CGRectMake ( 0 , 0 ,newSize. width ,newSize. height )];
        UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext ();
        UIGraphicsEndImageContext ();
    
    // 保存画板的内容放入相册
    // image:写入的图片
    // completionTarget图片保存监听者
    // 注意：以后写入相册方法中，想要监听图片有没有保存完成，保存完成的方法不能随意乱写
        UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

    //向上级画面传递图片
        [self.delegate  sendSignatureImage:newImage];
  

        }else{

    }
    [self.navigationController popViewControllerAnimated:YES];

}
//alert
-(void)alertShow:(NSString *)connents{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                 dialogContents:connents
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        [alertView close];
    };
    [alertView show];
}

// 监听保存完成，必须实现这个方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"保存图片成功");
}



@end
