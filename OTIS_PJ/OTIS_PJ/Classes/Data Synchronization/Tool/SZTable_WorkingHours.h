//
//  SZTable_WorkingHours.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZTable_WorkingHours : NSObject

/**
 *  存储到WorkingHoursDB
 *
 *  @param params
 */
+(void)storageWorkingHoursWithParams:(NSDictionary *)params;
/**
 *  根据请求参数去沙盒中加载缓存的WorkingHours数据
 *
 *  @param params 请求参数
 */
+(NSArray *)readWorkingHoursWithParams:(NSDictionary *)params;

@end
