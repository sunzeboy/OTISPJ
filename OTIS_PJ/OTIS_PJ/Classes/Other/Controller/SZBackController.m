//
//  SZBackController.m
//  OTIS_PJ
//
//  Created by 杜亚伟 on 16/7/7.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZBackController.h"
#import "CustomIOSAlertView.h"

@implementation SZBackController

- (BOOL)shouldAutorotate{
    
    return NO;
}


-(void)viewDidLoad{
    [super viewDidLoad];
    [self setNavItem];
}

-(void)setNavItem{
    
    UIButton* backBtn=[[UIButton alloc] init];
    backBtn.bounds=CGRectMake(0, 0, 50, 30);
    backBtn.imageEdgeInsets=UIEdgeInsetsMake(0, -10, 0, 0);
    backBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(backControllerBack) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

-(void)backControllerBack{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                 dialogContents:_alertTitle
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        if(buttonIndex == 0){
            [self.navigationController popViewControllerAnimated:YES];
            [alertView close];
        }else if(buttonIndex == 1){
            [alertView close];
        }
    };
    [alertView show];
}

@end
