//
//  SZSafetyItemResponse.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/25.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZSafetyItemResponse : NSObject
/**
 * 下载是否成功标志位 0-成功  1-失败
 */
@property (nonatomic , copy) NSString *Result;
/**
 * 安全项版本号
 */
@property (nonatomic , assign) int SafetyItemVer;
/**
 *
 */
@property (nonatomic, strong) NSArray * SafetyItem;

@end
