//
//  SZTipVIew.h
//  OTIS_PJ
//
//  Created by sunze on 16/7/23.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZTipVIew : UIView

@property (copy, nonatomic) void (^confirmActBlock)() ;

- (IBAction)confirmAct:(UIButton *)sender;

+ (instancetype) loadSZTipVIew;

@end
