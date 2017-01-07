//
//  SZDownload_UnScanedReasonRequest.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/27.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZDownload_UnScanedReasonRequest.h"

@implementation SZDownload_UnScanedReasonRequest

+(instancetype)unScanedReasonRequest{

    SZDownload_UnScanedReasonRequest *request = [[SZDownload_UnScanedReasonRequest alloc] init];
    request.UserNo = [OTISConfig EmployeeID];
    request.Password = [OTISConfig userPW];
    //    TabSys		0
    request.Ver = APIVersion;
    return request;
}

@end
