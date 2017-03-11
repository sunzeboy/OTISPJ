//  保养操作
//  SZMaintenanceOperationViewController.h
//  OTIS_PJ
//
//  Created by zy on 16/5/6.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZPageViewController.h"
#import "SZFinalMaintenanceUnitDetialItem.h"
@class MDSVTModel;
@class ReqEventLogAndMaintenance;
@interface SZMaintenanceOperationViewController : SZPageViewController

@property (nonatomic , strong)  SZFinalMaintenanceUnitDetialItem *item;

@property (nonatomic , assign) BOOL isSign;

@property (nonatomic , assign) BOOL isJHAComplete;

@property (nonatomic , assign) BOOL isFixMode;

@property(nonatomic,strong) ReqEventLogAndMaintenance* eventLogModel;

/**
 MD 从SVT获取的数据model
 */

@property(nonatomic,strong) MDSVTModel* svtModel;

@end
