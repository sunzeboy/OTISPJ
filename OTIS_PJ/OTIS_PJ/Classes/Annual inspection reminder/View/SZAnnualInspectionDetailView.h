//
//  SZAnnualInspectionDetailView.h
//  OTIS_PJ
//
//  Created by jQ on 16/5/11.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZFinalMaintenanceUnitDetialItem.h"
#import "KMDatePicker.h"

@protocol annualSaveDelegate
- (void) saveEvent;
@end
@interface SZAnnualInspectionDetailView : UIView

@property (weak, nonatomic) IBOutlet UITextField *yCheakADate;
// 计划年检日期
@property (weak, nonatomic) IBOutlet UILabel *yCheakPDate;
// 超过天数
@property (weak, nonatomic) IBOutlet UILabel *overDate;

@property(weak,nonatomic)SZFinalMaintenanceUnitDetialItem *szreminder;
@property(nonatomic,weak,) id <annualSaveDelegate> delegate;
+ (instancetype) loadSZAnnualInspectionDetailView;
@end
