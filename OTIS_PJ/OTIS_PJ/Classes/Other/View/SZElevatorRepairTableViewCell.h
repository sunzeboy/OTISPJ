//
//  SZElevatorRepairTableViewCell.h
//  OTIS_PJ
//
//  Created by zhangyang on 16/5/11.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SZFinalMaintenanceUnitItem;
@interface SZElevatorRepairTableViewCell : UITableViewCell

@property (nonatomic,strong) SZFinalMaintenanceUnitItem *maintain;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
