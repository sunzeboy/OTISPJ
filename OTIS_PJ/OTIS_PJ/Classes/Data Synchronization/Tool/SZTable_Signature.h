//
//  SZTable_Signature.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

//服务态度(1.非常满意 2.满意 3.不满意)
typedef NS_ENUM(int,OTISEvaluateType){
    OTISEvaluateTypeVerySatisfied = 1,//
    OTISEvaluateTypeSatisfied = 2,//
    OTISEvaluateTypeNotSatisfied = 3//
};



@interface SZTable_Signature : NSObject

/**
 *  存储到SignatureDB
 *
 *  @param params
 */
+(void)storageWithAttitude:(OTISEvaluateType)attitude quality:(OTISEvaluateType)quality signComment:(NSString *)signComment isAbsent:(BOOL)isAbsent customer:(NSString *)customer signature:(NSString *)signature isEmail:(BOOL)isEmail emailAddr:(NSString *)emailAddr isImageUploaded:(BOOL)isImageUploaded andScheduleIDs:(NSArray *)scheduleIDs;
/**
 *  根据请求参数去沙盒中加载缓存的Signature数据
 *
 *  @param params 请求参数
 */
+(NSArray *)readSignatureWithParams:(NSDictionary *)params;

/**
 *  保存SignatureDB（IsUploaded）
 */
+(void)uploadedwithSignId:(int)signid;
/**
 *  保存SignatureDB（IsUploaded）
 */
+(void)uploadedImagewithSignId:(int)scheduleID;


+(void)deleteImagewithScheduleID:(int)scheduleID;

/**
 *  删除维保图片（IsUploaded）
 */
+(void)uploadedWeibaoImagewithScheduleID:(int)scheduleID;

@end
