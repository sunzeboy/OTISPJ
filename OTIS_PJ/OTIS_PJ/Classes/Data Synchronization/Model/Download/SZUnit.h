//
//  SZUnit.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/27.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger,OTISMaintenanceReportType){
    OTISMaintenanceReportType1 = 1,//1	乘客电梯和载货电梯系列-专业版
    OTISMaintenanceReportType2,//2	乘客电梯和载货电梯系列-标准版
    OTISMaintenanceReportType3,//3	乘客电梯和载货电梯系列-OSS合同
    OTISMaintenanceReportType4,//4   自动扶梯和自动人行道系列-专业版
    OTISMaintenanceReportType5,//5	自动扶梯和自动人行道系列-标准版
    OTISMaintenanceReportType6,//6	自动扶梯和自动人行道系列-OSS合同
    OTISMaintenanceReportType7,//7	杂物电梯系列-专业版
    OTISMaintenanceReportType8,//8	杂物电梯系列-标准版
    OTISMaintenanceReportType9,//9	杂物电梯系列-OSS合同
    OTISMaintenanceReportType10,//10	液压电梯系列-专业版
    OTISMaintenanceReportType11,//11	液压电梯系列-标准版
    OTISMaintenanceReportType12,//12	液压电梯系列-OSS合同
    OTISMaintenanceReportType13,//13	Skyway电梯系列
    OTISMaintenanceReportType14,//14	Skyway电梯系列-OSS合同
    OTISMaintenanceReportType15,//15	HOME LIF家用电梯电梯系列
    OTISMaintenanceReportType16//16	HOME LIF家用电梯电梯系列-OSS合同
    
};





@interface SZUnit : NSObject

/**
 * 电梯编号
 */
@property (nonatomic , copy) NSString *UnitNo;

/**
 * 路线名
 */
@property (nonatomic , copy) NSString *Route;

/**
 * 保养报告类型
 */
@property (nonatomic , assign) OTISMaintenanceReportType CardType;

/**
 * 电梯型号名称
 */
@property (nonatomic , copy) NSString *ModelType;

/**
 * 负责人电话
 */
@property (nonatomic , copy) NSString *Tel;

/**
 * 0-Eight Weekly, 1-Fortnightly,  2-Half Yearly, 3-Monthly, 4-Quarterly, 5-Six Weekly, 6-Three Monthly, 7-Three Weekly, 8-Weekly, 9-Yearly，10-Four Monthly
 */
@property (nonatomic , assign) NSInteger Examliterval;

/**
 * 工地编号
 */
@property (nonatomic , assign) NSInteger BuildingNo;

/**
 * 路线号
 */
@property (nonatomic , assign) NSInteger RouteNo;

/**
 * 合同号，供电梯模糊查询用
 */
@property (nonatomic , copy) NSString *ContractNo;

/**
 * 负责人
 */
@property (nonatomic , copy) NSString *Owner;
/**
 * 客户Email邮箱地址
 */
@property (nonatomic , copy) NSString *Email;

/**
 * 计划年检日期
 */
@property (nonatomic , assign) NSInteger YCPDate;

/**
 *
 */
@property (nonatomic , copy) NSString *CurrentStatus;

/**
 *
 */
@property (nonatomic , assign) NSInteger IsQRUploaded;

/**
 * 电梯二维码
 */
@property (nonatomic , copy) NSString *UnitRegcode;


@property (nonatomic , copy) NSString *UnitStatus;

@property (nonatomic , copy) NSString *UnitName;


@end
