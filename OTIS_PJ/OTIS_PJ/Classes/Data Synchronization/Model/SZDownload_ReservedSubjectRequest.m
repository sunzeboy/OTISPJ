//
//  SZDownload_ReservedSubjectRequest.m
//  OTIS_PJ
//
//  Created by sunze on 16/5/9.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZDownload_ReservedSubjectRequest.h"

@implementation SZDownload_ReservedSubjectRequest


/**
 *  初始化请求
 */
+(instancetype)reservedSubjectRequest{

    SZDownload_ReservedSubjectRequest *request = [[SZDownload_ReservedSubjectRequest alloc] init];
    request.UserNo = [OTISConfig EmployeeID];
    request.Password = [OTISConfig userPW];
    request.Ver = APIVersion;
    
    return request;

}

@end
