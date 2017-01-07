//
//  SZTable_Interrupt.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZTable_Interrupt : NSObject

/**
 *  存储到InterruptDB
 *
 *  @param params
 */
+(void)storageInterruptWithParams:(NSDictionary *)params;
/**
 *  根据请求参数去沙盒中加载缓存的Interrupt数据
 *
 *  @param params 请求参数
 */
+(NSArray *)readInterruptWithParams:(NSDictionary *)params;

@end
