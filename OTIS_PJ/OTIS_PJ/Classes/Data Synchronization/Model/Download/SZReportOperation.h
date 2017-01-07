//
//  SZReportOperation.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/5.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZReportOperation : NSObject

/**
 * 保养操作编号
 */
@property (nonatomic , copy) NSString *Code;

/**
 * 保养操作状态
 */
@property (nonatomic , assign) int State;


@end
