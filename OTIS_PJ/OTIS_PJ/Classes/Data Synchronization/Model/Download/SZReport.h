//
//  SZReport.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/5.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SZFix : NSObject
/**
 * 计划ID
 */
@property (nonatomic , assign) int ScheduleID;

/**
 * 是否完成
 */
@property (nonatomic , assign) int IsComplete;

/**
 * 保养操作数组
 */
@property (nonatomic , strong) NSArray *Items;

@end



@interface SZReport : NSObject

/**
 * 计划ID
 */
@property (nonatomic , assign) int ScheduleID;

/**
 * 是否完成
 */
@property (nonatomic , assign) int IsComplete;
/**
 * 保养操作数组
 */
@property (nonatomic , strong) NSArray *Items;

/**
 * 同事编号
 */
@property (nonatomic , copy) NSString *User;
/**
 * 需要改造
 */
@property (nonatomic , assign) int IsRepair;
/**
 * 需要更换
 */
@property (nonatomic , assign) int IsReplace;
/**
 * Question
 */
@property (nonatomic , copy) NSString *Question;


@end
