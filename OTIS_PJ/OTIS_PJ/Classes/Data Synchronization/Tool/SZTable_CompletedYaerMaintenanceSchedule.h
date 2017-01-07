//
//  SZTable_CompletedYaerMaintenanceSchedule.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZTable_CompletedYaerMaintenanceSchedule : NSObject

/**
 *  存储到CompletedYaerMaintenanceScheduleDB
 *
 *  @param params
 */
+(void)storageCompletedYaerMaintenanceScheduleWithParams:(NSDictionary *)params;
/**
 *  根据请求参数去沙盒中加载缓存的CompletedYaerMaintenanceSchedule数据
 *
 *  @param params 请求参数
 */
+(NSArray *)readCompletedYaerMaintenanceScheduleWithParams:(NSDictionary *)params;

@end
