//
//  SZUploadYearlyCheckRequest.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZUploadYearlyCheckRequest : NSObject

/**
 * 登录终端的员工EmployeeID
 */
@property (nonatomic , copy) NSString *UserNo;
/**
 * 用户密码
 */
@property (nonatomic , copy) NSString *Password;
/**
 * 接口版本号。如：LBS_V8.0.0
 */
@property (nonatomic , copy) NSString *Ver;
/**
 * UnitNo
 */
@property (nonatomic , copy) NSString * UnitNo;
/**
 */
@property (nonatomic , copy) NSString * PDate;
/**
 */
@property (nonatomic , copy) NSString * ADate;
/**
 */
@property (nonatomic , copy) NSString * IsOK;

@end
