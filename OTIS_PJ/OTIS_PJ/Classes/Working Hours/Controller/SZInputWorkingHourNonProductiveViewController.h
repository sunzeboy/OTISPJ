//
//  SZInputWorkingHourNonProductiveViewController.h
//  OTIS_PJ
//
//  Created by zhangyang on 16/6/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMDatePicker.h"
#import "SZCheckLookModel.h"
#import "SZTable_LaborType.h"
#import "SZBackController.h"

@interface SZInputWorkingHourNonProductiveViewController : SZBackController<KMDatePickerDelegate>
/**
 *  工时种类ID
 */
@property (nonatomic , assign) int LaborTypeID;
@property (nonatomic , strong) SZLaborHoursItem *item;

@property (nonatomic, strong) SZCheckLookModel *model;
@property (nonatomic, assign) BOOL hasInput;

@end
