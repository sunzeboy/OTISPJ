//  工作危险性分析
//  SZJobHazardAnalysisViewController.h
//  OTIS_PJ
//
//  Created by zy on 16/5/4.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZPageViewController.h"
#import "SZFinalMaintenanceUnitDetialItem.h"


@interface SZJobHazardAnalysisViewController : SZPageViewController

@property (nonatomic , strong) SZFinalMaintenanceUnitDetialItem *item;

@property (nonatomic , assign) BOOL isCheckItem;

@property (nonatomic , assign) int  inputMode;

// 是否是维修换件方式进入，1：Fix方式，0：正常维保进入
@property (nonatomic , assign) BOOL IsFixItem;

@end
