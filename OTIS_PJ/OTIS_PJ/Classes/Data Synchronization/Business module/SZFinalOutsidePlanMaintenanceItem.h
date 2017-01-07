//
//  SZFinalOutsidePlanMaintenanceItem.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/11.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZFinalOutsidePlanMaintenanceItem : NSObject

/**
 * 工地编号
 */
@property (nonatomic , copy) NSString *BuildingNo;
/**
 * 工地名
 */
@property (nonatomic , copy) NSString *BuildingName;

/**
 * 工地路线
 */
@property (nonatomic , copy) NSString *Route;

/**
 * 工地地址
 */
@property (nonatomic , copy) NSString * BuildingAddr;

/**
 * 电梯数量
 */
@property (nonatomic , copy) NSString * unitCount;

@property (nonatomic , copy) NSString * RouteNo;

@end
