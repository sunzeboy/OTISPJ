//
//  SZV4.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/27.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZV4 : NSObject

/**
 *  电梯编号
 */
@property (nonatomic , copy) NSString *UnitNo;

/**
 *  路线号
 */
@property (nonatomic , copy) NSString *RouteNo;

/**
 * 
 */
@property (nonatomic , copy) NSString *CheckDate;

/**
 * 次数
 */
@property (nonatomic , assign) int Times;

/**
 *
 */
@property (nonatomic , assign) int Year;

/**
 * 当时计划的保养卡类型
 */
@property (nonatomic , assign) int CardType;

/**
 * 计划类型 0：正常 1：正常A计划 2:正常B计划 3：A计划 4：B计划
 */
@property (nonatomic , assign) int PlanType;

/**
 *
 */
@property (nonatomic , assign) int ScheduleID;



@end
