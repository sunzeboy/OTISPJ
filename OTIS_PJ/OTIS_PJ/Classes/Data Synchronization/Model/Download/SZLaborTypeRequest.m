//
//  SZLaborTypeRequest.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/15.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZLaborTypeRequest.h"
#import "SZTable_System.h"

@implementation SZLaborTypeRequest

+(instancetype)laborTypeRequest{

    SZLaborTypeRequest *request = [[SZLaborTypeRequest alloc] init];
    request.UserNo = [OTISConfig EmployeeID];
    request.Password = [OTISConfig userPW];
    //    TabSupervisor		－1
    request.LaborItemVer = [SZTable_System laborItemVer];
    request.Ver = APIVersion;
    return request;

}

@end
