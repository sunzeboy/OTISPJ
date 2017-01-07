//
//  UIViewController+Email.m
//  sendEmail
//
//  Created by sunze on 2016/10/28.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "UIViewController+Email.h"
#import <MessageUI/MessageUI.h>
#import "CustomIOSAlertView.h"

@implementation SZMailCompose

+(instancetype)composeWithsubject:(NSString *)subject toRecipients:(NSArray<NSString *> *)toRecipients ccRecipients:(NSArray *)ccRecipients bccRecipients:(NSArray *)bccRecipients andeMailContent:(NSString *)emailContent{
    SZMailCompose *compose = [[SZMailCompose alloc] init];
    compose.subject = subject;
    compose.toRecipients = toRecipients;
    compose.ccRecipients = ccRecipients;
    compose.bccRecipients = bccRecipients;
    compose.emailContent = emailContent;
    return compose;
}

@end


@interface UIViewController() <MFMailComposeViewControllerDelegate>

@end

@implementation UIViewController (Email)

-(void)sendEmailWithCompose:(SZMailCompose *)compose{
    if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
        [self sendEmailActionWithCompose:compose]; // 调用发送邮件的代码
    }else{
        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"] options:@{} completionHandler:^(BOOL success) {
//            
//        }];
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:@"请到设置中配置好邮箱账户"
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            [alertView close];
        };
        [alertView show];
        
        
    }
}

- (void)sendEmailActionWithCompose:(SZMailCompose *)compose
{
    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    // 设置邮件主题
    [mailCompose setSubject:compose.subject];
    // 设置收件人
    [mailCompose setToRecipients:compose.toRecipients];
    // 设置抄送人
    [mailCompose setCcRecipients:compose.ccRecipients];
    // 设置密抄送
    [mailCompose setBccRecipients:compose.bccRecipients];
    /**
     *  设置邮件的正文内容
     */
    NSString *emailContent = compose.emailContent;
    // 是否为HTML格式
    [mailCompose setMessageBody:emailContent isHTML:NO];
    // 如使用HTML格式，则为以下代码
    //	[mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
    /**
     *  添加附件
     */
//    UIImage *image = [UIImage imageNamed:@"main_home_bg"];
//    NSData *imageData = UIImagePNGRepresentation(image);
//    [mailCompose addAttachmentData:imageData mimeType:@"" fileName:@"main_home_bg.png"];
    
    // 弹出邮件发送视图
    [self presentViewController:mailCompose animated:YES completion:nil];
}
//MFMailComposeViewControllerDelegate的代理方法：

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled: // 用户取消编辑
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent: // 用户点击发送
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
    }
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
