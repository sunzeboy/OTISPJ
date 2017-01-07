//
//  SZTodayMaintenance.m
//  OTIS_PJ
//
//  Created by sunze on 16/5/10.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZFinalTodayMaintenanceItem.h"

@implementation SZFinalTodayMaintenanceItem

- (NSString *)description
{
    return [NSString stringWithFormat:@"BuildingNo:%ld,BuildingName:%@,BuildingAddr:%@,Route:%@,Times:%ld,Year:%ld", self.BuildingNo,self.BuildingName,self.BuildingAddr,self.Route,self.Times,self.Year];
}
@end
