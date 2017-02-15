//
//  AppDelegate.m
//  otis__PJ
//
//  Created by sunze on 16/4/20.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Version.h"
#import <AFNetworking.h>
#import "SZAnnualInspectionViewController.h"
#import "AppDelegate+Tip.h"
#import "SZTable_LaborHours.h"


@interface AppDelegate ()



@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

   
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
    [application registerUserNotificationSettings:settings];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self rootController];
    return YES;
}


-(NSInteger)annualInspectionCount{
    return [[[[SZAnnualInspectionViewController alloc] init] array] count];
}


-(void)applicationDidBecomeActive:(UIApplication *)application{
    [self Tip];
    SZLog(@"%s",__func__);
}




@end
