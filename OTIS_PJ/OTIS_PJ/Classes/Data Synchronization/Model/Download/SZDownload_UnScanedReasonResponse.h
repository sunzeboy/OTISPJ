//
//  SZDownload_UnScanedReasonResponse.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/27.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZUnitScanedItem : NSObject

@property (nonatomic , copy) NSString *UnitNo;
@property (nonatomic , assign) BOOL IsScaned;
@property (nonatomic , assign) BOOL IsNeedDialog;

@end


@interface SZDownload_UnScanedReasonResponse : NSObject
/**
 * 下载是否成功标志位 0-成功  1-失败
 */
@property (nonatomic , copy) NSString *Result;
/**
 * 时间戳
 */
@property (nonatomic , strong) NSArray *Units;

@end
