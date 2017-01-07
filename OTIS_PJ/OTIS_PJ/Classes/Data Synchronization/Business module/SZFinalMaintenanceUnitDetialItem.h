//
//  SZFinalMaintenanceUnitDetialItem.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/17.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZFinalMaintenanceUnitItem.h"

@interface SZFinalMaintenanceUnitDetialItem : SZFinalMaintenanceUnitItem

/**
 * 电梯负责人
 */
@property (nonatomic , copy) NSString *Owner;

/**
 * 本次保养未完成多少项
 */
@property (nonatomic , copy) NSString *notCompletedsCount;

/**
 * 电梯型号
 */
@property (nonatomic , copy) NSString *ModelType;

/**
 * 经度
 */
@property (nonatomic , copy) NSString *longitude;

/**
 * 纬度
 */
@property (nonatomic , copy) NSString *latitude;

/**
 * 电梯负责人电话
 */
@property (nonatomic , copy) NSString *Tel;


/**
 * 工地地址
 */
@property (nonatomic , copy) NSString * BuildingAddr;

//--------------附加

@property (nonatomic , assign) NSInteger StartTime;
@property (nonatomic , assign) NSInteger EndTime;

@property (nonatomic , copy) NSString * StartLocalX;
@property (nonatomic , copy) NSString * StartLocalY;

@property (nonatomic , copy) NSString * EndLocalX;
@property (nonatomic , copy) NSString * EndLocalY;

@property (nonatomic , copy) NSString * Type;

@property (nonatomic , assign) NSInteger CreateTime;
@property (nonatomic , assign) NSInteger UpdateTime;
@property (nonatomic , copy) NSString * QRCode;

//手动输入的时间
@property (nonatomic , copy) NSString * GenerateDate;


@end
