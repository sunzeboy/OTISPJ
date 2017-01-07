//
//  SZTable_ReservedSubject.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/9.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZTable_ReservedSubject : NSObject

/**
 *  存储到ReservedSubjectDB
 *
 *  @param params
 */
+(void)storageReservedSubjectWithParams:(NSDictionary *)params;
/**
 *  根据请求参数去沙盒中加载缓存的ReservedSubject数据
 *
 *  @param params 请求参数
 */
+(NSArray *)readReservedSubjectWithParams:(NSDictionary *)params;

@end
