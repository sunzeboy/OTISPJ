//
//  MDLoginVC.m
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/9.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import "MDLoginVC.h"
#import "Masonry.h"
#import "MCHomeVC.h"
#import "MDBaseTextField.h"

@interface MDLoginVC ()

@property(nonatomic,weak) MDBaseTextField* userTextField;
@property(nonatomic,weak) MDBaseTextField* passWordTextField;
@property(nonatomic,weak) UIButton* loginButton;

@end


@implementation MDLoginVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChagnge) name:UITextFieldTextDidChangeNotification object:nil];
    [self setSubviews];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:IsAutomatickey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)setSubviews{
    
    UIImageView* topImageView=[[UIImageView alloc] init];
    topImageView.contentMode=UIViewContentModeScaleAspectFit;
    topImageView.image=[UIImage imageNamed:@"logo"];
    [self.view addSubview:topImageView];
    
    UIImageView* leftImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    leftImageView.contentMode=UIViewContentModeScaleAspectFit;
    leftImageView.image=[UIImage imageNamed:@"loginUser"];
    [self.view addSubview:leftImageView];
    
    MDBaseTextField* userTextField=[[MDBaseTextField alloc] init];
    userTextField.leftView=leftImageView;
    userTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"PrintUserName", nil) attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    [self.view addSubview:userTextField];
    self.userTextField=userTextField;
    
    UIImageView* passwordleftImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    passwordleftImageView.contentMode=UIViewContentModeScaleAspectFit;
    passwordleftImageView.image=[UIImage imageNamed:@"loginPassword"];
    [self.view addSubview:passwordleftImageView];
    
    MDBaseTextField* passWordTextField=[[MDBaseTextField alloc] init];
    passWordTextField.leftView=passwordleftImageView;
    passWordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"PrintPassword", nil) attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    [self.view addSubview:passWordTextField];
    self.passWordTextField=passWordTextField;
    
    UIButton* loginButton=[[UIButton alloc] init];
//    loginButton.enabled=NO;
    loginButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [loginButton setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"loginBtn"] forState:UIControlStateNormal];
    [loginButton addTarget: self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    self.loginButton=loginButton;
    
    
    
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(100);
        make.size.mas_equalTo(CGSizeMake(MDScreenW*0.6, 60));
    }];
    
    [userTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
        make.top.equalTo(topImageView.mas_bottom).with.offset(30);
        make.size.mas_equalTo(CGSizeMake(MDScreenW-30, 50));
    }];
    
    [passWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
        make.top.equalTo(userTextField.mas_bottom).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(MDScreenW-30, 50));
    }];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
        make.top.equalTo(passWordTextField.mas_bottom).with.offset(40);
        make.size.mas_equalTo(CGSizeMake(MDScreenW-30, 50));
    }];
}

-(void)loginClick:(UIButton*)button{
    NSLog(@"可以点击");
    MCHomeVC* homeVC=[[MCHomeVC alloc] init];
    [self.navigationController pushViewController:homeVC animated:YES];
    
//    NSURL *appBUrl = [NSURL URLWithString:@"SVTApp://eventLog=123&elevCode=79NH5879&pwd=svtApp"];
//    
//    // 2.判断手机中是否安装了对应程序
//    if ([[UIApplication sharedApplication] canOpenURL:appBUrl]) {
//        // 3. 打开应用程序App-B
//        [[UIApplication sharedApplication] openURL:appBUrl];
//    } else {
//        NSLog(@"没有安装");
//    }
}

-(void)textChagnge{
    self.loginButton.enabled=self.userTextField.text.length&&self.passWordTextField.text.length;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
