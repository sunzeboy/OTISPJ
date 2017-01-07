//
//  SZPithilyTableViewCell.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/21.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SZWorkingHoursType;
@interface SZPithilyTableViewCell : UITableViewCell
@property (nonatomic,strong) SZWorkingHoursType *workingHoursType;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
