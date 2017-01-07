//
//  SZTable_YearlyCheck.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZYearCheckItem.h"

@interface SZTable_YearlyCheck : NSObject
/**
 *  存储到YearlyCheckDB
 *
 *  @param params
 */

/**
 *  根据请求参数去沙盒中加载缓存的YearlyCheck数据
 *
 *  @param params 请求参数
 */
+(NSArray *)readYearlyCheckWithParams:(NSDictionary *)params;



+(void)storageYearlyCheck:(SZYearCheckItem *)checkItem;
+(void)storageYearlyChecks:(NSMutableArray *)arrayItems WithTime:(NSString *)time;

/**
 更新已上传的年检记录Upload状态！！！
 */
+(void)updateYearlyCheckDone;


+(NSInteger)qyaryYearlyCheckDateWithUnitNo:(NSString *)unitNo;


@end
