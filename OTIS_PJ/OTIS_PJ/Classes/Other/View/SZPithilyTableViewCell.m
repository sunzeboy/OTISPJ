//
//  SZPithilyTableViewCell.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/21.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZPithilyTableViewCell.h"
#import "SZWorkingHoursType.h"

@interface SZPithilyTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *workHourTypeView;
@property (weak, nonatomic) IBOutlet UILabel *imageLabel;

@end

@implementation SZPithilyTableViewCell

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
    static NSString *ID = @"SZPithilyTableViewCell";
    SZPithilyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SZPithilyTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
    
}

//重写属性的setter方法，给子控件赋值
- (void)setWorkingHoursType:(SZWorkingHoursType *) workingHoursType
{
    _workingHoursType = workingHoursType;
    self.workHourTypeView.image = [UIImage imageNamed:workingHoursType.workTypeImage];
    self.imageLabel.text = workingHoursType.imageName;
}




@end
