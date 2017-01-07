//
//  SZElevatorInfoTableViewCell.h
//  OTIS_PJ
//
//  Created by zy on 16/5/9.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SZFinalOutsidePlanMaintenanceItem;

@interface SZElevatorInfoTableViewCell : UITableViewCell

@property (nonatomic,strong) SZFinalOutsidePlanMaintenanceItem *maintain;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
