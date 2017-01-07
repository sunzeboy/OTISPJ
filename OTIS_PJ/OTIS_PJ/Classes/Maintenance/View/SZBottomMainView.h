//
//  SZBottomMainView.h
//  OTIS_PJ
//
//  Created by zhangyang on 16/6/21.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZBottomMainView : UIView

@property (weak, nonatomic) IBOutlet UIButton *findBtn;

@property (weak, nonatomic) IBOutlet UIButton *scanBtn;

+ (instancetype) loadSZBottomMainView;

@property (copy, nonatomic) void (^findBtnClickBlock)(UIButton *sender);

@property (copy, nonatomic) void (^scanBtnClickBlock)(UIButton *sender);

@end
