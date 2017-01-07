//
//  SZBottomFindView.m
//  OTIS_PJ
//
//  Created by zhangyang on 16/6/21.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZBottomFindView.h"

@interface SZBottomFindView ()
@property (weak, nonatomic) IBOutlet UIButton *act;

@end

@implementation SZBottomFindView



+ (instancetype) loadSZBottomFindView {
    return [[[NSBundle mainBundle]loadNibNamed:@"SZBottomFindView" owner:self options:nil]lastObject];
}


- (IBAction)findAct:(UIButton *)sender {
    if (self.findBtnClickBlock) {
        self.findBtnClickBlock(sender);
    }
}



@end
