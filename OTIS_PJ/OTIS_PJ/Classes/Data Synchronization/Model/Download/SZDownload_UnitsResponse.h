//
//  SZDownload_UnitsResponse.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/27.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//


@interface SZDownload_UnitsResponse : NSObject

/**
 * 返回结果
 */
@property (nonatomic , copy) NSString *Result;

/**
 * 版本号
 */
@property (nonatomic , assign) NSInteger Ver;

/**
 * 电梯
 */
@property (nonatomic, strong) NSArray *Units;

/**
 * 电梯
 */
@property (nonatomic, strong) NSArray *Buildings;

@end
