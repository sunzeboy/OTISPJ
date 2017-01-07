//
//  SZSignBottomOperationView.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/12.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZSignBottomOperationView.h"

@interface SZSignBottomOperationView ()

@end

@implementation SZSignBottomOperationView

- (IBAction)querenAct:(UIButton *)sender {
    if (self.confirmActBlock) {
        self.confirmActBlock(sender);
    }
}

- (IBAction)preAct:(UIButton *)sender {
    if (self.confirmActBlock) {
        self.confirmActBlock(sender);
    }
}

- (IBAction)nextAct:(UIButton *)sender {
    if (self.confirmActBlock) {
        self.confirmActBlock(sender);
    }
}

+ (instancetype) loadSZSignBottomOperationView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"SZSignBottomOperationView" owner:self options:nil]lastObject];
}


@end
