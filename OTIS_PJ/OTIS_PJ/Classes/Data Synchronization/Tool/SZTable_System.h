//
//  SZTable_System.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/13.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZTable_System : NSObject

/**
 *  存计划卡版本号到t_System
 *
 *  @param dic 参数
 */
+(void)updateTabSystemWithUpdateVer:(NSString *)updateVer;
/**
 *  获取计划卡版本号
 */
+(NSString *)updateVer;

//------------------------------------------------------------------------------------------------------------------------------------------------
/**
 *  安全项版本号到t_System
 *
 *  @param dic 参数
 */
+(void)updateTabSystemWithSafeItemVer:(int)safeItemVer;
/**
 *  获取安全项版本号
 */
+(NSString *)safetyItemVer;
//------------------------------------------------------------------------------------------------------------------------------------------------

/**
 *  LaborType项版本号到t_System
 *
 *  @param dic 参数
 */
+(void)updateLaborTypeWithLaborItemVer:(NSString *)laborItemVer;

/**
 *  获取LaborType版本号
 */
+(NSString *)laborItemVer;



@end
