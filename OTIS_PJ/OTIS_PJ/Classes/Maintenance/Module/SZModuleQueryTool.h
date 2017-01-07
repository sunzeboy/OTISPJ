//
//  SZModuleQueryTool.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/17.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SZFinalOutsidePlanMaintenanceItem,SZFinalMaintenanceUnitDetialItem,SZFinalMaintenanceUnitItem;


typedef NS_ENUM(NSInteger,OTISMaintenanceItemTimeType){
    OTISMaintenanceItemTimeTypeHalfMonth = 24,//半月
    OTISMaintenanceItemTimeTypeQuarterly = 4,//季度
    OTISMaintenanceItemTimeTypeHalfYear = 2,//半年
    OTISMaintenanceItemTimeTypeYear = 1//年度
};

@interface SZModuleQueryTool : NSObject




//------------------------------------------------------------------------------------------------------------------------------------------------

/**
 *  今日维保数据
 *
 *  @param params 请求参数
 */
+(NSArray *)queryTodayMaintenance;
/**
// *  今日维保数据(unitRegcode)
// *
// *  @param params 请求参数
// */
//+(SZFinalMaintenanceUnitItem *)queryTodayMaintenanceWithUnitRegcode:(NSArray *)unitRegcode;
//------------------------------------------------------------------------------------------------------------------------------------------------

/**
 *  维保电梯详细数据（二级页面）
 *
 *  @param params 请求参数
 */
+(SZFinalMaintenanceUnitDetialItem *)queryDetialMaintenanceWithScheduleID:(NSInteger)scheduleID;
+(SZFinalMaintenanceUnitDetialItem *)queryGongshiDetialMaintenanceWithUnitNo:(NSString *)unitNo;


// 判断维保是否完成
+(BOOL)isCompleatedAndUpload:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem;
/**
 *  计算电梯已经完成的保养项
 *
 *  @param params 请求参数
 */
+(NSInteger)queryCompletedMaintenanceWithUnitDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem;
/**
 *  计算保养项的和
 *
 *  @param params 请求参数
 */
+(NSInteger)queryAllMaintenanceWithUnitDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem;



//------------------------------------------------------------------------------------------------------------------------------------------------

/**
 *  未完成维保数据
 *  @param params 请求参数
 */
+(NSArray *)queryNotCompletedMaintenance;
/**
// *  未完成维保数据(unitRegcode)
// *  @param params 请求参数
// */
//+(SZFinalMaintenanceUnitItem *)queryNotCompletedMaintenanceWithUnitRegcode:(NSArray *)unitRegcode;
//------------------------------------------------------------------------------------------------------------------------------------------------

/**
 *  两周维保数据
 *
 *  @param params 请求参数
 */
+(NSArray *)queryTwoWeeksMaintenance;
///**
// *  两周维保数据(unitRegcode)
// *
// *  @param params 请求参数
// */
//+(SZFinalMaintenanceUnitItem *)queryTwoWeeksMaintenanceWithUnitRegcode:(NSArray *)unitRegcode;
//------------------------------------------------------------------------------------------------------------------------------------------------

/**
 *  计划外维保数据
 *
 *  @param params 请求参数
 */
+(NSArray *)queryOutsidePlanMaintenance;

/**
 *  计划外维保数据(所有电梯)
 *
 *  @param params 请求参数
 */
+(SZFinalMaintenanceUnitItem *)queryOutsideUnitesWithUnitRegcodes:(SZQRCodeProcotolitem *)item;
+(SZFinalMaintenanceUnitItem *)queryGongshiUnitesWithUnitRegcodes:(SZQRCodeProcotolitem *)item;
///**
// *  计划外维保数据(unitRegcode)
// *
// *  @param params 请求参数
// */
//+(SZFinalMaintenanceUnitItem *)queryOutsidePlanMaintenanceWithUnitRegcode:(NSArray *)unitRegcode;

/**
 *  计划外维保电梯（二级页面）
 */
+(NSArray *)queryOutsidePlanMaintenanceUnitsWithOutsidePlanMaintenanceItem:(SZFinalOutsidePlanMaintenanceItem *)item;
/**
 *  工时里的
 */
+(NSArray *)queryGongshiOutsidePlanMaintenanceUnitsWithOutsidePlanMaintenanceItem:(SZFinalOutsidePlanMaintenanceItem *)item;

//------------------------------------------------------------------------------------------------------------------------------------------------
/**
 *  计算出JHA控制器标题的名字
 */
+(NSArray *)quaryTitleNameWithCardType:(NSInteger)cardType;

/**
 *  计算出分组标题的名字
 */
+(NSArray *)quarySectionTitleNameWithJhaTypeId:(NSInteger)jhaTypeId;

/**
 *  保存JHA项目
 */
+(void)storageJHAItemsWithSelectedJHAArray:(NSMutableArray *)selectedArray andDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem andIsFixItem:(BOOL)isFixItem;
/**
 *  统计某部电梯保养计划的已经完成的JHA项目
 */
+(NSArray *)quaryCompetedJHAArrayWithDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem andIsFixItem:(BOOL)isFixItem;
//------------------------------------------------------------------------------------------------------------------------------------------------
/**
 *  查询保养项目半月
 */
+(NSArray *)quaryMaintenanceItemWithDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem andTimeType:(OTISMaintenanceItemTimeType)type;
+(NSMutableDictionary *)quaryMaintenanceItemFixWithDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem;
/**
 *  查询保养项目
 */
+(NSArray *)quaryOtherMaintenanceItemWithDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem andTimeType:(OTISMaintenanceItemTimeType)type;
/**
 *  查询保养项目年度
 */
+(NSArray *)quaryOtherMaintenanceItemWithDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem andShowYear:(BOOL)ret;
/**
 *  保存保养项目t_REPORT_ITEM_COMPLETE_STATE
 */
+(void)storageCompletedMaintenanceItemWithArray:(NSMutableArray *)selectedArray andDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem;

/**
 *  统计已经完成的保养项目
 */
+(NSMutableDictionary *)quaryCompletedMaintenanceItemWithDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem;
+(NSArray *)quaryCompletedMaintenancePreViewItemWithDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem;
/**
 *  统计已经完成的保养项目
 */
+(NSArray *)quaryCompletedMaintenanceWithDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem;
//------------------------------------------------------------------------------------------------------------------------------------------------

/**
 *  本公司维保电梯数据
 *
 *  @param params 请求参数
 */
+(NSArray *)queryTheCompanyMaintenanceElevators;

/**
 *  本公司维保电梯数据（二级页面）
 */
+(NSArray *)queryTheCompanyMaintenanceElevatorsWithOutsidePlanMaintenanceItem:(SZFinalOutsidePlanMaintenanceItem *)item;
//------------------------------------------------------------------------------------------------------------------------------------------------

/**
 *  年检查询
 */
+(NSArray *)queryYearCheckItem;
/**
 *  年检查询（二级页面）
 */
+(SZFinalMaintenanceUnitDetialItem *)queryYearCheckDetialItemWithUnitNo:(NSString *)unitNo;

//------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------

/**
 *  客户签字列表
 */
+(NSArray *)querySignList;

//------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------
/**
 *  工时里面工地列表
 *
 *  @param params 请求参数
 */
+(NSArray *)queryTheGongShiGongdiList;

//------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------


/**
 *  维保上传
 *
 *  @param params 请求参数
 */
+(NSArray *)queryMaintenanceUploadData;


/**
 *  维修换件报告上传
 *
 *  @param params 请求参数
 */
+(NSArray *)queryFixUploadData;

/**
 *  维修换件报告上传
 *
 *  @param params 请求参数
 */
+(NSArray *)queryUploadImageData;

/**
 * 签字数据上传
 *
 *  @param params 请求参数
 */
+(NSArray *)queryUploadSignature;

/**
 * 年检记录数据上传
 *
 *  @param params 请求参数
 */
+(NSArray *)queryYearlyCheckUpload;


/**
 * 全工时数据数据上传
 *
 *  @param params 请求参数
 */
+(NSMutableDictionary *)queryFullLaborHoursUpload;

@end
