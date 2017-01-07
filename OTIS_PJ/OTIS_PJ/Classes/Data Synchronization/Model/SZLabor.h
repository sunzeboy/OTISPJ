//
//  SZLabor.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/16.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZTable_LaborHours.h"

@interface SZLabor : NSObject
/**
 *  工时种类ID
 */
@property (nonatomic , assign) int LaborTypeID;

/**
 *  工时种类缩写
 */
@property (nonatomic , copy) NSString * LaborType;

/**
 *工时种类名称
 */
@property (nonatomic , copy) NSString * LaborName;

/**
 *  有效日
 */
@property (nonatomic , copy) NSString * EffectiveDate;

/**
 *  无效日
 */
@property (nonatomic , copy) NSString *  ExpiryDate;

/**
 *  是否为预留科目 0-正常工时种类  1-预留科目
 */
@property (nonatomic , assign) BOOL   IsSpecialLabor;

/**
 *  工时种类 0 - 非生产性工时 1-生产性工时
 */
@property (nonatomic , assign) int  ProductiveType;
/**
 *  工时种类关系ID
 */
@property (nonatomic , assign) int  RelationID;

//--------------附加
/**
 *  查询路途工时项是否存在
 */
@property (nonatomic , assign) BOOL isLutu;

@property (nonatomic , strong) SZLaborHoursItem *item1;

@property (nonatomic , strong) SZLaborHoursItem *item2;


@end

