//
//  SZReservedSubjectItem.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/9.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZReservedSubjectItem : NSObject

/**
 *  工时种类ID
 */
@property (nonatomic, strong) NSArray *  LaborTypeID;
/**
 *  工时种类缩写
 */
@property (nonatomic, strong) NSArray *   LaborType;
/**
 *  工时种类名称
 */
@property (nonatomic, strong) NSArray *   LaborName;
/**
 *  有效日
 */
@property (nonatomic, strong) NSArray *   EffectiveDate;
/**
 *  无效日
 */
@property (nonatomic, strong) NSArray *    ExpiryDate;
/**
 *  工时种类 0 - 非生产性工时 1-生产性工时
 */
@property (nonatomic, strong) NSArray *    ProductiveType;


@end
