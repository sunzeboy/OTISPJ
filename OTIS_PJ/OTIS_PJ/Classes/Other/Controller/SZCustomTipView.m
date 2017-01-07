//
//  SZCustomTipView.m
//  aosima
//
//  Created by sunze on 2016/10/28.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZCustomTipView.h"
#define MAS_SHORTHAND_GLOBALS
#define MAS_SHORTHAND
#import "Masonry.h"
@interface SZCustomTipView ()

@property (nonatomic, strong) UIView      *backView;

@property (nonatomic, strong) UILabel     *titleLable;



@end

@implementation SZCustomTipView



-(instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.type = MMPopupTypeCustom;
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(300, 200));
            
        }];
        
        self.backView = [UIView new];
        [self addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        self.backView.layer.cornerRadius = 5.0f;
        self.backView.clipsToBounds = YES;
        self.backView.backgroundColor = [UIColor whiteColor];
        
        
        self.titleLable = [UILabel new];
        [self.backView addSubview:self.titleLable];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.backView).insets(UIEdgeInsetsMake(0, 19, 0, 19));
            make.height.equalTo(@50);
        }];
        self.titleLable.text = @"温馨提示";
        self.titleLable.textColor = MMHexColor(0x333333FF);
        self.titleLable.font = [UIFont boldSystemFontOfSize:20];
        self.titleLable.textAlignment = NSTextAlignmentCenter;
        
        UILabel *content = [UILabel new];
        [self.backView addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.backView).insets(UIEdgeInsetsMake(0, 20, 0, 20));
            make.height.equalTo(@60);
            make.top.equalTo(self.titleLable.bottom).offset(15);
            
        }];
        content.text = @"您还未录入工时，请完成工时录入！";
        content.textColor = [UIColor lightGrayColor];
        content.font = [UIFont boldSystemFontOfSize:15];
        content.textAlignment = NSTextAlignmentCenter;
        content.numberOfLines = 0;
        
        
        UIButton *btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
        btnConfirm.tag = 100;
        [self.backView addSubview:btnConfirm];
        [btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.backView.bottom).offset(-10);
            make.left.equalTo(self.backView.left).offset(10);
            make.right.equalTo(self.backView.right).offset(-10);
            make.height.equalTo(40);

        }];
        btnConfirm.backgroundColor = [UIColor colorWithRed:0 green:121/255.0 blue:1.0 alpha:1];
        btnConfirm.layer.cornerRadius = 5;
        [btnConfirm setTitle:@"确认" forState:0];
        [btnConfirm addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];

      
        
    }
    
    return self;
}






- (void)pressBtn:(UIButton *)btn
{
    if (btn.tag == 100) {//queren
        if (self.btnClickBlock) {
            self.btnClickBlock();
        }
    }else{
        
    }
    [self hide];
}




@end
