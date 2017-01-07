//
//  SZElevatorInfoTableViewCell.m
//  OTIS_PJ
//
//  Created by zy on 16/5/9.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZElevatorInfoTableViewCell.h"
#import "SZFinalOutsidePlanMaintenanceItem.h"

@interface SZElevatorInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *unitPic;

@property (weak, nonatomic) IBOutlet UILabel *buildingName;

@property (weak, nonatomic) IBOutlet UILabel *route;

@property (weak, nonatomic) IBOutlet UILabel *unitsNum;

@property (weak, nonatomic) IBOutlet UILabel *buildingAdress;

@end

@implementation SZElevatorInfoTableViewCell

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
    static NSString *ID = @"SZElevatorInfoTableViewCell";
    SZElevatorInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SZElevatorInfoTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
    
}

-(void)setMaintain:(SZFinalOutsidePlanMaintenanceItem *)maintain
{
    _maintain = maintain;
    
    self.unitPic.image = [UIImage imageNamed:@"building"];
    self.buildingName.text = maintain.BuildingName;
    self.route.text = maintain.Route;
    self.unitsNum.text = maintain.unitCount;
    self.buildingAdress.text = maintain.BuildingAddr;

}


@end
