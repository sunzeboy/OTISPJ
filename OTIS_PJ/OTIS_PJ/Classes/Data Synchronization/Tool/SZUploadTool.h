//
//  SZUploadTool.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/24.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZUploadMaintenancemRequest.h"




@interface SZUploadTool : NSObject

/**
 *  维保上传
 */
+(void)uploadMaintenanceSuccess:(void(^)(NSString *))success failure:(void(^)(NSError *error))failure done:(void(^)(NSString *))done;

/**
 *  维保照片上传
 */
+(void)uploadMaintenancePicSuccess:(void(^)(NSString *))success failure:(void(^)(NSError *error))failure done:(void(^)(NSString *))done;

/**
 * 维修换件报告上传
 */
+(void)uploadFixSuccess:(void(^)(NSString *))success failure:(void(^)(NSError *error))failure done:(void(^)(NSString *))done;

/**
 * 批量中断上传
 */
//+(void)uploadReportInBatchesSuccess:(void(^)(NSString *))success failure:(void(^)(NSError *error))failure;

/**
 * 上传签字数据
 */
+(void)uploadSignatureSuccess:(void(^)(NSString *))success failure:(void(^)(NSError *error))failure done:(void(^)(NSString *))done;

/**
 * 上传年检记录
 */
+(void)uploadYearlyCheckSuccess:(void(^)(NSString *))success failure:(void(^)(NSError *error))failure done:(void(^)(NSString *))done;

/**
 * 上传全工时数据
 */
+(void)uploadFullLaborHoursSuccess:(void(^)(NSString *))success failure:(void(^)(NSError *error))failure;

/**
 * 上传日志
 */
+(void)uploadLogSuccess:(void(^)(NSString *))success failure:(void(^)(NSError *error))failure;


@end
