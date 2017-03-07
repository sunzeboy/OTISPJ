//
//  SZInputWorkingHourViewController.h
//  OTIS_PJ
//
//  Created by zhangyang on 16/5/30.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMDatePicker.h"
#import "SZFinalMaintenanceUnitDetialItem.h"
#import "SZFinalOutsidePlanMaintenanceItem.h"

@interface SZInputWorkingHourViewController : UIViewController<KMDatePickerDelegate>

@property (nonatomic , assign) NSInteger scheduleID;

@property (nonatomic , copy) NSString *contant_NO;

@property (nonatomic , copy) NSString *CustomerName;

@property (nonatomic , copy) NSString *unitNo;


@property (nonatomic , strong)  SZFinalMaintenanceUnitDetialItem *item;

@property (nonatomic , strong)  SZFinalOutsidePlanMaintenanceItem *outItem;

@property (nonatomic , assign) BOOL zhongduan;
// 是否在保修期flg
@property (nonatomic , assign) BOOL inWarranty;
// 从工时填写跳转
@property (nonatomic , assign) BOOL isWorkhour;
//分摊工时要用的数据
@property (nonatomic, strong) NSArray *records;
// 0:维保进入，非工时进入
// 1:维保是亮的，工时进入
// 2:维保是灰色的，工时进入
@property (nonatomic , assign) int  inputMode;
//
@property (nonatomic , assign) BOOL feizaibao;
//endtime是否需要更改
@property (nonatomic , assign) BOOL isChange;

@end
