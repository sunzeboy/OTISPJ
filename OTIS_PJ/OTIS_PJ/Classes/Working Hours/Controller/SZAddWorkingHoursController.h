//
//  SZAddWorkingHoursController.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/16.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//


#import "SZLabor.h"
@interface SZAddWorkingHoursController : UITableViewController

@property (copy, nonatomic) void (^selectedBlock)(SZLabor *labor,BOOL isLastObject) ;

@property (nonatomic, strong) NSMutableArray *selectedTypes;

@property (nonatomic , assign) BOOL zhongduan;

@end
