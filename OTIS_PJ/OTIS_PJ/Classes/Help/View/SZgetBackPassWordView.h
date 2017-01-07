//
//  SZgetBackPassWordView.h
//  OTIS_PJ
//
//  Created by jQ on 16/6/3.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTextField.h"
@interface SZgetBackPassWordView : UIView
@property (weak, nonatomic) IBOutlet SZTextField *userID;
@property (weak, nonatomic) IBOutlet SZTextField *confirmCode;

@property(strong,nonatomic)NSTimer* timer;
@property(copy,nonatomic)void(^next)(NSString*);





+ (instancetype) loadSZgetBackPassWordView;
-(void)stopTimer;
@end
