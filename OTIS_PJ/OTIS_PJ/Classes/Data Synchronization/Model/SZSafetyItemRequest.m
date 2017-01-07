//
//  SZSafetyItemRequest.m
//  OTIS_PJ
//
//  Created by sunze on 16/5/25.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZSafetyItemRequest.h"
#import "SZTable_System.h"

@implementation SZSafetyItemRequest

/**
 *  初始化请求
 */
+(instancetype)safetyItemRequest{
    SZSafetyItemRequest *request = [[SZSafetyItemRequest alloc] init];
    request.UserNo = [OTISConfig EmployeeID];
    request.Password = [OTISConfig userPW];
    //    TabSupervisor		－1
    request.SafeItemVer = [SZTable_System safetyItemVer];
    request.Ver = APIVersion;
    return request;


}
@end
