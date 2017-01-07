//
//  SZTable_UserSupervisor.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZTable_UserSupervisor : NSObject

/**
 *  存储到UserSupervisorDB
 *
 *  @param params
 */
+(void)storageUserSupervisorNo:(NSInteger)SupervisorNo;

/**
 *  根据请求参数去沙盒中加载缓存的UserSupervisor数据
 *
 *  @param params 请求参数
 */
+(NSArray *)supervisors;
+(NSString *)supervisorsStr;
/**
 *  查找当前EmployeeID关联的所有supervisor
 *
 *  @param params 请求参数
 */
+(NSInteger)supervisorNo;



@end
