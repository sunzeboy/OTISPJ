//
//  SZBottomWorkingHourView.h
//  OTIS_PJ
//
//  Created by zhangyang on 16/6/20.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZBottomWorkingHourView : UIView

@property (copy, nonatomic) void (^findBtnClickBlock)(UIButton *sender);

@property (copy, nonatomic) void (^scanBtnClickBlock)(UIButton *sender);
@property (weak, nonatomic) IBOutlet UIButton *findBtn;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;

+ (instancetype) loadSZBottomWorkingHourView;

@end
