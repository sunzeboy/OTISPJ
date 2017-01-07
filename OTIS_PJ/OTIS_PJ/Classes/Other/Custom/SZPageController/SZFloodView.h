//
//  SZFloodView.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/20.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZFloodView : UIView

@property (nonatomic, strong)UIColor  *color;
@property (nonatomic, assign)BOOL isStroke;
@property (nonatomic, assign)BOOL isLine;
@property (nonatomic, assign)CGColorRef FillColor;

@end
