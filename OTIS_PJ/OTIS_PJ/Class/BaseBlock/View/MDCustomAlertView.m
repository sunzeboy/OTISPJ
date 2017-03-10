//
//  MDCustomAlertView.m
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/16.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import "MDCustomAlertView.h"
#import "Masonry.h"
#import "CustomTextView.h"
#import "FDAlertView.h"

@interface MDCustomAlertView ()<UITextViewDelegate>

@property(nonatomic,weak) UIButton* cancleButton;

@property(nonatomic,weak) UIButton* confirmButton;

@end

@implementation MDCustomAlertView


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame: frame]) {
        self.backgroundColor=[UIColor whiteColor];
        self.layer.cornerRadius=5;
        self.layer.masksToBounds=YES;
        [self setSubviews];
    }
    return self;
}

-(void)setSubviews{
    
    UILabel* titleLabel=[[UILabel alloc] init];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.text=@"原因";
    [self addSubview:titleLabel];
    
    UIView* lineView1=[[UIView alloc] init];
    lineView1.backgroundColor=MDLightColor;
    [self addSubview:lineView1];
    
    UIView* lineView2=[[UIView alloc] init];
    lineView2.backgroundColor=MDLightColor;
    [self addSubview:lineView2];
    
    CustomTextView* mccTextField=[[CustomTextView alloc] init];
    mccTextField.placeholder=@"当两个结果不一致时，必须填写原因";
    mccTextField.delegate=self;
    [self addSubview:mccTextField];
    self.textView=mccTextField;
    
    UIButton* cancleButton=[[UIButton alloc] init];
    cancleButton.layer.cornerRadius=3;
    cancleButton.layer.masksToBounds=YES;
    cancleButton.layer.borderWidth=0.5;
    cancleButton.layer.borderColor=MDLightColor.CGColor;
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:MDColor(9, 94, 255, 1.0) forState:UIControlStateNormal];
    
    [cancleButton addTarget: self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancleButton];
    self.cancleButton=cancleButton;
    
    UIButton* confirmButton=[[UIButton alloc] init];
    confirmButton.layer.cornerRadius=3;
    confirmButton.layer.masksToBounds=YES;
    confirmButton.enabled=NO;
    confirmButton.backgroundColor=[UIColor clearColor];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"alertViewConfirm_enable"] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"alertViewConfirm_disEnable"] forState:UIControlStateDisabled];

    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];

    [confirmButton addTarget: self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmButton];
    self.confirmButton=confirmButton;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [mccTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView1.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(70);
    }];
    
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mccTextField.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(25);
        make.top.equalTo(lineView2.mas_bottom).with.offset(15);
        make.right.equalTo(self.mas_centerX).with.offset(-5);
        make.height.mas_equalTo(45);
    }];
    
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-25);
        make.top.equalTo(lineView2.mas_bottom).with.offset(15);
        make.left.equalTo(self.mas_centerX).with.offset(5);
        make.height.mas_equalTo(45);
    }];
}

- (void)textViewDidChange:(UITextView *)textView{
    
    self.confirmButton.enabled = textView.text.length;
}


-(void)cancleClick{
    FDAlertView *alert = (FDAlertView *)self.superview;
    [alert hide];
    
    if (self.cancleBlcok) {
        self.cancleBlcok();
    }
}

-(void)confirmClick{
    FDAlertView *alert = (FDAlertView *)self.superview;
    [alert hide];
    
    NSString* tempStr = self.textView.text;
    
    if (self.jumpBlcok) {
        self.jumpBlcok(tempStr);
    }
    
}

@end
