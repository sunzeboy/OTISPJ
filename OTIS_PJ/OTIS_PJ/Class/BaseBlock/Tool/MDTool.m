//
//  MDTool.m
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/14.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import "MDTool.h"
#import <SystemConfiguration/CaptiveNetwork.h>


@implementation MDTool


+ (NSDictionary *)SSIDInfo

{
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    
    NSDictionary *info = nil;
    
    for (NSString *ifnam in ifs) {
        
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        
        if (info && [info count]) {
            break;
        }
    }
    
//    NSString *SSID = dict[@"SSID"];　　　　//WiFi名称
//    
//    NSString *BSSID = dict[@"BSSID"];　　 //无线网的MAC地址
//    
//    NSLog(@"SSID:%@     BSSID:%@",SSID,BSSID);
    
    return info;
}

@end
