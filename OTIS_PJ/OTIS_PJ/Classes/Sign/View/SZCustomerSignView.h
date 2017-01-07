//
//  SZCustomerSignView.h
//  OTIS_PJ
//
//  Created by jQ on 16/5/14.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZCustomerSignDetail.h"
@protocol  signDelegate
-(void) toSignatureBoard;
//-(void) saveBtnClick;
@end

@interface SZCustomerSignView : UIView

@property (copy, nonatomic) void (^evaluateTypeBlock)(NSInteger evaluateType ,int type) ;

@property (copy, nonatomic) void (^confirmActBlock)(UIButton *sender) ;

@property (weak, nonatomic) IBOutlet UIButton *saVerySatisfied;
@property (weak, nonatomic) IBOutlet UIButton *saSatisfied;
@property (weak, nonatomic) IBOutlet UIButton *saUnsatisfied;
@property (weak, nonatomic) IBOutlet UIButton *mqVerySatisfied;
@property (weak, nonatomic) IBOutlet UIButton *mqSatisfied;
@property (weak, nonatomic) IBOutlet UIButton *mqUnsatisfied;

//@property (weak, nonatomic) IBOutlet UIButton *customerAbsence;
@property (weak, nonatomic) IBOutlet UITextField *customerName;
@property (weak, nonatomic) IBOutlet UIButton *sendEmail;
@property (weak, nonatomic) IBOutlet UITextField *emailAddress;
@property (weak, nonatomic) IBOutlet UIImageView* signatureImage;

@property(weak,nonatomic)SZCustomerSignDetail *signDetail;
@property (weak, nonatomic) IBOutlet UIButton *customerAbsence;



+ (instancetype) loadSZCustomerSignView;
@property (nonatomic, weak) id<signDelegate> delegate;
@end
