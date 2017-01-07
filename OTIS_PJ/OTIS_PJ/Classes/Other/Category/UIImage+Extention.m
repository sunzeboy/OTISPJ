//
//  UIImage+Extention.m
//  OTIS_PJ
//
//  Created by sunze on 16/7/25.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "UIImage+Extention.h"

@implementation UIImage (Extention)


+ (UIImage *) scaleImage:(UIImage *) image withNewSize:(CGSize) newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
