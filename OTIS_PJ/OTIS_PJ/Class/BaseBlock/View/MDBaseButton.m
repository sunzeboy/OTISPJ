//
//  MDBaseButton.m
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/9.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import "MDBaseButton.h"

@implementation MDBaseButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGRect rect=CGRectMake(contentRect.origin.x, contentRect.origin.y+45, contentRect.size.width, contentRect.size.height);
    return rect;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    UIImage* image=[UIImage imageNamed:@"home1"];
    CGRect rect=CGRectMake(contentRect.size.width/2.0-image.size.width/2.0, -10, image.size.width, image.size.height);
    return rect;
}

@end


@implementation MDMaintainButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGRect rect=CGRectMake(contentRect.origin.x, contentRect.origin.y+30, contentRect.size.width, contentRect.size.height/2.0);
    return rect;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    UIImage* image=[UIImage imageNamed:@"btn_scan"];
    CGRect rect=CGRectMake(contentRect.size.width/2.0-image.size.width/2.0, 2, image.size.width, image.size.height);
    return rect;
}

@end
