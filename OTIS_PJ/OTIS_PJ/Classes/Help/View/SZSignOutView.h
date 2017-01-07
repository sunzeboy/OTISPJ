//
//  SZSignOutView.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/12.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZSignOutView : UIView

@property (copy, nonatomic) void (^signOutBlock)() ;


+ (instancetype) loadSZSignOutView;

@end
