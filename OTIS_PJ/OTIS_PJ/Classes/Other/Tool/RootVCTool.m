//
//  RootVC.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/21.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "RootVCTool.h"
#import "AppDelegate.h"

@implementation RootVCTool

+(void)exchangeRootVCWith:(UIViewController *)vc
{
    AppDelegate *appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    appD.window.rootViewController = vc;

}

@end
