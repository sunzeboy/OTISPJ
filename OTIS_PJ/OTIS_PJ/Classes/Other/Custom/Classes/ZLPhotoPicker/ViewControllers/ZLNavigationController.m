//
//  ZLNavigationController.m
//  ZLAssetsPickerDemo
//
//  Created by sunzeboy on 15/11/25.
//  Copyright © 2015年 com.zixue101.www. All rights reserved.
//

#import "ZLNavigationController.h"

@interface ZLNavigationController ()

@end

@implementation ZLNavigationController

- (BOOL)shouldAutorotate{
    
    return NO;
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
