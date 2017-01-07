//
//  SZDownload_CardsResponse.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/27.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZDownload_CardsResponse : NSObject


/**
 * 返回结果
 */
@property (nonatomic , copy) NSString *Result;

/**
 * 版本号
 */
@property (nonatomic , copy) NSString *Ver;

/**
 *  保养项
 */
@property (nonatomic, strong) NSArray *Items;


/**
 *  计划保养项
 */
@property (nonatomic, strong) NSArray *Schedule;

@end
