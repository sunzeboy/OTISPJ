//
//  SZBottomWhInputView.h
//  OTIS_PJ
//
//  Created by zhangyang on 16/6/23.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZBottomWhInputView : UIView

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

+ (instancetype) loadSZBottomWhInputView;

@property (copy, nonatomic) void (^addBtnClickBlock)(UIButton *sender);

@property (copy, nonatomic) void (^saveBtnClickBlock)(UIButton *sender);

@end
