//
//  SZBeforehandStorageManager.m
//  OTIS_PJ
//
//  Created by sunze on 16/5/19.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZBeforehandStorageManager.h"
#import "SZTable_JHA_TYPE.h"
#import "SZTable_JHA_ITEM.h"
#import "SZTable_JHA_ITEM_TYPE.h"

#import "SZTable_System.h"

@implementation SZBeforehandStorageManager

/**
 *  预先存储一些JHA信息(当应用程序第一次安装或版本升级的时候才执行)
 */
+(void)beforehandStorage{

    [SZTable_JHA_TYPE storaget_JHA_TYPE];
    [SZTable_JHA_ITEM_TYPE storaget_JHA_ITEM_TYPE];
    [SZTable_JHA_ITEM storaget_JHA_ITEM];

    
    
    
    
//    [SZTable_JHA_ITEM_TYPE storaget_LaborType];
}

@end
