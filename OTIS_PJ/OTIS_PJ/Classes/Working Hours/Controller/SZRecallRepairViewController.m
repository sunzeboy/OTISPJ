//
//  SZRecallRepairViewController.m
//  OTIS_PJ
//
//  Created by zy on 16/5/9.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZRecallRepairViewController.h"
#import "SZOtisElevatorViewController.h"
#import "SZNonOtisElevatorViewController.h"
#import "SZNavigationController.h"
#import "SZTable_LaborType.h"

@interface SZRecallRepairViewController ()

@property (nonatomic , strong) SZLabor *labor;

@end

@implementation SZRecallRepairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@－%@",SZLocal(@"title.WorkingHoursViewController"), self.labor.LaborName];
}


//1 懒加载
- (SZLabor *)labor
{
    if (_labor ==nil) {
        SZNavigationController *nav = (SZNavigationController*)self.navigationController;
        _labor = [SZTable_LaborType quaryLaborWithLaborTypeID:nav.laborTypeID==0?1:nav.laborTypeID];
    }
    return _labor;
}

-(void)setupChildVces
{
    SZOtisElevatorViewController *otis = [[SZOtisElevatorViewController alloc] init];
    otis.title = SZLocal(@"title.SZOtisElevatorViewController");
    otis.superTitle = [NSString stringWithFormat:@"%@－%@",SZLocal(@"title.WorkingHoursViewController"), self.labor.LaborName];
    [self addChildViewController:otis];
    
    SZNonOtisElevatorViewController *nonOtis = [[SZNonOtisElevatorViewController alloc] init];
    nonOtis.title = SZLocal(@"title.SZNonOtisElevatorViewController");
    [self addChildViewController:nonOtis];
}



@end
