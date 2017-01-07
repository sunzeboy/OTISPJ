//
//  SZCollectionViewCell.m
//  OTIS_PJ
//
//  Created by 杜亚伟 on 16/8/8.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZCollectionViewCell.h"
#import "Masonry.h"

@interface SZCollectionViewCell ()<UITextFieldDelegate>

@end

@implementation SZCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setSubviews];
    }
    return self;
}

-(void)setSubviews{
    NSLog(@"-------------------");
    UIButton* checkImageView=[[UIButton alloc] init];
    [checkImageView setImage:[UIImage imageNamed:@"check_off"] forState:UIControlStateNormal];
    [checkImageView setImage:[UIImage imageNamed:@"check_on"] forState:UIControlStateSelected];
    checkImageView.userInteractionEnabled=NO;
    [self.contentView addSubview:checkImageView];
    self.checkImageView=checkImageView;
    
    UILabel* label=[[UILabel alloc] init];
    label.font=[UIFont systemFontOfSize:15.0];
    label.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:label];
    self.label=label;
    
    UITextField* textField=[[UITextField alloc] init];
    textField.hidden=YES;
    textField.delegate=self;
    textField.borderStyle=UITextBorderStyleRoundedRect;
    [self.contentView addSubview:textField];
    self.textField=textField;
    
    [checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY).with.offset(0);
        make.left.equalTo(self.contentView.mas_left).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(20,20));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY).with.offset(0);
        make.left.equalTo(checkImageView.mas_right).with.offset(5);
        make.right.equalTo(self.contentView.mas_right).with.offset(-5);
        make.height.mas_equalTo(20);
    }];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY).with.offset(0);
        make.left.equalTo(checkImageView.mas_right).with.offset(40);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
    }];
    
}

-(void)setJobItem:(SZJHATitleItem *)jobItem{
    _jobItem=jobItem;
    self.label.text= jobItem.Name;
    self.checkImageView.selected=jobItem.select;
    if ([jobItem.Name isEqualToString:SZLocal(@"btn.title.other")]) {
        self.textField.hidden=NO;
        self.textField.text=jobItem.Other;
    }else{
        self.textField.hidden=YES;
    }
}


@end
