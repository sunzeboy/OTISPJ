//
//  SZWorkingHourTableViewCell.m
//  OTIS_PJ
//
//  Created by zhangyang on 16/5/30.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZWorkingHourTableViewCell.h"

@implementation SZWorkingHourTableViewCell

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
    static NSString *reuseId = @"SZWorkingHourTableViewCell";
    SZWorkingHourTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SZWorkingHourTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
    
}
@end
