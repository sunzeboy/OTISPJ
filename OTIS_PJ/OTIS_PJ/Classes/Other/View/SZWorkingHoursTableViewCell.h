//
//  SZWorkingHoursTableViewCell.h
//  OTIS_PJ
//
//  Created by zhangyang on 16/5/25.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZWorkingHoursTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *stepView;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *allTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekdayHour;
@property (weak, nonatomic) IBOutlet UILabel *weekdayOvertime;
@property (weak, nonatomic) IBOutlet UILabel *weekendOvertime;
@property (weak, nonatomic) IBOutlet UILabel *holidayOvertime;
+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
