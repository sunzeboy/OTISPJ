//
//  MDSetingVC.m
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/14.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import "MDSetingVC.h"
#import "Masonry.h"
@interface MDSetingVC ()

@end

@implementation MDSetingVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title=@"设置";

    NSString* isAutomatickey=[[NSUserDefaults standardUserDefaults] objectForKey:IsAutomatickey];
    
    UIView* backView=[[UIView alloc] init];
    backView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:backView];
    
    UIView* lineView1=[[UIView alloc] init];
    lineView1.backgroundColor=MDDescriptionColor;
    [backView addSubview:lineView1];
    
    UIView* lineView2=[[UIView alloc] init];
    lineView2.backgroundColor=MDDescriptionColor;
    [backView addSubview:lineView2];
    
    UILabel* titleLabel=[[UILabel alloc] init];
    titleLabel.font=[UIFont systemFontOfSize:16.0];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.text=@"是否显示自动维护结果？";
    [backView addSubview:titleLabel];
    
    UIImageView* leftImageView=[[UIImageView alloc] init];
    leftImageView.image=[UIImage imageNamed:@"exit"];
    [backView addSubview:leftImageView];
    
    UISwitch* slider=[[UISwitch alloc] init];
    slider.onTintColor=MDColor(9, 94, 255,1.0);
    [slider addTarget:self action:@selector(swichClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:slider];
    
    if (isAutomatickey==nil||[isAutomatickey isEqualToString:@"0"]) {
        slider.on=NO;
    }else{
        slider.on=YES;
    }
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(74);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.mas_equalTo(50);
    }];
    
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).with.offset(0);
        make.right.equalTo(backView.mas_right).with.offset(0);
        make.top.equalTo(backView.mas_top).with.offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).with.offset(0);
        make.right.equalTo(backView.mas_right).with.offset(0);
        make.bottom.equalTo(backView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY).with.offset(0);
        make.left.equalTo(backView.mas_left).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).with.offset(-10);
        make.centerY.equalTo(backView.mas_centerY).with.offset(0);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImageView.mas_right).with.offset(10);
        make.centerY.equalTo(backView.mas_centerY).with.offset(0);
        make.right.equalTo(slider.mas_left).with.offset(-20);
    }];
    [self setLoginButton];
}



-(void)setLoginButton{
    
    UIView* backView=[[UIView alloc] init];
    backView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:backView];
    
    UIView* lineView1=[[UIView alloc] init];
    lineView1.backgroundColor=MDDescriptionColor;
    [backView addSubview:lineView1];
    
    UIView* lineView2=[[UIView alloc] init];
    lineView2.backgroundColor=MDDescriptionColor;
    [backView addSubview:lineView2];
    
    UIButton* button=[[UIButton alloc] init];
    [button setTitle:@"退出登陆" forState:UIControlStateNormal];
    [button setTitleColor:MDColor(9, 94, 255, 1.0) forState:UIControlStateNormal];
    [button addTarget: self action:@selector(exitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(144);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.mas_equalTo(60);
    }];
    
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).with.offset(0);
        make.right.equalTo(backView.mas_right).with.offset(0);
        make.top.equalTo(backView.mas_top).with.offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).with.offset(0);
        make.right.equalTo(backView.mas_right).with.offset(0);
        make.bottom.equalTo(backView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY).with.offset(0);
        make.centerX.equalTo(backView.mas_centerX).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(MDScreenW-40, 40));
    }];
}

-(void)exitClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)swichClick:(UISwitch*)sw{
    
    if (sw.isOn) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:IsAutomatickey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:IsAutomatickey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
@end
