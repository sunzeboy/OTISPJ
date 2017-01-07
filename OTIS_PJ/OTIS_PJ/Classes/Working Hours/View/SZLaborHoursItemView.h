//
//  SZLaborHoursItemView.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/21.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTable_LaborHours.h"
@interface SZLaborHoursItemView : UIView

@property (nonatomic , strong) SZLaborHoursItem *item;

+ (instancetype) loadSZLaborHoursItemView;

@end
