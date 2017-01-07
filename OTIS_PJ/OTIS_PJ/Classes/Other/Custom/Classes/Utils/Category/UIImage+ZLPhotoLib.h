//
//  UIImage+ZLPhotoLib.h
//  MLCamera
//
//  Created by sunzeboy on 15/4/25.
//  Copyright (c) 2015年 www.weibo.com/makezl All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZLPhotoLib)
+ (instancetype)ml_imageFromBundleNamed:(NSString *)name;
- (UIImage *)scaleToSize:(CGSize)size;
- (UIImage *)imageScaleAspectFillFromTop:(CGSize)frameSize;
-(UIImage*)subImageInRect:(CGRect)rect;
- (UIImage *)imageFillSize:(CGSize)viewsize;
@end
