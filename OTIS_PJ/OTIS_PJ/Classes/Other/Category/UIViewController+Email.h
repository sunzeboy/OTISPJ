//
//  UIViewController+Email.h
//  sendEmail
//
//  Created by sunze on 2016/10/28.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZMailCompose : NSObject
@property (nonatomic , copy) NSString  *subject;
@property (nonatomic , strong) NSArray<NSString *> *toRecipients;
@property (nonatomic , strong) NSArray *ccRecipients;
@property (nonatomic , strong) NSArray *bccRecipients;
@property (nonatomic , copy) NSString  *emailContent;

+(instancetype)composeWithsubject:(NSString *)subject toRecipients:(NSArray<NSString *> *)toRecipients ccRecipients:(NSArray *)ccRecipients bccRecipients:(NSArray *)bccRecipients andeMailContent:(NSString *)emailContent;

@end


@interface UIViewController (Email)
-(void)sendEmailWithCompose:(SZMailCompose*)compose;
@end
