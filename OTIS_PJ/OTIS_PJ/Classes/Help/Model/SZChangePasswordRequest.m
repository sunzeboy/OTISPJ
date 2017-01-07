//
//  SZChangePasswordRequest.m
//  OTIS_PJ
//
//  Created by zhangyang on 16/6/13.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZChangePasswordRequest.h"

@implementation SZChangePasswordRequest

-(instancetype)requestWithUserNo:(NSString *)UserNo NewPassword:(NSString *)NewPassword Ver:(NSString *)Ver
{
    SZChangePasswordRequest *request = [[SZChangePasswordRequest alloc] init];
    request.UserNo = UserNo;
    request.Password = NewPassword;
    request.Ver = Ver;
    return request;
    
}

@end
