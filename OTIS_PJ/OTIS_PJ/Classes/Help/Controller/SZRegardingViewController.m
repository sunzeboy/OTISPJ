//
//  SZRegardingViewController.m
//  OTIS_PJ
//
//  Created by jQ on 16/5/13.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZRegardingViewController.h"
#import "UIViewController+Email.h"

@interface SZRegardingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *verson;
@property (weak, nonatomic) IBOutlet UILabel *telPhoneNum;
@property (weak, nonatomic) IBOutlet UILabel *rolePhone;
@property (weak, nonatomic) IBOutlet UILabel *roleTel;
@property (weak, nonatomic) IBOutlet UILabel *mailLabel;

@end

@implementation SZRegardingViewController
- (BOOL)shouldAutorotate{
    
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SZLocal(@"title.regardingController");
    self.verson.text = [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"OES系统支持热线：022-28101999"];
    NSMutableAttributedString *content1 = [[NSMutableAttributedString alloc] initWithString:@"手机拨打：400-6115566"];
    NSMutableAttributedString *content2 = [[NSMutableAttributedString alloc] initWithString:@"座机拨打：800-8185566"];
    NSMutableAttributedString *content3 = [[NSMutableAttributedString alloc] initWithString:@"邮箱：OEShelpdesk@otis.com"];

    NSRange contentRange = {10, [content length]-10};
    NSRange contentRange1 = {5, [content1 length]-5};
    NSRange contentRange2 = {5, [content2 length]-5};
    NSRange contentRange3 = {3, [content3 length]-3};

    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    [content addAttribute:NSForegroundColorAttributeName value:RGB(30, 32, 81) range:contentRange];

    [content1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange1];
    [content1 addAttribute:NSForegroundColorAttributeName value:RGB(30, 32, 81) range:contentRange1];
    
    [content2 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange2];
    [content2 addAttribute:NSForegroundColorAttributeName value:RGB(30, 32, 81) range:contentRange2];
    
    [content3 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange3];
    [content3 addAttribute:NSForegroundColorAttributeName value:RGB(30, 32, 81) range:contentRange3];
    
    self.telPhoneNum.attributedText = content;
    self.rolePhone.attributedText = content1;
    //self.roleTel.attributedText = content2;
    self.mailLabel.attributedText = content3;

    self.telPhoneNum.tag = 100;
    self.rolePhone.tag = 101;
    self.roleTel.tag = 102;
    self.mailLabel.tag = 103;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTel)];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTel1)];
//    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTel2)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTel3)];

    [self.telPhoneNum addGestureRecognizer:tap];
    [self.rolePhone addGestureRecognizer:tap1];
//    [self.roleTel addGestureRecognizer:tap2];
    [self.mailLabel addGestureRecognizer:tap3];



}


-(void)tapTel{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt:022-28101999"]];
}

-(void)tapTel1{
   
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt:400-6115566"]];
    
}
//-(void)tapTel2{
//    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt:800-8185566"]];
//
//}

-(void)tapTel3{
    [self sendEmailWithCompose:[SZMailCompose composeWithsubject:nil toRecipients:@[@"OEShelpdesk@otis.com"] ccRecipients:nil bccRecipients:nil andeMailContent:nil]];
}

@end
