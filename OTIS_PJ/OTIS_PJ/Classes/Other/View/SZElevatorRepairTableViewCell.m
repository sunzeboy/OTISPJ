//
//  SZElevatorRepairTableViewCell.m
//  OTIS_PJ
//
//  Created by zhangyang on 16/5/11.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZElevatorRepairTableViewCell.h"
#import "SZFinalMaintenanceUnitItem.h"

@interface SZElevatorRepairTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *elevatorIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
- (IBAction)clickAct:(UIButton *)sender;

@end
@implementation SZElevatorRepairTableViewCell

- (void)awakeFromNib {

    
}

//创建自定义可重用的cell对象
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"SZElevatorRepairTableViewCell";
    SZElevatorRepairTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SZElevatorRepairTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
    
}




//重写属性的setter方法，给子控件赋值
- (void)setMaintain:(SZFinalMaintenanceUnitItem *) maintain
{
    _maintain = maintain;
    self.selectBtn.hidden = !maintain.showSelected;
    self.selectBtn.selected = maintain.selected;
    if (maintain.CardType == -1) {
        self.iconView.image = [UIImage imageNamed:@"lht_default"];
    }else{
        self.iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",maintain.CardTypeStr]];
    }
    self.elevatorIdLabel.text = maintain.UnitNo;
    self.serialNumberLabel.text = maintain.Route;
}
- (IBAction)clickAct:(UIButton *)sender {
    _selectBtn = sender;
    _selectBtn.selected = !_selectBtn.selected;

    self.maintain.selected = sender.selected;
    
}


@end
