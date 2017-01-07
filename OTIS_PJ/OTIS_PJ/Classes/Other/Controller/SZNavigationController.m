//
//  SZNavigationController.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/20.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZNavigationController.h"
#import "UIBarButtonItem+Extention.h"
#import "RootVCTool.h"
#import "HomeViewController.h"
#import "SZMaintenanceOperationViewController.h"
#import "SZMaintainDetailViewController.h"
#import "SZInputWorkingHourViewController.h"
#import "SZSignatureBoardViewController.h"

@interface SZNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation SZNavigationController

+ (void)initialize {
    
    UIBarButtonItem *item  = [UIBarButtonItem appearance];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置不可用状态
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    disableTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    //------------------------------------------------------------------------------------------------------------------------------------------------

    UINavigationBar *bar  = [UINavigationBar appearance];
    [bar setBarTintColor:RGB(30, 32, 81)];
    [bar setTintColor:[UIColor whiteColor]];
    [bar setTitleTextAttributes:disableTextAttrs];
    bar.translucent = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate =  self;

    self.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1 ) {
        return NO;
    }
    
    return YES;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {


    if (self.viewControllers.count == 0) {
//        viewController.hidesBottomBarWhenPushed = NO;
//        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:SZLocal(@"btn.title.back") Target:self anction:@selector(dismissNav) image:@"return.png" highlightimage:@"return.png"];
    }else{
        
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:SZLocal(@"btn.title.back") Target:self anction:@selector(back:) image:@"return.png" highlightimage:@"return.png"];
    }
    [super pushViewController:viewController animated:YES];
    
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    if ([viewController isKindOfClass:[SZMaintenanceOperationViewController class]]) {
//        NSMutableArray *array = [NSMutableArray arrayWithArray:self.viewControllers];
//        [array removeObjectAtIndex:self.viewControllers.count-2];
//        [self setValue:array forKeyPath:@"viewControllers"];
//    }

}
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[SZMaintainDetailViewController class]]||[viewController isKindOfClass:[SZInputWorkingHourViewController class]]) {
        viewController.hidesBottomBarWhenPushed = YES;
        self.navigationController.toolbarHidden = YES;
    }
}

-(void)dismissNav
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)back:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[SZMaintenanceOperationViewController class]]) {
        UIViewController *vc = [self.viewControllers objectAtIndex:self.viewControllers.count-2];
        [self popToViewController:vc  animated:YES];
    }
    [self popViewControllerAnimated:YES];
}


-(BOOL)shouldAutorotate{
    if ([self.topViewController isKindOfClass:[SZSignatureBoardViewController class]]) {
        return YES;
    }
    return NO;
}
//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([self.topViewController isKindOfClass:[SZSignatureBoardViewController class]]) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}


// 支持屏幕旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return NO;
}
// 画面一开始加载时就是竖向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if ([self.topViewController isKindOfClass:[SZSignatureBoardViewController class]]) {
        return UIInterfaceOrientationLandscapeRight;
    }
    return UIInterfaceOrientationPortrait;
}



@end
