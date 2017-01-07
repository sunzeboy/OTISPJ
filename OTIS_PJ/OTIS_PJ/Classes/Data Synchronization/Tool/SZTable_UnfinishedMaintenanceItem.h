//
//  SZTable_UnfinishedMaintenanceItem.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/7.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZDownload_UnfinishedItemsResponse.h"

@interface SZTable_UnfinishedMaintenanceItem : NSObject

+(void)storgeTabReportItemCompleteState:(SZDownload_UnfinishedItemsResponse *)response;



+(void)storgeFixItemCompleteState:(SZDownload_UnfinishedItemsResponse *)response;


@end
