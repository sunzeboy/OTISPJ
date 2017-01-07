//
//  SZTable_MaintenanceItems.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZTable_MaintenanceItems : NSObject

/**
 *  存储到MaintenanceItemsDB
 *
 *  @param params
 */
+(void)storageMaintenanceItemsWithParams:(NSDictionary *)params;
/**
 *  根据请求参数去沙盒中加载缓存的MaintenanceItems数据
 *
 *  @param params 请求参数
 */
+(NSArray *)readMaintenanceItemsWithParams:(NSDictionary *)params;

@end
