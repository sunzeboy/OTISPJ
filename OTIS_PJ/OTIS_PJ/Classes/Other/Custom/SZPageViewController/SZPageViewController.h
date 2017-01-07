//
//  CXSelfDrivingViewController.h
//  CarLifeStyle
//
//  Created by sunze on 16/2/16.
//  Copyright © 2016年 mijia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZPageViewController : UIViewController

/** 当前选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;

@property (nonatomic , assign) BOOL isNeedSpace;


/**
 *  交给子类自定义初始化
 */
- (void)setupChildVces;
-(void)clickTitle:(UIButton *)button;
- (void)titleClick:(UIButton *)button;
/**
 *  给子类重写该方法是为了更新标题
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;


@end
