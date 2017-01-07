//
//  SZTable_LaborHours.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/3.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SZFinalMaintenanceUnitDetialItem.h"
#import "SZCheckLookModel.h"


@interface SZLaborHoursItem : NSObject
/**
 *  工时类型；召修，加班召修。。。有薪休假；数字代表什么；区分工时类型，见表TabLaborType
 */
@property (nonatomic , assign) int LaborTypeId;
/**
 *  1倍正常工时的时间，单位小时
 */
@property (nonatomic , assign) float Hour1Rate;
@property (nonatomic,  copy)   NSString *Hour1RateStr;
@property (nonatomic,  copy)   NSString *Hour1Str;
@property (nonatomic,  copy)   NSString *Hour1FormatStr;

/**
 *  1.5倍正常工时的时间，单位小时
 */
@property (nonatomic , assign) float Hour15Rate;
@property (nonatomic,  copy)   NSString *Hour15RateStr;
@property (nonatomic,  copy)   NSString *Hour15Str;
@property (nonatomic,  copy)   NSString *Hour15FormatStr;


/**
 *  2倍正常工时的时间，单位小时
 */
@property (nonatomic , assign) float Hour2Rate;
@property (nonatomic,  copy)   NSString *Hour2RateStr;
@property (nonatomic,  copy)   NSString *Hour2Str;
@property (nonatomic,  copy)   NSString *Hour2FormatStr;

/**
  *  3倍正常工时的时间，单位小时
  */
@property (nonatomic , assign) float Hour3Rate;
@property (nonatomic,  copy)   NSString *Hour3RateStr;
@property (nonatomic,  copy)   NSString *Hour3Str;
@property (nonatomic,  copy)   NSString *Hour3FormatStr;


/**
 *  工时属性（0:保养 1:生产性工时 2：非生产性工时  4:非本公司生产性工时）
 */
@property (nonatomic,  assign) int Property;
/**
 *  "工时产生日期（格式:yyyy/MM/dd）
 工时填写-召修页面中填写的工时，能够填写今天和昨天的日期"
 */
@property (nonatomic,  copy)   NSString *GenerateDate;
/**
 *  创建记录时间（格式:yyyy/MM/dd HH:mm），工时记录的创建时间
 */
@property (nonatomic,  copy)   NSString *CreateTime;
@property (nonatomic,  copy)   NSString *CreateTimeStr;

@property (nonatomic,  copy)   NSString *CreateDate;
/**
 *  更新记录的时间（格式:yyyy/MM/dd HH:mm），修改工时的时候
 */
@property (nonatomic,  copy)   NSString *UpdateTime;
@property (nonatomic,  copy)   NSString *CustomerName;
@property (nonatomic,  copy)   NSString *ContactNo;
@property (nonatomic,  copy)   NSString *Remark;
@property (nonatomic,  copy)   NSString *PUINo;

@property (nonatomic , assign) int GroupID;

//--------------附加

@property (nonatomic,  copy)   NSString *UnitNo;

@property (nonatomic,  copy)   NSString *LaborName;

@property (nonatomic , assign) float  gongshi;


@end


@interface SZTable_LaborHours : NSObject



/**
 *  保存t_LaborHours（工时）
 */
+(int)storageLaborHoursItems:(NSMutableArray *)items withScheduleID:(NSInteger)scheduleID andUnitNo:(NSString *)unitNo andOpration:(SZFinalMaintenanceUnitDetialItem *)item andGenerateDate:(NSString *)generateDate;
/**
 *  保存t_LaborHours（工时）
 */
+(void)storageLaborHoursItems:(NSMutableArray *)items withCONTACT_NO:(NSString *)contact_No andCustomerName:(NSString *)customerName andGenerateDate:(NSString *)generateDate;
/**
 *  工时分摊
 */
+(void)storageLaborHoursItems:(NSMutableArray *)items withUnits:(NSArray *)units andGenerateDate:(NSString *)generateDate;
/**
 *  更新t_LaborHours（工时）
 */
+(void)updateLaborHoursItems:(NSMutableArray *)items withScheduleID:(NSInteger)scheduleID andUnitNo:(NSString *)unitNo;
+(void)updateLaborHoursItemsWithCheckLookModel:(SZCheckLookModel *)model andDeleteArray:(NSMutableArray *)deleteArray andDate:(NSString *)dateStr;
/**
 *  删除非生产性工时
 */
+(void)deleteFeiProductiveWithCreateTime:(NSString *)createTime;
/**
 *  保存t_LaborHours（非生产性工时）
 */
+(void)storageFeiShengchanLaborHoursItems:(SZLaborHoursItem *)item;
+(void)updateFeiShengchanLaborHoursItems:(SZLaborHoursItem *)item;
/**
 *  查找所有时间的工时
 */
+(NSArray *)quaryAllDateLaborHours;
/**
 *  判断当天是否有填过工时
 */
+(BOOL)isLaborHoursed;
/**
 *  查找当前时间下所有电梯
 */
+(NSArray *)quaryAllUnitsWithDate:(NSString *)date;
/**
 *  查找指定电梯的所有工时
 */
+(NSArray *)quaryWithScheduleID:(int )scheduleID andCreateDate:(NSString *)createDate;
/**
 *  查找指定合同号的所有工时
 */
+(NSArray *)quaryWithContactNo:(NSString *)contactNo andCreateDate:(NSString *)createDate;
/**
 *  计算生产性工时和非生产性工时总时间
 */
+(float)quaryTimesWithDate:(NSString *)date;

+(float)quaryTotlaTimesWithDate:(NSString *)date;

/**
 *  计算非生产性工时总时间
 */
+(float)quaryNonProductiveTimesWithDate:(NSString *)date;
/**
 *  查找指定电梯的维保工时
 */
+(NSArray *)quaryMaintenanceWithScheduleID:(int )scheduleID;


/**
 *  查找所有时间的工时
 */
+(NSArray *)quaryAllDateLaborHours222;


+(SZCheckLookModel *)quaryLaborHoursItemsWithCheckLookModel:(SZCheckLookModel *)model;

+(NSString *)queryDatetime;

+(BOOL)clearData;

/**
 * 全工时数据数据上传(是否有数据)
 *
 *  @param params 请求参数
 */
+(BOOL)queryhasHoursUploadData;

@end
