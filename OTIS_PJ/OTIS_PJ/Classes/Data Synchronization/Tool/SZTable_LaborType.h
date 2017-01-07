//
//  SZTable_LaborType.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/15.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZLaborTypeResponse.h"
#import "SZLabor.h"

@interface SZTable_LaborType : NSObject

+(void)storagWithLaborTypeResponse:(NSArray *)Labors;


/**
 *  统计全部生产性工时列表
 */
+(NSArray *)quaryProductive;


/**
 *  统计全部生产性工时列表
 */
+(NSArray *)quaryNonProductive;

/**
 *  根据LaborTypeID查找SZLabor
 */
+(SZLabor *)quaryLaborWithLaborTypeID:(int)laborTypeID;
+(SZLabor *)quaryLutuLaborWithLaborTypeID:(int)laborTypeID;
/**
 *  添加工时列表
 */
+(NSArray *)quaryaddWHTypeWithArray:(NSMutableArray *)arr;
/**
 *  添加工时列表(非本公司)
 */
+(NSArray *)quaryAddWHTypeWithArray:(NSMutableArray *)arr;

/**
 *  添加工时列表（中断工作调整原因）
 */
+(NSArray *)quaryaddZhongDuan;

/**
 *  查询路途工时项是否存在
 */
+(BOOL)quaryIsLutuWithRelationID:(int)relationID;
/**
 *  查询路途工时项是否存在
 */
+(NSString *)quaryLaborNameWithLaborTypeID:(int)laborTypeID;

/**
 *  查询LuTuLaborTypeID
 */
+(int)quaryLuTuLaborTypeIDWithLaborTypeID:(int)laborTypeID;

+(int)quaryOtherLaborTypeIDWithLaborTypeID:(int)laborTypeID ;

@end
