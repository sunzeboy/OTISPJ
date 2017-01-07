//
//  SZTable_MaintenanceItems.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZTable_ScheduleCheckItem : NSObject

/**
 *  存储到MaintenanceItemsDB
 *
 *  @param params
 */
+(void)storageScheduleCheckItems:(NSArray *)scheduleCheckItems;


@end
