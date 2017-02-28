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
#import "MDSynchronousVC.h"
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    NSLog(@"=====%@",url.absoluteString);
    
    // 1.获取导航栏控制器
    UINavigationController *rootNav = (UINavigationController *)self.window.rootViewController;
    //    // 2.获得主控制器
    //    UIViewController *mainHomeVc = [rootNav.childViewControllers firstObject];
    //
    //    MDSynchronousVC *mainVc = [[MDSynchronousVC alloc] init];
    //
    //    // 3.每次跳转前必须是在跟控制器(细节)
    //    [rootNav popToRootViewControllerAnimated:NO];
    //
    //    // 4.根据字符串关键字来跳转到不同页面
    //    if ([url.absoluteString containsString:@"Page1"]) { // 跳转到应用App-B的Page1页面
    //        // 根据segue标示进行跳转
    //        [mainHomeVc.navigationController pushViewController:mainVc animated:YES];
    //    }
    
    
    NSString* eDeCodeStr=[self URLDecodedString:url.absoluteString];
    
    for (UIViewController* vc in rootNav.childViewControllers) {
        if ([vc isMemberOfClass:[MDSynchronousVC class]]) {
            MDSynchronousVC* synchVC = (MDSynchronousVC*)vc;
            synchVC.appString = [self URLDecodedString:eDeCodeStr];
            synchVC.appBackBlock();
        }
    }
    return YES;
}

-(NSString *)URLDecodedString:(NSString *)str
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

@end
