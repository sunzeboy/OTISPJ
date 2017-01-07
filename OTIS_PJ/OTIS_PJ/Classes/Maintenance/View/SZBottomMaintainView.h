//
//  SZBottomMaintainView.h
//  OTIS_PJ
//
//  Created by zhangyang on 16/6/16.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZBottomMaintainView : UIView

@property (weak, nonatomic) IBOutlet UIButton *allSelectBtn;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet UIButton *suspendBtn;

@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;

@property (copy, nonatomic) void (^allSelectActBlock)(UIButton *sender);

@property (copy, nonatomic) void (^confirmActBlock)(UIButton *sender);

@property (copy, nonatomic) void (^suspendActBlock)(UIButton *sender);

@property (copy, nonatomic) void (^cameraActBlock)(UIButton *sender);

+ (instancetype) loadSZBottomOperationView;

@end
