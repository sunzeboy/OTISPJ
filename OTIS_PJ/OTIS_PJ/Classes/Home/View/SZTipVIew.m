//
//  SZTipVIew.m
//  OTIS_PJ
//
//  Created by sunze on 16/7/23.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTipVIew.h"

@implementation SZTipVIew


+ (instancetype) loadSZTipVIew
{
    return [[[NSBundle mainBundle]loadNibNamed:@"SZTipVIew" owner:self options:nil]lastObject];
}

- (IBAction)confirmAct:(UIButton *)sender {
    if (self.confirmActBlock) {
        self.confirmActBlock();
    }
    [self removeFromSuperview];
}


@end
