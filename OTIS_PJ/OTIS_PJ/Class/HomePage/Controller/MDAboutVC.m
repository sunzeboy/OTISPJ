//
//  MDAboutVC.m
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/15.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import "MDAboutVC.h"
#import "Masonry.h"
#import "UIDevice+Extention.h"
@interface MDAboutVC ()

@end

@implementation MDAboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"关于";
    
    UIImageView* backImageView=[[UIImageView alloc] init];
    backImageView.contentMode=UIViewContentModeScaleAspectFit;
    backImageView.image=[UIImage imageNamed:@"mdabout"];
    [self.view addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
        make.centerY.equalTo(self.view.mas_centerY).with.offset(-100);
        make.size.mas_equalTo(CGSizeMake(250, 150));
    }];
    
    UILabel* titleLabel=[[UILabel alloc] init];
//    titleLabel.backgroundColor=[UIColor redColor];
    titleLabel.textColor=[UIColor lightGrayColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:15.0];
    titleLabel.text=@"Helpdesk电话:";
    [self.view addSubview:titleLabel];
    
    UIButton* phoneLabel=[[UIButton alloc] init];
    [phoneLabel setTitle:@"姓名1: 15618253221" forState:UIControlStateNormal];
    [phoneLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    phoneLabel.titleLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:phoneLabel];
    
    UILabel* phoneLabel1=[[UILabel alloc] init];
    phoneLabel1.textColor=[UIColor blackColor];
    phoneLabel1.textAlignment=NSTextAlignmentCenter;
    phoneLabel1.text=@"姓名2: 15618253221";
    [phoneLabel1 sizeToFit];
    phoneLabel1.numberOfLines=0;
    [self.view addSubview:phoneLabel1];
    
    UILabel* phoneLabel2=[[UILabel alloc] init];
    phoneLabel2.textAlignment=NSTextAlignmentCenter;
    phoneLabel2.text=@"姓名3: 15618253221";
    phoneLabel2.textColor=[UIColor blackColor];
    [phoneLabel2 sizeToFit];
    phoneLabel2.numberOfLines=0;
    [self.view addSubview:phoneLabel2];
    
    UILabel* phoneLabel3=[[UILabel alloc] init];
    phoneLabel3.textAlignment=NSTextAlignmentCenter;
    phoneLabel3.textColor=[UIColor blackColor];
    phoneLabel3.text=@"姓名4: 15618253221";
    [phoneLabel3 sizeToFit];
    phoneLabel3.numberOfLines=0;
    [self.view addSubview:phoneLabel3];
    
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-180);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    [phoneLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneLabel.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    [phoneLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneLabel1.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    [phoneLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneLabel2.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    UIImageView* leftImageView=[[UIImageView alloc] init];
    leftImageView.image=[UIImage imageNamed:@"aboutPhone"];
    [self.view addSubview:leftImageView];
    
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(titleLabel.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.equalTo(titleLabel.mas_centerY).with.offset(0);
    }];
    
    UILabel* versionLabel=[[UILabel alloc] init];
    versionLabel.font=[UIFont systemFontOfSize:15.0];
    versionLabel.textColor=MDColor(23, 22, 65, 1.0);
    versionLabel.textAlignment=NSTextAlignmentCenter;
    versionLabel.text=[NSString stringWithFormat:@"Version：%@",[UIDevice getAppVersion]];
    [self.view addSubview:versionLabel];
    
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-30);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
}

@end
