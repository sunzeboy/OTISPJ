//
//  SZSignTableViewCell.m
//  OTIS_PJ
//
//  Created by ousingi on 16/4/27.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZSignTableViewCell.h"
@interface SZSignTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *shengyuDate;
@property (weak, nonatomic) IBOutlet UIImageView *elevatorImage;
@property (weak, nonatomic) IBOutlet UILabel *elevatorIdView;
@property (weak, nonatomic) IBOutlet UILabel *organizationNameView;
@property (weak, nonatomic) IBOutlet UILabel *dateTypeView;
@property (weak, nonatomic) IBOutlet UILabel *dateView;
@end

@implementation SZSignTableViewCell

//创建可重用的cell对象
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"SZSignTableViewCell";
    SZSignTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SZSignTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
    
}

//按钮控制
- (IBAction)btnClick:(UIButton *)sender {
    //不同用户判断
    if([self.delegate selectCheak:_szsign]){
        //点击时，切换被选中属性的状态
        _szsign.selected = !_szsign.selected;
        sender.selected = _szsign.selected;
        [self.delegate calcSelected];
    }  
}

//cell内项目赋值
-(void)setSzsign:(SZFinalMaintenanceUnitItem *)szsign
{
    _szsign = szsign;
    //图标 圆角
    self.elevatorImage.image =[UIImage imageNamed:szsign.CardTypeStr];
    [self.elevatorImage.layer setMasksToBounds:YES];
    [self.elevatorImage.layer setCornerRadius:5.0];
    
    self.elevatorIdView.text = szsign.UnitNo;
    self.organizationNameView.text = szsign.BuildingName;
    //
    self.dateTypeView.text = szsign.TimesStr;
    //[self.dateTypeView.layer setBorderWidth:1.0];
    self.dateTypeView.layer.borderColor =[UIColor colorWithHexString:@"d2d2d2"].CGColor;
    self.dateView.text = szsign.CheckDateStr;
    //[self.dateView.layer setBorderWidth:1.0];
    self.dateView.layer.borderColor =[UIColor colorWithHexString:@"d2d2d2"].CGColor;
    //签字状态图片
    self.signView.selected = szsign.selected;
    [self.signView setBackgroundImage:[UIImage imageNamed:@"check_on"] forState:UIControlStateSelected];
    [self.signView setBackgroundImage:[UIImage imageNamed:@"check_off"] forState:UIControlStateNormal];
    
    
    self.shengyuDate.text = szsign.shengyuDate;
    
    
}


@end
