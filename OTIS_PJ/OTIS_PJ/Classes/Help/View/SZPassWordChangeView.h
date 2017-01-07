//
//  SZPassWordChangeView.h
//  OTIS_PJ
//
//  Created by jQ on 16/5/12.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTextField.h"
#import "SZUserInfo.h"

@interface SZPassWordChangeView : UIView

@property (weak, nonatomic) IBOutlet SZTextField *imputNewPassWordTF;
@property (weak, nonatomic) IBOutlet SZTextField *reImputNewPassWordTF;

@property(nonatomic,assign)BOOL isValidationCode;
@property(nonatomic,assign)BOOL isModol;


@property(nonatomic,copy)NSString* validationEmployeeID;

@property (nonatomic , strong) SZUserInfo *userInfo;


@property(nonatomic,copy)void(^backBlock)();
@property(nonatomic,copy)void(^popBlock)();

+ (instancetype) loadSZPassWordChangeView;



@end
