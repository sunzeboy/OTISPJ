//
//  SZBuilding.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/5.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZBuilding : NSObject


/**
 * 工地地址
 */
@property (nonatomic , copy) NSString *Addr;

/**
 * 工地编号
 */
@property (nonatomic , assign) NSInteger BuildingNo;

/**
 * 工地名
 */
@property (nonatomic , copy) NSString *Name;

/**
 * 工地路线
 */
@property (nonatomic , copy) NSString *Route;

/**
 * 监督号
 */
@property (nonatomic , assign) NSInteger SupervisorNo;


@end
