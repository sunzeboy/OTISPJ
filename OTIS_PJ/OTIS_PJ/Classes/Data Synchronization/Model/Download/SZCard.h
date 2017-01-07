//
//  SZCard.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/27.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(int,OTISMaintenanceCardType){
    OTISMaintenanceReportTypeYear      = 0,//0：年度保养，可以再任何次数保养但每年仅限一次
    OTISMaintenanceReportTypePerYear   = 1,//1：一年
    OTISMaintenanceReportTypeHalfYear  = 2,//2：半年
    OTISMaintenanceReportTypeQuarter   = 4,//4：季度
    OTISMaintenanceReportTypeMonthly   = 12,//12:月度
    OTISMaintenanceReportTypeHalfMonth = 24//24:半月
    
};



@interface SZCard : NSObject


/**
 * 项目编号
 */
@property (nonatomic , copy) NSString *ItemCode;

/**
 * 维修项目名
 */
@property (nonatomic , copy) NSString *ItemName;

/**
 * 维修项目描述
 */
@property (nonatomic , copy) NSString *Description;

/**
 *
 */
@property (nonatomic , assign) int CardType;

/**
 * 项目类型
 */
@property (nonatomic , assign) OTISMaintenanceCardType Type;

/**
 *
 */
@property (nonatomic , assign) int IsStandard;


@end
