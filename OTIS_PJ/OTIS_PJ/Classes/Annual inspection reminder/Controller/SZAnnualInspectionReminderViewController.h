//
//  SZAnnualInspectionReminderViewController.h
//  OTIS_PJ
//
//  Created by jQ on 16/5/10.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZAnnualInspectionReminder.h"
#import "SZAnnualInspectionDetailView.h"
#import "SZTable_YearlyCheck.h"
#import "SZBackController.h"

@class SZFinalMaintenanceUnitItem;
@interface SZAnnualInspectionReminderViewController : SZBackController<annualSaveDelegate>

@property (copy, nonatomic) void (^confirmActBlock)() ;
//@property (copy, nonatomic) NSString *overDate;
//@property (strong, nonatomic) UILabel *overDate2;
@property (nonatomic , assign) BOOL isChaoqi;

/**
 * 电梯编号
 */
@property (nonatomic , copy) NSString *UnitNo;



@end
