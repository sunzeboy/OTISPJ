//
//  SZTable_Building.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZTable_Building : NSObject

/**
 *  存储到BuildingDB
 *
 *  @param params
 */
+(void)storageBuildings:(NSArray *)buildings;
///**
// *  根据请求参数去沙盒中加载缓存的Building数据
// *
// *  @param params 请求参数
// */
//+(NSArray *)readBuildingWithParams:(NSDictionary *)params;
//
///**
// *  计划外维保数据
// *
// *  @param params 请求参数
// */
//+(NSArray *)outsidePlanMaintenanceData;
//+(NSArray *)outsidePlanMaintenance;


@end
