//
//  SZNormalWorkHoursTableViewCell.h
//  OTIS_PJ
//
//  Created by zy on 16/5/7.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZWorkingHours.h"

@interface SZNormalWorkHoursTableViewCell : UITableViewCell

@property(weak,nonatomic)SZWorkingHours *szworkinghours;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UITextField *weekdayTime;
@property (weak, nonatomic) IBOutlet UITextField *weekdayOvertime;
@property (weak, nonatomic) IBOutlet UITextField *weekendOvertime;
@property (weak, nonatomic) IBOutlet UITextField *holidayOvertime;

+(instancetype)cellWithTableView:(UITableView *)tableView;


@end
