//
//  SZCustomerSignElevatorCell.m
//  OTIS_PJ
//
//  Created by jQ on 16/5/4.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZCustomerSignElevatorCell.h"
@interface SZCustomerSignElevatorCell()
@property(weak,nonatomic) IBOutlet UILabel *itemCode;
@property(weak,nonatomic) IBOutlet UILabel *itemName;
@property(weak,nonatomic) IBOutlet UIButton *isStandard;

@end

@implementation SZCustomerSignElevatorCell

- (void)awakeFromNib {
    //Initialization
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//创建可重用的cell对象
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId =@"SZCustomerSignElevatorCell";
    SZCustomerSignElevatorCell *cell =[tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SZCustomerSignElevatorCell" owner:self options:nil] lastObject];
    }
    return cell;
}
- (IBAction)btn:(id)sender {

}
//cell内项目赋值
-(void)setSzCustomerSignElevatorItem:(SZCustomerSignElevatorItem *)szCustomerSignElevatorItem
{
    _szCustomerSignElevatorItem =szCustomerSignElevatorItem;
    self.itemCode.text = szCustomerSignElevatorItem.itemCode;
    self.itemName.text = szCustomerSignElevatorItem.itemName;
    self.itemName.numberOfLines = 0;
    self.itemName.lineBreakMode = NSLineBreakByWordWrapping;
    //self.isStandard = szCustomerSignElevatorItem.isStandard;
    //
    self.isStandard.selected = szCustomerSignElevatorItem.isStandard;
    [self.isStandard setBackgroundImage:[UIImage imageNamed:@"check_on"] forState:UIControlStateSelected];
    [self.isStandard setBackgroundImage:[UIImage imageNamed:@"check_off"] forState:UIControlStateNormal];
    //--
    CGRect frame = [self frame];
    frame.size.height =self.itemName.frame.size.height + 50;
    self.frame = frame;
    
}

@end
