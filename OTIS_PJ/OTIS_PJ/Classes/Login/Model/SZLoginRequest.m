//
//  SZLoginRequest.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZLoginRequest.h"

@implementation SZLoginRequest

+(instancetype)requestWithUserNo:(NSString *)UserNo Password:(NSString *)Password Number:(NSString *)Number Ver:(NSString *)Ver
{
    SZLoginRequest *request = [[SZLoginRequest alloc] init];
    request.UserNo = UserNo;
    request.Password = Password;
    request.Number = Number;
    request.Ver = Ver;
    request.OsVersion = [NSString stringWithFormat:@"iOS%f",[[[UIDevice currentDevice] systemVersion] floatValue]];
    request.AppVersion = [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    return request;

}

@end
