//
//  SZDownload_UnfinishedItemsRequest.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZDownload_UnfinishedItemsRequest : NSObject


/**
 *  登录终端的工号（需要加密，与服务端一致的加密方法，一致的Salt）
 */
@property (nonatomic , copy) NSString *UserNo;

/**
 *  用户密码
 */
@property (nonatomic , copy) NSString *Password;

/**
 * 指定年份
 */
@property (nonatomic , copy) NSString *Year;

/**
 *  版本号
 */
@property (nonatomic , copy) NSString *Ver;

/**
 *   上次获取保养报告日期的Ticks，0则表示完全重新获取指定年截至今天的
 */
@property (nonatomic , copy) NSString * ReportStamp;

/**
 *   上次获取换件报告日期的Ticks，0则表示完全重新获取指定年截至今天的
 */
@property (nonatomic , copy) NSString * FixStamp;


+(instancetype)unfinishedItemsRequest;

@end
