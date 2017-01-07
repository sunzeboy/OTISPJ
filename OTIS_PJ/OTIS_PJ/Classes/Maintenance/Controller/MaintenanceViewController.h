//
//  MaintenanceViewController.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/21.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZPageViewController.h"
#import "TodayViewController.h"
#import "NotCompletedViewController.h"
#import "TwoWeeksViewController.h"
#import "UnplannedViewController.h"

@interface MaintenanceViewController : SZPageViewController<TodayDelegate,NotCompletedDelegate,TwoWeeksDelegate,UnplannedViewControllerDelegate>

@end
