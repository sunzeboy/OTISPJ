//
//  SZMaintenanceCheckItem.m
//  OTIS_PJ
//
//  Created by sunze on 16/5/26.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZMaintenanceCheckItem.h"

@implementation SZMaintenanceCheckItem


-(CGFloat)operationTableViewCellHeight{

    // 文字的最大尺寸
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 60, MAXFLOAT);
    // 计算文字的高度
    return  [self.Description boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Microsoft YaHei" size:14]} context:nil].size.height+35;
}


//-(void)setState:(int)state{
//    _state = state;
//    if (_state!=_state2) {
//        self.ischanged = YES;
//    }
//
//}

-(BOOL)ischanged{

    if (self.state!=self.state2) {
        return YES;
    }
    return NO;
}

@end
