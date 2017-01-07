//
//  SZBottomFindView.h
//  OTIS_PJ
//
//  Created by zhangyang on 16/6/21.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZBottomFindView : UIView

@property (copy, nonatomic) void (^findBtnClickBlock)(UIButton *sender);
@property (weak, nonatomic) IBOutlet UIButton *findbtn;

+ (instancetype) loadSZBottomFindView;

@end
