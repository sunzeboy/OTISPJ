//
//  SZTextField.m
//  OTIS_PJ
//
//  Created by sunze on 16/5/6.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTextField.h"

@interface SZTextField ()

@property (nonatomic , assign) CGFloat imageW;


@end

@implementation SZTextField


- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}


- (void)setup
{


    self.backgroundColor = [UIColor clearColor];
    
    CGSize imageSize = self.background.size;
    CGFloat imageW = imageSize.width;
    CGFloat imageH = imageSize.height;
    self.imageW = imageW;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 26+imageW, imageH)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.background];
    imageView.center = backView.center;
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(25+imageW, 0, 1, imageH)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"d2d2d2"];
    
    [backView addSubview:imageView];
    [backView addSubview:lineView];
    
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = backView;
    
    self.background = nil;
}

//控制placeHolder的位置，左右缩20
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    
    //return CGRectInset(bounds, 20, 0);
    CGRect inset = CGRectMake(bounds.origin.x+26+self.imageW+20, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
    return inset;
}

//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    //return CGRectInset(bounds, 20, 0);
    CGRect inset = CGRectMake(bounds.origin.x+26+self.imageW+20, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
    return inset;;
}

//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    //return CGRectInset(bounds, 20, 0);
    CGRect inset = CGRectMake(bounds.origin.x+26+self.imageW+20, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
    return inset;;
    
}

@end
