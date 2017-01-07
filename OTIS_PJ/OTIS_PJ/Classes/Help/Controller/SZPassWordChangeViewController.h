//
//  SZPassWordChangeViewController.h
//  OTIS_PJ
//
//  Created by jQ on 16/5/12.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SZPassWordChangeViewController : UIViewController

@property(nonatomic,assign)BOOL isModal;

@property(nonatomic,assign)BOOL isValidationCode;
@property(nonatomic,copy)NSString* validationEmployeeID;


@end
