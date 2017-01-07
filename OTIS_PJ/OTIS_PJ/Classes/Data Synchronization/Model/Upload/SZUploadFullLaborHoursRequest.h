//
//  SZUploadFullLaborHoursRequest.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZNotThisCompanyHours : NSObject

@property (nonatomic , copy) NSString * GroupID;

@property (nonatomic, strong) NSArray * HourList;

@property (nonatomic , assign) NSInteger SaveHourDate;

@property (nonatomic , copy) NSString * CustomerInfo;

@property (nonatomic , copy) NSString * ContractNo;

@property (nonatomic , copy) NSString * GenerateDate;

@property (nonatomic , copy) NSString * Checker;

@property (nonatomic , copy) NSString * Result;

@property (nonatomic, strong) NSArray * Operate;

@end


@interface SZUnproductHours : NSObject

@property (nonatomic , copy) NSString * GroupID;

@property (nonatomic, strong) NSArray * HourList;

@property (nonatomic , assign) NSInteger SaveHourDate;

@property (nonatomic , copy) NSString * Remark;

@property (nonatomic , copy) NSString * GenerateDate;

@property (nonatomic , copy) NSString * Checker;

@property (nonatomic , copy) NSString * Result;

@end

@interface SZProductHours : NSObject

@property (nonatomic , copy) NSString * GroupID;

@property (nonatomic, strong) NSArray * HourList;

@property (nonatomic , copy) NSString * UnitNo;

@property (nonatomic , assign) NSInteger SaveHourDate;

@property (nonatomic, strong) NSArray * Operate;


@property (nonatomic , copy) NSString * GenerateDate;

@property (nonatomic , copy) NSString * QRCode;

@property (nonatomic , copy) NSString * Checker;

@property (nonatomic , copy) NSString * Result;


@end


@interface SZUploadFullLaborHoursRequest : NSObject

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
@property (nonatomic , copy) NSString * ProductHours;
/**
 */
@property (nonatomic , copy) NSString * UnProductHours;
/**
 */
@property (nonatomic , copy) NSString * NotThisCompanyHours;
/**
 */
@property (nonatomic , copy) NSString * PhoneVersion;
/**
 */
@property (nonatomic , copy) NSString * IsOK;

//--------------附加

@property (nonatomic , copy) NSString * dateTime;


@end
