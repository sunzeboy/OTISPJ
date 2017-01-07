//
//  SZSignDetailBottomOperationView.m
//  OTIS_PJ
//
//  Created by jQ on 16/6/13.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZSignDetailBottomOperationView.h"

@implementation SZSignDetailBottomOperationView


- (IBAction)resignAct:(UIButton *)sender {
    if (self.confirmActBlock) {
        self.confirmActBlock(sender);
    }
}

- (IBAction)confirmAct:(UIButton *)sender {
    if (self.confirmActBlock) {
        self.confirmActBlock(sender);
    }
}

+ (instancetype) loadSZSignDetailBottomOperationView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"SZSignDetailBottomOperationView" owner:self options:nil]lastObject];
}

@end
