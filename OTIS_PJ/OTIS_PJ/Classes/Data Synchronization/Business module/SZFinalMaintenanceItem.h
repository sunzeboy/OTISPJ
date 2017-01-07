//
//  SZTodayMaintenance.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/10.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZFinalMaintenanceItem : NSObject


//------------------------------------------------------------------------------------------------------------------------------------------------

/**
 * 电梯编号
 */
@property (nonatomic , copy) NSString *UnitNo;

/**
 * 保养报告类型（电梯图标类型）
 */
@property (nonatomic , assign) NSInteger CardType;
@property (nonatomic , copy) NSString *CardTypeStr;

//--------------附加
/**
 * 本次保养未完成多少项
 */
@property (nonatomic , copy) NSString *notCompletedsCount;
/**
 * 电梯二维码
 */
@property (nonatomic , copy) NSString *UnitRegcode;


//------------------------------------------------------------------------------------------------------------------------------------------------


/**
 * 工地名
 */
@property (nonatomic , copy) NSString *BuildingName;

/**
 * 工地路线
 */
@property (nonatomic , copy) NSString *Route;



//--------------附加
/**
 * 工地地址
 */
@property (nonatomic , copy) NSString * BuildingAddr;

/**
 * 工地编号
 */
@property (nonatomic , assign) NSInteger BuildingNo;
@property (nonatomic , copy) NSString *BuildingNoStr;




//------------------------------------------------------------------------------------------------------------------------------------------------

/**
 * 次数
 */
@property (nonatomic , assign) NSInteger Times;
@property (nonatomic , copy) NSString *TimesStr;
/**
 * 计划保养日期
 */
@property (nonatomic , assign) NSInteger CheckDate;
@property (nonatomic , copy) NSString *CheckDateStr;

//--------------附加
/**
 * 年份
 */
@property (nonatomic , assign) NSInteger Year;

//------------------------------------------------------------------------------------------------------------------------------------------------







@end
