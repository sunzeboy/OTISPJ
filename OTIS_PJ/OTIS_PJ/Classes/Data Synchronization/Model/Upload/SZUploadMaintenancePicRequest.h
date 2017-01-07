//
//  SZUploadMaintenancePicRequest.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZUploadMaintenancePicRequest : NSObject


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
 *  0：保养JHA  1：保养  2：维修换件JHA  3：维修换件 4：签字
 */
@property (nonatomic , copy) NSString * PicType;
/**
 * 图片名称
 */
@property (nonatomic , copy) NSString * PicName;
/**
 * 图片生成时间的ticks（长整形，可以为空）
 */
@property (nonatomic , copy) NSString *Date;

/**
 * 此次保养人EmployeeID(如：8018)
 */
@property (nonatomic , copy) NSString *Checker;


@property (nonatomic , strong) UIImage *image;


@end
