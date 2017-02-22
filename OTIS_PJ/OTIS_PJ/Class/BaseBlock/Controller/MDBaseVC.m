//
//  MDBaseVC.m
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/9.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import "MDBaseVC.h"

@interface MDBaseVC ()

@end

@implementation MDBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.hidesBackButton = YES;
//    [self setBackButton];
}


-(void)setBackButton{
    
    UIButton* button=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 23)];
    button.imageView.contentMode=UIViewContentModeScaleAspectFit;
    button.titleLabel.font=[UIFont systemFontOfSize:14.0];
    button.imageEdgeInsets=UIEdgeInsetsMake(0, -15, 0, 15);
    button.titleEdgeInsets=UIEdgeInsetsMake(0, -10, 0, 10);
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget: self action:@selector(navPopClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:button];
}

-(void)navPopClick:(UIButton*)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
