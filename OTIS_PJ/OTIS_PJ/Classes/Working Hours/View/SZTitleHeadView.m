//
//  SZTitleHeadView.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/20.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTitleHeadView.h"

@implementation SZTitleHeadView

+ (instancetype) loadSZTitleHeadView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"SZTitleHeadView" owner:self options:nil]lastObject];
}

@end
