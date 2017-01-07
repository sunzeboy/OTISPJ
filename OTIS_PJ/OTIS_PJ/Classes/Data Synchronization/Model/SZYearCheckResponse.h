//
//  SZYearCheckResponse.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/24.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZYearCheckResponse : NSObject

/**
 * 下载是否成功标志位 0-成功  1-失败
 */
@property (nonatomic , copy) NSString *Result;
/**
 * 时间戳
 */
@property (nonatomic , assign) NSInteger TimeStamp;
/**
 *  
 */
@property (nonatomic, strong) NSArray * YCheck;

@end
