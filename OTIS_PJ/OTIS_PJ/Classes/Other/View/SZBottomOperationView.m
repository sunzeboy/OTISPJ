//
//  SZBottomOperationView.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/12.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZBottomOperationView.h"
#import "MBProgressHUD.h"
#import "SZNavigationController.h"

@implementation SZBottomOperationView

- (IBAction)confirmAct:(UIButton *)sender {
   
    if (self.confirmActBlock) {
        self.confirmActBlock(sender);
    }
}

- (IBAction)allSelectAct:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.allSelectActBlock) {
        self.allSelectActBlock(sender);
    }
}
- (IBAction)searchAct:(UIButton *)sender {
    if (self.searchActBlock) {
        self.searchActBlock(sender);
    }
}

+ (instancetype) loadSZBottomOperationView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"SZBottomOperationView" owner:self options:nil]lastObject];
}

@end
