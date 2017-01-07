//
//  SZTable_YearlyCheckDownload.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/24.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZTable_YearlyCheckDownload : NSObject

/**
 *  存储到YearlyCheckDB
 *
 *  @param params
 */
+(void)storageYearlyCheckWithParams:(NSArray *)YearlyCheckitems;

/**
 *  年检查询
 */
+(NSArray *)queryYearCheckItem;
+(NSMutableDictionary *)queryYearCheckItemData;
/**
 *  年检查询(我的)
 */
+(NSMutableDictionary *)queryDoneYearCheckItem;

@end
