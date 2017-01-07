//
//  SZPuiWorkHoursTableViewCell.m
//  OTIS_PJ
//
//  Created by zy on 16/5/7.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZPuiWorkHoursTableViewCell.h"


@implementation SZPuiWorkHoursTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//创建可重用的cell对象
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"SZPuiWorkHoursTableViewCell";
    SZPuiWorkHoursTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SZPuiWorkHoursTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
    
}

@end
