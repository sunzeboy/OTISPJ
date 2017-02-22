//
//  MDBaseNavVC.m
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/9.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import "MDBaseNavVC.h"

@interface MDBaseNavVC ()

@end

@implementation MDBaseNavVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    UINavigationBar* bar=[UINavigationBar appearance];
    [bar setBarTintColor:[UIColor whiteColor]];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0]}];
    [bar setShadowImage:[UIImage new]];
    self.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
