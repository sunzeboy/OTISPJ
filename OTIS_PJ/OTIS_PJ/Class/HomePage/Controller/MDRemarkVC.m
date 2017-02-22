//
//  MDRemarkVC.m
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/15.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import "MDRemarkVC.h"
#import "Masonry.h"
@interface MDRemarkVC ()

@end

@implementation MDRemarkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRemarkSubviews];
}

-(void)setRemarkSubviews{
    
    UILabel* leftLabel=[[UILabel alloc] init];
    leftLabel.text=@"需要更换";
    [self.view addSubview:leftLabel];
    
    UILabel* rightLabel=[[UILabel alloc] init];
    rightLabel.text=@"需要改造";
    [self.view addSubview:rightLabel];
    
    UIButton* leftbutton=[[UIButton alloc] init];
    leftbutton.backgroundColor=[UIColor yellowColor];
    [leftbutton addTarget: self action:@selector(leftbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftbutton];
    
    UIButton* rightButton=[[UIButton alloc] init];
    rightButton.backgroundColor=[UIColor yellowColor];
    [rightButton addTarget: self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.top.equalTo(self.view.mas_top).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    [leftbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftLabel.mas_centerY).with.offset(0);
        make.left.equalTo(leftLabel.mas_right).with.offset(25);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftLabel.mas_centerY).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(-25);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightButton.mas_left).with.offset(-25);
        make.top.equalTo(leftLabel.mas_top).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    UITextView* textView=[[UITextView alloc] init];
    textView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:textView];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftLabel.mas_bottom).with.offset(10);
        make.left.equalTo(leftLabel.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.mas_equalTo(200);
    }];
    
}

-(void)leftbuttonClick{
    
}

-(void)rightButtonClick{
    
}






@end
