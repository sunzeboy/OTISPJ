//
//  SZPuiWorkHoursTableViewCell.h
//  OTIS_PJ
//
//  Created by zy on 16/5/7.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZWorkingHours.h"

@interface SZPuiWorkHoursTableViewCell : UITableViewCell

@property(weak,nonatomic)SZWorkingHours *szworkinghours;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
