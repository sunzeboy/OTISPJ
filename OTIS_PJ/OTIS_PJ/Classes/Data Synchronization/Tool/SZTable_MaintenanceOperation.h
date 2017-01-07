//
//  SZTable_MaintenanceOperation.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZTable_MaintenanceOperation : NSObject

/**
 *  存储到MaintenanceOperationDB
 *
 *  @param params
 */
+(void)storageMaintenanceOperationWithParams:(NSDictionary *)params;
/**
 *  根据请求参数去沙盒中加载缓存的MaintenanceOperation数据
 *
 *  @param params 请求参数
 */
+(NSArray *)readMaintenanceOperationWithParams:(NSDictionary *)params;

@end
