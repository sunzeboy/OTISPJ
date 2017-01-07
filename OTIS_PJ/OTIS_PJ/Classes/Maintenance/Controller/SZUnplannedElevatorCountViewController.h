//
//  SZUnplannedElevatorCountViewController.h
//  OTIS_PJ
//
//  Created by zhangyang on 16/5/13.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZPithilyTableViewController.h"
#import "SZFinalOutsidePlanMaintenanceItem.h"

@interface SZUnplannedElevatorCountViewController : UIViewController

@property (nonatomic , strong) SZFinalOutsidePlanMaintenanceItem *item;

@property (nonatomic, strong) NSString *selectTitle;

@property (nonatomic , assign) BOOL isWorkingHours;

@property(nonatomic,copy)void(^unPlanBlock)();

@end
