//
//  SZBottomMainView.m
//  OTIS_PJ
//
//  Created by zhangyang on 16/6/21.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZBottomMainView.h"

@implementation SZBottomMainView


+ (instancetype) loadSZBottomMainView {
    
    return [[[NSBundle mainBundle]loadNibNamed:@"SZBottomMainView" owner:self options:nil]lastObject];
}
- (IBAction)findBtnClick:(UIButton *)sender {
    if (self.findBtnClickBlock) {
        self.findBtnClickBlock(sender);
    }
    
}

- (IBAction)scanBtnClick:(UIButton *)sender {
    if (self.scanBtnClickBlock) {
        self.scanBtnClickBlock(sender);
    }
}
@end
