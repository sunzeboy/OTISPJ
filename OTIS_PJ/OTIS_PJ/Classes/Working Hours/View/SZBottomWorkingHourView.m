//
//  SZBottomWorkingHourView.m
//  OTIS_PJ
//
//  Created by zhangyang on 16/6/20.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZBottomWorkingHourView.h"

@implementation SZBottomWorkingHourView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+ (instancetype) loadSZBottomWorkingHourView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"SZBottomWorkingHourView" owner:self options:nil]lastObject];
}
- (IBAction)findAct:(id)sender {
    if (self.findBtnClickBlock) {
        self.findBtnClickBlock(sender);
    }
}
- (IBAction)scanf:(UIButton *)sender {
    if (self.scanBtnClickBlock) {
        self.scanBtnClickBlock(sender);
    }
}

@end
