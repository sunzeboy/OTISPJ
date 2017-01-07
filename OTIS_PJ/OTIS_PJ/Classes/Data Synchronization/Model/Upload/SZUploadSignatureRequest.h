//
//  SZUploadSignatureRequest.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZComment : NSObject

@property (nonatomic , assign) NSInteger ScheduleID;

@property (nonatomic , copy) NSString *Comment  ;

@end

@interface SZRepair : NSObject

@property (nonatomic , assign) NSInteger ScheduleID;

@property (nonatomic , copy) NSString *IsRepair ;

@end

@interface SZReplace : NSObject

@property (nonatomic , assign) NSInteger ScheduleID;

@property (nonatomic , copy) NSString *IsReplace  ;
@end


@interface SZQuestion : NSObject

@property (nonatomic , assign) NSInteger ScheduleID;

@property (nonatomic , copy) NSString *Question;

@end



@interface SZUploadSignatureRequest : NSObject

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
 * 计划ID
 */
@property (nonatomic , copy) NSString * SignID;
/**
 */
@property (nonatomic , copy) NSString * Date;
/**
 */
@property (nonatomic , copy) NSString * Question;
/**
 */
@property (nonatomic , copy) NSString * IsReplace;
/**
 */
@property (nonatomic , copy) NSString * IsRepair;
/**
 */
@property (nonatomic , copy) NSString * Attitude;
/**
 */
@property (nonatomic , copy) NSString * Quality;
/**
 */
@property (nonatomic , copy) NSString * Customer;
/**
 */
@property (nonatomic , copy) NSString * IsEmail;
/**
 */
@property (nonatomic , copy) NSString * EmailAddr;
/**
 */
@property (nonatomic , copy) NSString * HasSignature;
/**
 */
@property (nonatomic , copy) NSString * Comment;
/**
 */
@property (nonatomic , copy) NSString * FileName;
/**
 */
@property (nonatomic , copy) NSString * IsOK;





@end
