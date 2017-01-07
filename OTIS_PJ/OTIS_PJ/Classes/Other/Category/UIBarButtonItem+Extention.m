//
//  UIBarButtonItem+Extention.m
//  01-UI架构
//
//  Created by 武镇涛 on 15/5/25.
//  Copyright (c) 2015年 wuzhentao. All rights reserved.
//

#import "UIBarButtonItem+Extention.h"
#import "UIView+Extension.h"
@implementation UIBarButtonItem (Extention)

//底部工具的封装
+ (UIBarButtonItem *)itemWithtTarget:(id)target anction:(SEL)action image:(NSString *)image highlightimage:(NSString*)highlightimage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highlightimage] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.size = btn.currentBackgroundImage.size;
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title Target:(id)target anction:(SEL)action image:(NSString *)image highlightimage:(NSString*)highlightimage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:0];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlightimage] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    CGSize size = btn.currentBackgroundImage.size;
    btn.size = CGSizeMake(size.width+70, size.height+25);
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}

@end
