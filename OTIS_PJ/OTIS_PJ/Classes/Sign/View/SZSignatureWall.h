//
//  SZSignatureWall.h
//  OTIS_PJ
//
//  Created by jQ on 16/5/9.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZSignatureWall : UIView
@property(nonatomic,strong) UIColor *pathColor;
@property(nonatomic,assign) NSInteger lineWidth;
@property(nonatomic,strong) UIImage *image;

@property(nonatomic,copy)void(^changeSaveBtnState)();
/** 保存所有路径的数组 */
@property(nonatomic, strong) NSMutableArray *pathArr;
//clear操作
-(void)clear;
@end
