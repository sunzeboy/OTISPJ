//
//  SZNormalWorkHoursTableViewCell.m
//  OTIS_PJ
//
//  Created by zy on 16/5/7.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZNormalWorkHoursTableViewCell.h"

@implementation SZNormalWorkHoursTableViewCell

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
    static NSString *reuseId = @"SZNormalWorkHoursTableViewCell";
    SZNormalWorkHoursTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SZNormalWorkHoursTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
    
}
@end
