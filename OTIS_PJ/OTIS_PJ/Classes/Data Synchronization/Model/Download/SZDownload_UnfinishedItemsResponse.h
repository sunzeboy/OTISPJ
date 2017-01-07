//
//  SZDownload_UnfinishedItemsResponse.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/5.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZDownload_UnfinishedItemsResponse : NSObject

/**
 * 返回结果
 */
@property (nonatomic , copy) NSString *Result;

/**
 * 报告记录
 */
@property (nonatomic , assign) NSInteger ReportStamp;

/**
 *  同事做的维保报告
 */
@property (nonatomic, strong) NSArray *Report;

/**
 *   上次获取换件报告日期的Ticks，0则表示完全重新获取指定年截至今天的
 */
@property (nonatomic , assign) NSInteger FixStamp;

/**
 *  同事做的换件报告
 */
@property (nonatomic, strong) NSArray *Fix;




@end
