//
//  MDAboutVC.m
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/15.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import "MDAboutVC.h"
#import "Masonry.h"
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
    titleLabel.textColor=[UIColor lightGrayColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:15.0];
    titleLabel.text=@"Helpdesk电话：13162153278";
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-100);
        make.size.mas_equalTo(CGSizeMake(210, 20));
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
    versionLabel.text=@"V 1.0";
    [self.view addSubview:versionLabel];
    
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
}






@end
