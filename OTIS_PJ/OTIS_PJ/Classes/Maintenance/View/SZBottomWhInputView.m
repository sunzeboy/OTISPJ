//
//  SZBottomWhInputView.m
//  OTIS_PJ
//
//  Created by zhangyang on 16/6/23.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZBottomWhInputView.h"

@implementation SZBottomWhInputView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype) loadSZBottomWhInputView {
    
    return [[[NSBundle mainBundle]loadNibNamed:@"SZBottomWhInputView" owner:self options:nil]lastObject];
}
- (IBAction)addButtonClick:(UIButton *)sender {
    if (self.addBtnClickBlock) {
        self.addBtnClickBlock(sender);
    }
}
- (IBAction)saveBtnClick:(UIButton *)sender {
    if (self.saveBtnClickBlock) {
        self.saveBtnClickBlock(sender);
    }
}

@end
