//
//  SZTable_QRCode.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZFinalMaintenanceUnitDetialItem.h"


@interface SZTable_QRCode : NSObject

 
/**
 *  根据请求参数去沙盒中加载缓存的QRCode数据
 *
 *  @param params 请求参数
 */
+(NSArray *)readWorkingHoursWithParams:(NSDictionary *)params;



/**
 *  存储到QRCodeDB(从维保进入)
 *
 *  @param params
 */
+(void)storageWeiBaoWorkingHoursWithParams:(SZFinalMaintenanceUnitDetialItem *)item andGroupID:(int)groupID withProperty:(int)property;

+(BOOL)hasScandWithUnitNo:(NSString *)unitNo;

// 在维保的时候，判断是否需要显示扫描二维码的对话框
// return YES 显示 ；NO 不显示
+(BOOL)isShowQRSelectDlg:(BOOL)isFixItem andScheduleID:(int)ScheduleID;

// 在QR code表中获取已经存在的二维码信息
+(NSString*)selectQRCode:(SZFinalMaintenanceUnitDetialItem *)item;
@end
