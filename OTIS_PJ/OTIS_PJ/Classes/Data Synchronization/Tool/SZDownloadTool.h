//
//  SZDownloadTool.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SZDownload_UnitsRequest,
SZDownload_V4Request,
SZDownload_CardsRequest,
SZDownload_UnfinishedItemsRequest,
SZDownload_UnScanedReasonRequest,
SZDownload_ReservedSubjectRequest,
SZYearCheckRequest,
SZSafetyItemRequest,
SZLaborTypeRequest;


#import "SZHttpTool.h"
#import "SZDownload_UnitsRequest.h"
#import "SZDownload_V4Request.h"
#import "SZDownload_CardsRequest.h"
#import "SZDownload_UnfinishedItemsRequest.h"
#import "SZDownload_ReservedSubjectRequest.h"
#import "SZYearCheckRequest.h"


#import "SZDownload_ReservedSubjectResponse.h"

#import "SZYearCheckResponse.h"

#import "TablesAndFields.h"

#import "SZSafetyItemRequest.h"
#import "SZSafetyItemResponse.h"
#import "SZLaborTypeRequest.h"
#import "SZLaborTypeResponse.h"

#import "SZTable_LaborType.h"
#import "SZDownload_UnScanedReasonRequest.h"
#import "SZDownload_UnScanedReasonResponse.h"


@interface SZDownloadTool : NSObject

///**
// *  电梯离线下载
// *
// *  @param request request
// *  @param success success
// *  @param failure failure
// */
//+(void)downloadUnitsWithRequest:(SZDownload_UnitsRequest*)request success:(void(^)(NSDictionary *statuses))success failure:(void(^)(NSError *error))failure;
///**
// *  计划离线下载
// *
// *  @param request request
// *  @param success success
// *  @param failure failure
// */
//+(void)downloadSchedulesWithRequest:(SZDownload_V4Request*)request success:(void(^)(NSDictionary *statuses))success failure:(void(^)(NSError *error))failure;
///**
// *  保养卡离线下载
// *
// *  @param request request
// *  @param success success
// *  @param failure failure
// */
//+(void)downloadScheduleCardsWithRequest:(SZDownload_CardsRequest*)request success:(void(^)(NSDictionary *statuses))success failure:(void(^)(NSError *error))failure;
///**
// *  未完成项离线下载
// *
// *  @param request request
// *  @param success success
// *  @param failure failure
// */
//+(void)downloadUnfinishedItemsWithRequest:(SZDownload_UnfinishedItemsRequest*)request success:(void(^)(NSDictionary *statuses))success failure:(void(^)(NSError *error))failure;
//
///**
// *  预留科目离线下载
// *
// *  @param request request
// *  @param success success
// *  @param failure failure
// */
//+(void)downloadReservedSubjectWithRequest:(SZDownload_ReservedSubjectRequest*)request success:(void(^)(NSDictionary *statuses))success failure:(void(^)(NSError *error))failure;
//
///**
// *  年检离线下载
// *
// *  @param request request
// *  @param success success
// *  @param failure failure
// */
//+(void)downloadYearCheckWithRequest:(SZYearCheckRequest*)request success:(void(^)(NSDictionary *statuses))success failure:(void(^)(NSError *error))failure;
//
//
///**
// *  安全项离线下载
// *
// *  @param request request
// *  @param success success
// *  @param failure failure
// */
//+(void)downloadSafetyItemWithRequest:(SZSafetyItemRequest*)request success:(void(^)(NSDictionary *statuses))success failure:(void(^)(NSError *error))failure;
//
/**
 *  LaborType项离线下载
 *
 *  @param request request
 *  @param success success
 *  @param failure failure
 */
+(void)downloadLaborTypeWithRequest:(SZLaborTypeRequest*)request success:(void(^)(NSString *str))success failure:(void(^)(NSError *error))failure;


/**
 *  电梯离线下载
 *
 *  @param request request
 *  @param success success
 *  @param failure failure
 */
+(void)downloadUnitsWithRequest:(SZDownload_UnitsRequest*)request success:(void(^)(NSString *str))success failure:(void(^)(NSError *error))failure;
/**
 *  电梯离线下载
 *
 *  @param request request
 *  @param success success
 *  @param failure failure
 */
+(void)downloadUnScanedReasonWithRequest:(SZDownload_UnScanedReasonRequest*)request success:(void(^)(NSString *str))success failure:(void(^)(NSError *error))failure;
/**
 *  计划离线下载
 *
 *  @param request request
 *  @param success success
 *  @param failure failure
 */
+(void)downloadSchedulesWithRequest:(SZDownload_V4Request*)request success:(void(^)(NSString *str))success failure:(void(^)(NSError *error))failure;
/**
 *  保养卡离线下载
 *
 *  @param request request
 *  @param success success
 *  @param failure failure
 */
+(void)downloadScheduleCardsWithRequest:(SZDownload_CardsRequest*)request success:(void(^)(NSString *str))success failure:(void(^)(NSError *error))failure;
/**
 *  未完成项离线下载
 *
 *  @param request request
 *  @param success success
 *  @param failure failure
 */
+(void)downloadUnfinishedItemsWithRequest:(SZDownload_UnfinishedItemsRequest*)request success:(void(^)(NSString *str))success failure:(void(^)(NSError *error))failure;

/**
 *  预留科目离线下载
 *
 *  @param request request
 *  @param success success
 *  @param failure failure
 */
+(void)downloadReservedSubjectWithRequest:(SZDownload_ReservedSubjectRequest*)request success:(void(^)(NSString *str))success failure:(void(^)(NSError *error))failure;

/**
 *  年检离线下载
 *
 *  @param request request
 *  @param success success
 *  @param failure failure
 */
+(void)downloadYearCheckWithRequest:(SZYearCheckRequest*)request success:(void(^)(NSString *str))success failure:(void(^)(NSError *error))failure;
/**
 *  安全项离线下载
 *
 *  @param request request
 *  @param success success
 *  @param failure failure
 */
+(void)downloadSafetyItemWithRequest:(SZSafetyItemRequest*)request success:(void(^)(NSString *str))success failure:(void(^)(NSError *error))failure;

@end
