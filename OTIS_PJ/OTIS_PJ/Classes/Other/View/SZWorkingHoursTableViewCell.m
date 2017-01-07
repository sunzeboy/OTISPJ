//
//  SZWorkingHoursTableViewCell.m
//  OTIS_PJ
//
//  Created by zhangyang on 16/5/25.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZWorkingHoursTableViewCell.h"

@implementation SZWorkingHoursTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//创建自定义可重用的cell对象
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"SZWorkingHoursTableViewCell";
    SZWorkingHoursTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SZWorkingHoursTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
    
}
@end
