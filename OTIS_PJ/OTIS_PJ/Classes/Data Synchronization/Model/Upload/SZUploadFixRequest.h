//
//  SZUploadFixRequest.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>


//@interface SZFixItem : NSObject
//
///**
// * 用户密码
// */
//@property (nonatomic , copy) NSString *Code;
///**
// * 保养完成情况(State状态)
// 0：正常项目
// 1：需调整或更换部件的项目，追踪电梯
// 2：已完成清洁、润滑和更换的项目
// 3：无此项目
// 4：保养中完成换件
// 99：未完成
// 
// */
//@property (nonatomic , assign) NSInteger State;
//
//@end
//
////------------------------------------------------------------------------------------------------------------------------------------------------
//
//
//@interface SZFixJHAItem : NSObject
//
///**
// * JHA字符串。
// */
//@property (nonatomic , copy) NSString *JHACode;
//
//@end





@interface SZUploadFixRequest : NSObject

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
@property (nonatomic , copy) NSString * ScheduleID;

/**
 * 保养日期时间的ticks（长整形，可以为空）（如果已经有此对应记录，则不生成重复记录
 */
@property (nonatomic , copy) NSString * ItemDate;
/**
 * JHA日期时间的ticks（长整形，可以为空）（如果已经有此对应记录，则不生成重复记
 */
@property (nonatomic , copy) NSString * JhaDate;
/**
 * 此次保养人EmployeeID(如：8018)
 */
@property (nonatomic , copy) NSString *FixMan;
/**
 * 此次保养人EmployeeID(如：8018)
 */
@property (nonatomic , copy) NSString *ItemPhoto;

@property (nonatomic , copy) NSString *JHAPhoto;

/**
 *保养项目内容的json字符串
 */
@property (nonatomic, copy) NSString * Fix;

/**
 *JHA字符串。
 */
@property (nonatomic, copy) NSString * JHA;
/**
 * 是否中断 0：否 1：是
 */
@property (nonatomic , copy) NSString *IsOK;



@end
