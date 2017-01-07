//
//  SZTable_UserRoute.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZTable_UserRoute : NSObject

/**
 *  存储到UserRouteDB
 *
 *  @param params
 */
+(void)storageUserRoute:(NSInteger)RouteNo;
/**
 *  根据请求参数去沙盒中加载缓存的UserRoute数据
 *
 *  @param params 请求参数
 */
+(NSArray *)readWorkingHoursWithParams:(NSDictionary *)params;
/**
 *  查找当前EmployeeID关联的所有RoutNo
 *
 *  @param params 请求参数
 */
+(NSArray *)routNos;

+(NSString *)routNosForDb;

@end
