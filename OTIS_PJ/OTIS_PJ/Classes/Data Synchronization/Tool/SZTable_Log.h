//
//  SZTable_Log.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZTable_Log : NSObject

/**
 *  存储到LogDB
 *
 *  @param params
 */
+(void)storageLogWithParams:(NSDictionary *)params;
/**
 *  根据请求参数去沙盒中加载缓存的Log数据
 *
 *  @param params 请求参数
 */
+(NSArray *)readLogWithParams:(NSDictionary *)params;

@end
