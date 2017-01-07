//
//  SZBottomMaintainView.m
//  OTIS_PJ
//
//  Created by zhangyang on 16/6/16.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZBottomMaintainView.h"

@implementation SZBottomMaintainView

-(void)awakeFromNib{
    self.allSelectBtn.selected=NO;
}

- (IBAction)confirmAct:(UIButton *)sender {
    
    if (self.confirmActBlock) {
        self.confirmActBlock(sender);
    }
}

- (IBAction)allSelectAct:(UIButton *)sender {
    if (self.allSelectActBlock) {
        self.allSelectActBlock(sender);
    }
}
- (IBAction)btnSuspendClick:(id)sender {
    if (self.suspendActBlock) {
        self.suspendActBlock(sender);
    }
}

- (IBAction)btnCameraClick:(id)sender {
    if (self.cameraActBlock) {
        self.cameraActBlock(sender);
    }
}

+ (instancetype) loadSZBottomOperationView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"SZBottomMaintainView" owner:self options:nil]lastObject];
}

@end
