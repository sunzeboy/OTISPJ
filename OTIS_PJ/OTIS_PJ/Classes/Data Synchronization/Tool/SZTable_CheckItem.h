//
//  SZTable_SchedulesCards.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/28.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZTable_CheckItem : NSObject

/**
 *  存储到ScheduleCardsDB
 *
 *  @param params
 */
+(void)storageScheduleCards:(NSArray *)cards;


+(void)updateScheduleCards:(NSArray *)cards;
///**
// *  根据请求参数去沙盒中加载缓存的ScheduleCards数据
// *
// *  @param params 请求参数
// */
//+(NSArray *)readScheduleCardsWithParams:(NSDictionary *)params;


@end
