//
//  SZBottomOperationView.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/12.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZBottomOperationView : UIView

@property (weak, nonatomic) IBOutlet UIButton *allSelectBtn;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@property (copy, nonatomic) void (^confirmActBlock)(UIButton *sender) ;

@property (copy, nonatomic) void (^searchActBlock)(UIButton *sender) ;

@property (copy, nonatomic) void (^allSelectActBlock)(UIButton *sender) ;




+ (instancetype) loadSZBottomOperationView;

@end
