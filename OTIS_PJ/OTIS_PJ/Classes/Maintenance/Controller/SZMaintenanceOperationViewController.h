//  保养操作
//  SZMaintenanceOperationViewController.h
//  OTIS_PJ
//
//  Created by zy on 16/5/6.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZPageViewController.h"
#import "SZFinalMaintenanceUnitDetialItem.h"

@interface SZMaintenanceOperationViewController : SZPageViewController

@property (nonatomic , strong)  SZFinalMaintenanceUnitDetialItem *item;

@property (nonatomic , assign) BOOL isSign;

@property (nonatomic , assign) BOOL isJHAComplete;

@property (nonatomic , assign) BOOL isFixMode;

@end
