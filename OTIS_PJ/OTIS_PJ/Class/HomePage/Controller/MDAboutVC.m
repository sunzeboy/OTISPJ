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
    
    UILabel* phoneLabel=[[UILabel alloc] init];
    phoneLabel.attributedText = [self setString:@"杨   柯: 18516290280"];
    phoneLabel.textAlignment=NSTextAlignmentCenter;
    phoneLabel.userInteractionEnabled = YES;
    [self.view addSubview:phoneLabel];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick3:)];
    [phoneLabel addGestureRecognizer:tap];
    
    UILabel* phoneLabel1=[[UILabel alloc] init];
    phoneLabel1.textColor=[UIColor blackColor];
    phoneLabel1.textAlignment=NSTextAlignmentCenter;
    
    phoneLabel1.attributedText = [self setString:@"童倞昱: 18918735200"];
    phoneLabel1.userInteractionEnabled = YES;
    [phoneLabel1 sizeToFit];
    phoneLabel1.numberOfLines=0;
    [self.view addSubview:phoneLabel1];
    UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick3:)];
    [phoneLabel1 addGestureRecognizer:tap1];
    
    UILabel* phoneLabel2=[[UILabel alloc] init];
    phoneLabel2.textAlignment=NSTextAlignmentCenter;
    phoneLabel2.attributedText = [self setString:@"陈仁祥: 13636348928"];
    phoneLabel2.userInteractionEnabled = YES;
    [phoneLabel2 sizeToFit];
    phoneLabel2.numberOfLines=0;
    [self.view addSubview:phoneLabel2];
    UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick3:)];
    [phoneLabel2 addGestureRecognizer:tap2];
    
    UILabel* phoneLabel3=[[UILabel alloc] init];
    phoneLabel3.textAlignment=NSTextAlignmentCenter;
    phoneLabel3.attributedText = [self setString:@"黄文博: 13816777530"];
    phoneLabel3.userInteractionEnabled = YES;
    [phoneLabel3 sizeToFit];
    phoneLabel3.numberOfLines=0;
    [self.view addSubview:phoneLabel3];
    
    UITapGestureRecognizer* tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick3:)];
    [phoneLabel3 addGestureRecognizer:tap3];
    
    
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
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
}

-(void)tapClick3:(UITapGestureRecognizer*)ges{
    UILabel* label = (UILabel*)ges.view;
    NSString* phone = [label.text substringWithRange:NSMakeRange(label.text.length-11, 11)];
    
    UIWebView * callWebview = [[UIWebView alloc]init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phone]]]];
    [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
//    NSString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


-(NSMutableAttributedString*)setString:(NSString*)phone{
    NSDictionary* dic2=@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:MDColor(19, 65, 131, 1.0)};
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString: phone];
    [attributedStr addAttributes:dic2 range: NSMakeRange(attributedStr.length-11, 11)];
    return attributedStr;
}

@end
