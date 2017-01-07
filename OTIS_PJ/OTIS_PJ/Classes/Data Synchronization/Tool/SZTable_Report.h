//
//  SZTable_Report.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/25.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZFinalMaintenanceUnitDetialItem.h"
#import "SZReport.h"
#import "SZMaintenanceCheckItem.h"

@interface SZAdjustment : NSObject
@property (nonatomic,  copy)   NSString *AdjustmentComment;
@property (nonatomic,  copy)   NSString *AdjustmentType;

@end


@interface SZReportQuestionItem : NSObject

@property (nonatomic , assign) BOOL isReplace;

@property (nonatomic , assign) BOOL isRepair;

@property (nonatomic,  copy)   NSString *Question;

@property (nonatomic , assign) int ScheduleId;

@property (nonatomic,  copy)   NSString *EmployeeId;

@end


@interface SZMaintenanceRemarks : NSObject

@property (nonatomic , assign) BOOL isReplace;

@property (nonatomic , assign) BOOL isRepair;

@property (nonatomic,  copy)   NSString *Question;

+(instancetype)remarkWithQuestion:(NSString *)question isrepiar:(BOOL)isrepiar isreplace:(BOOL)isresplace;

@end

@interface SZTable_Report : NSObject

+(void)updateCheckItemWithDetialItemForFix:(NSMutableArray *)datas andCheckItem:(SZFinalMaintenanceUnitDetialItem *)item1 isModify:(BOOL)isModify;
/**
 *  保存Report（JHA）
 */
+(void)storageJHAWithDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem andinputMode:(int)inputMode;

/**
 *  chaxunReport（Adjustment）
 */
+(SZAdjustment *)quarywithDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem;
/**
 *  保存Report
 */
+(void)storageCheckItemWithDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem andLastStatus:(int)lastStatus andRemark:(SZMaintenanceRemarks *)remark;
/**
 *  保养项目完成，更新report数据和状态
 */
+(void)updateReportState:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem;
/**
 *  保存Report（ItemPhoto）
 */
+(void)storageItemPhotoWithDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem;

/**
 *  保存Report（Adjustment）
 */
+(void)storageWithAdjustmentType:(NSString *)adjustmentType adjustmentComment:(NSString *)adjustmentComment andDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem;


/**
 *  保存Report（IsUploaded）
 */
+(void)storageIsUploaded:(BOOL )isUploaded withScheduleId:(int)scheduleId;
+(BOOL)quaryIsUploadedWithScheduleId:(int)scheduleId;
/**
 *  保存Report（LastStatus）
 */
+(void)storageWithLastStatus:(int)lastStatus andDetialItem:(SZFinalMaintenanceUnitDetialItem *)unitDetialItem;

// 更新保养状态
//+(void)updateLastStatusOnTabReport:(int)lastStatus andScheduleID:(NSInteger)scheduleID;
//------------------------------------------------------------------------------------------------------------------------------------------------

/**
 *  保存Report（未完成／同事保养操作）
 */
+(void)storageWithSZReportDowndload:(SZReport *)report;
/**
 *  保存Report（未完成／同事保养操作）
 */
+(void)storageWithSZReport:(SZReportQuestionItem *)report;
/**
 *  OTISRemark
 *
 *  @param scheduleID
 *
 *  @return
 */
+(SZMaintenanceRemarks *)quaryRemarkWithScheduleID:(int)scheduleID;

// 正常维保有更新，则将上传状态更改为
+(void)updateCheckItemWithDetialItem2:(NSMutableArray *)datas andCheckItem:(SZFinalMaintenanceUnitDetialItem *)item1 isModify:(BOOL)isModify;


@end
