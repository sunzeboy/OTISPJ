//
//  SZUICheckBoxButton.h
//  OTIS_PJ
//
//  Created by zy on 16/5/4.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZUICheckBoxButton : UIControl

{
    
    UILabel *label;
    
    UIImageView *icon;
    
    BOOL checked;
    
    id delegate;
    
}

@property (retain, nonatomic) id delegate;

@property (retain, nonatomic) UILabel *label;

@property (retain, nonatomic) UIImageView *icon;

-(BOOL)isChecked;

-(void)setChecked: (BOOL)flag;

@end
