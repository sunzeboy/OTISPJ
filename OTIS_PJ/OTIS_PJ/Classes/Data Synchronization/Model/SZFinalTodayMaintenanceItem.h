//
//  SZTodayMaintenance.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/10.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZFinalTodayMaintenanceItem : NSObject



/**
 * 电梯编号
 */
@property (nonatomic , copy) NSString *UnitNo;

/**
 * 保养报告类型
 */
@property (nonatomic , assign) NSInteger CardType;

//------------------------------------------------------------------------------------------------------------------------------------------------

/**
 * 工地编号
 */
@property (nonatomic , assign) NSInteger BuildingNo;

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
//------------------------------------------------------------------------------------------------------------------------------------------------

/**
 * 次数
 */
@property (nonatomic , assign) NSInteger Times;

/**
 * 年份
 */
@property (nonatomic , assign) NSInteger Year;

@end
