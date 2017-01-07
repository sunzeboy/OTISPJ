//
//  SZUploadLogRequest.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZUploadLogRequest : NSObject

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
@property (nonatomic , copy) NSString *Number;
/**
 * UnitNo
 */
@property (nonatomic , copy) NSString * Ver;
/**
 */
@property (nonatomic , copy) NSString * Message;
/**
 */
@property (nonatomic , copy) NSString * Type;
/**
 */
@property (nonatomic , copy) NSString * Date;
/**
 */
@property (nonatomic , copy) NSString * User;
/**
 */
@property (nonatomic , copy) NSString * IsOK;


@end
