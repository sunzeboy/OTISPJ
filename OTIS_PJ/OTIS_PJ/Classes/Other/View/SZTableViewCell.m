//
//  SZTableViewCell.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/21.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTableViewCell.h"
#import "SZFinalMaintenanceUnitItem.h"

@interface SZTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *elevatorIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *organizationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation SZTableViewCell

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
    static NSString *ID = @"SZTableViewCell";
    SZTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SZTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
    
}


//重写属性的setter方法，给子控件赋值
- (void)setMaintain:(SZFinalMaintenanceUnitItem *) maintain
{
    _maintain = maintain;
    self.fixXXX.hidden = !maintain.isFixMode;
    self.iconView.image = [UIImage imageNamed:maintain.CardTypeStr];
    self.elevatorIdLabel.text = maintain.UnitNo;
    self.organizationNameLabel.text = maintain.BuildingName;
    self.serialNumberLabel.text = maintain.Route;
    self.dateTypeLabel.text = maintain.TimesStr;
    self.dateLabel.text = maintain.CheckDateStr;
//    [self.serialNumberLabel.layer setBorderWidth:1.0];
    self.serialNumberLabel.layer.borderColor =[UIColor lightGrayColor].CGColor;
//    [self.dateTypeLabel.layer setBorderWidth:1.0];
    self.dateTypeLabel.layer.borderColor =[UIColor lightGrayColor].CGColor;
    
}





@end
