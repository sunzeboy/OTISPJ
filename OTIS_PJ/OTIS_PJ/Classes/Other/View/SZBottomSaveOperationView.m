//
//  SZBottomSaveOperationView.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/12.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZBottomSaveOperationView.h"

@implementation SZBottomSaveOperationView

- (IBAction)saveAct:(UIButton *)sender {
    if (self.confirmActBlock) {
        self.confirmActBlock(sender);
    }
}

+ (instancetype) loadSZBottomSaveOperationView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"SZBottomSaveOperationView" owner:self options:nil]lastObject];
}

@end
