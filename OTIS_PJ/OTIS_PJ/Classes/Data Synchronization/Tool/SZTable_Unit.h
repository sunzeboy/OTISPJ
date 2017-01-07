//
//  SZTable_Unit.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/28.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZDownload_UnitsResponse.h"
#import "SZFinalMaintenanceUnitItem.h"


@interface SZTable_Unit : NSObject

/**
 *  存储到电梯DB
 */
+(void)storageUnits:(NSArray *)units;
///**
// *  根据请求参数去沙盒中加载缓存的电梯数据
// *
// *  @param params 请求参数
// */
//+(NSArray *)readTabUnitWithParams:(NSDictionary *)params;
//
///**
// *  维保查询电梯
// */
//+(SZFinalMaintenanceUnitItem *)unitWithUnitNo:(NSString * )UnitNo;
//
///**
// *  计划外查询电梯
// */
//+(SZFinalMaintenanceUnitItem *)unitWithBuildingNo:(NSInteger )BuildingNo;
//
///**
// *  计划外查询所有电梯
// */
//+(NSArray *)unitsWithBuildingNo:(NSInteger )BuildingNo;
//
///**
// *  根据UnitNo查找BuildingNo
// */
//+(NSInteger)buildingNosWithUnitNo:(NSString *)unitNo;

+(void)updateUnScanReasons:(NSArray *)reasons;

@end
