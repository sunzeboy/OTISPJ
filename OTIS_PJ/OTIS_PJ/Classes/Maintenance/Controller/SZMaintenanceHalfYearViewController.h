//
//  SZMaintenanceHalfYearViewController.h
//  OTIS_PJ
//
//  Created by zy on 16/5/6.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTableViewController.h"
#import "SZFinalMaintenanceUnitDetialItem.h"


@interface SZMaintenanceHalfYearViewController : SZTableViewController
@property (nonatomic , strong) SZFinalMaintenanceUnitDetialItem *item;
@property (nonatomic , strong) SZFinalMaintenanceUnitDetialItem *item2;


@property (nonatomic , assign) BOOL ispreView;

@property (nonatomic , assign) BOOL isFixMode;

@property (nonatomic , assign) BOOL ischanged;

@property (nonatomic, strong) NSMutableArray *maintenanceOperation;

@property (nonatomic , assign) BOOL isSign;

@end
