//
//  SZDownloadManger.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SZDownloadManger : NSObject

/**
 *  数据同步
 *
 *  @param unitsSuccess           电梯成功
 *  @param unitsFailure           电梯失败
 *  @param schedulesSuccess       计划成功
 *  @param schedulesFailure       计划失败
 *  @param cardsSuccess           计划卡成功
 *  @param cardsFailure           计划卡失败
 *  @param unfinishedItemsSuccess 未完成项成功
 *  @param unfinishedItemsFailure 未完成项失败
 */
//+(void)startDownloadWithUnitsSuccess:(void(^)())unitsSuccess failure:(void(^)(NSError *error))unitsFailure andSchedulesSuccess:(void(^)())schedulesSuccess failure:(void(^)(NSError *error))schedulesFailure andCardsSuccess:(void(^)())cardsSuccess failure:(void(^)(NSError *error))cardsFailure andUnfinishedItemsSuccess:(void(^)())unfinishedItemsSuccess failure:(void(^)(NSError *error))unfinishedItemsFailure;
//+(void)startDownloadSuccess:(void(^)())success failure:(void(^)(NSError *error))failure;


+(void)startDownloadWithView:(UIView *)view Success:(void(^)())success failure:(void(^)(NSError *error))failure;
@end
