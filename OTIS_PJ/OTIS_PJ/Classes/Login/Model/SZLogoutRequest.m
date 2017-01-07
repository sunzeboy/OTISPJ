//
//  SZLogoutRequest.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/26.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZLogoutRequest.h"



@implementation SZLogoutRequest

+(instancetype)requestWithUserNo:(NSString *)userNo password:(NSString *)password andVer:(NSString *)ver
{
    SZLogoutRequest *request = [[SZLogoutRequest alloc] init];
    request.UserNo = userNo ;
    request.Password = password;
    request.Ver = ver;
    return request;
}

@end
