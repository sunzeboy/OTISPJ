//
//  SZPreviewViewController.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/30.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZPageViewController.h"
#import "SZFinalMaintenanceUnitDetialItem.h"

@interface SZPreviewViewController : UIViewController

@property (nonatomic , strong) SZFinalMaintenanceUnitDetialItem *item;


@property (nonatomic, strong) NSMutableArray *maintenanceOperation;


@end
