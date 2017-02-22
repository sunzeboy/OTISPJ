//
//  MDBaseTextField.m
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/13.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import "MDBaseTextField.h"

@implementation MDBaseTextField

-(instancetype)init{
    
    if (self=[super init]) {
        self.layer.cornerRadius=5;
        self.layer.masksToBounds=YES;
        self.layer.borderColor=[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0].CGColor;
        self.layer.borderWidth=0.5;
        self.leftViewMode=UITextFieldViewModeAlways;
    }
    return self;
}

@end
