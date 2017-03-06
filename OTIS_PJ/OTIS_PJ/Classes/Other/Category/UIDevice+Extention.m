//
//  UIDevice+Extention.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "UIDevice+Extention.h"

@implementation UIDevice (Extention)

+(NSString *)currentDeviceUUIDString
{
    return [[UIDevice currentDevice] identifierForVendor].UUIDString;
}


+(NSString*)getAppVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

-(void)getAppInfo{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //    CFShow((__bridge CFTypeRef)(infoDictionary));//注释掉也能拿到数据
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    NSLog(@"app名称: %@-----app版本:%@ ------appBuil版本%@",app_Name,app_Version,app_build);
    
    //手机序列号
    //    NSString* identifierNumber = [[UIDevice currentDevice] uniqueIdentifier];
    //    NSLog(@"手机序列号: %@",identifierNumber);
    //手机别名： 用户定义的名称
    NSString* userPhoneName = [[UIDevice currentDevice] name];
    NSLog(@"手机别名: %@", userPhoneName);
    //设备名称
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    NSLog(@"设备名称: %@",deviceName );
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本: %@", phoneVersion);
    //手机型号
    NSString* phoneModel = [[UIDevice currentDevice] model];
    NSLog(@"手机型号: %@",phoneModel );
    //地方型号  （国际化区域名称）
    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
    NSLog(@"国际化区域名称: %@",localPhoneModel );
    
    NSDictionary *infoDictionary11 = [[NSBundle mainBundle] infoDictionary];
    // 当前应用名称
    NSString *appCurName = [infoDictionary11 objectForKey:@"CFBundleDisplayName"];
    NSLog(@"当前应用名称：%@",appCurName);
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary11 objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    // 当前应用版本号码   int类型
    NSString *appCurVersionNum = [infoDictionary11 objectForKey:@"CFBundleVersion"];
    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
}


@end
