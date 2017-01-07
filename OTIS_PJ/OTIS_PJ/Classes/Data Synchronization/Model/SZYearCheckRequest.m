//
//  SZYearCheckRequest.m
//  OTIS_PJ
//
//  Created by sunze on 16/5/24.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZYearCheckRequest.h"
#import "SZTable_Route.h"

@implementation SZYearCheckRequest

/**
 *  初始化请求
 */
+(instancetype)yearCheckRequest{

    SZYearCheckRequest *request = [[SZYearCheckRequest alloc] init];
    request.UserNo = [OTISConfig EmployeeID];
    request.Password = [OTISConfig userPW];
    //    TabSupervisor		－1
    request.TimeStamp = [SZTable_Route yCheckDate];
    request.Ver = APIVersion;
    return request;


}

@end
