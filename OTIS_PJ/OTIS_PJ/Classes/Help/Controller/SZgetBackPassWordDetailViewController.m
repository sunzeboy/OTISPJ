//
//  SZgetBackPassWordDetailViewController.m
//  OTIS_PJ
//
//  Created by jQ on 16/6/3.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZgetBackPassWordDetailViewController.h"
#import "SZgetBackPassWordView.h"
#import "SZPassWordChangeViewController.h"
#import "UIView+Extension.h"

@interface SZgetBackPassWordDetailViewController ()
@property(strong,nonatomic)SZgetBackPassWordView *detailView;
@end

@implementation SZgetBackPassWordDetailViewController
- (BOOL)shouldAutorotate{
    
    return NO;
}

// 支持屏幕旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return NO;
}
// 画面一开始加载时就是竖向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    if (_detailView.timer) {
       [_detailView stopTimer];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SZLocal(@"title.getBackPassword");
    [self setUpGetBackPWView];
    [self initNav];
    // Do any additional setup after loading the view.
}


-(void)setUpGetBackPWView
{
    WEAKSELF
    _detailView = [SZgetBackPassWordView loadSZgetBackPassWordView];
    //数据设置给View
    _detailView.frame =CGRectMake(0, 64, SCREEN_WIDTH,(SCREEN_HEIGHT - 64));
    [self.view addSubview:_detailView];
    
    _detailView.next=^(NSString* employID){
        NSLog(@"%@",employID);
        SZPassWordChangeViewController* changePasswordVC=[[SZPassWordChangeViewController alloc] init];
        changePasswordVC.isValidationCode=YES;
        changePasswordVC.validationEmployeeID=employID;
        [weakSelf.navigationController pushViewController:changePasswordVC animated:YES];
    };
    
}

//设置title左侧按钮
-(void)initNav{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return"] landscapeImagePhone:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = item;
}
//返回
- (void)goBack{
    [self dismissViewControllerAnimated:NO completion:^{

    }];
}
@end
