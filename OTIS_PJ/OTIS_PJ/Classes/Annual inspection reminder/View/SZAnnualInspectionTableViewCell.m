//
//  SZAnnualInspectionTableViewCell.m
//  OTIS_PJ
//
//  Created by jQ on 16/5/9.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZAnnualInspectionTableViewCell.h"
@interface SZAnnualInspectionTableViewCell();

@property (weak, nonatomic) IBOutlet UILabel *unitNo;
@property (weak, nonatomic) IBOutlet UILabel *organizationName;
@property (weak, nonatomic) IBOutlet UILabel *route;
@property (weak, nonatomic) IBOutlet UILabel *yCheakPDate;
@property (weak, nonatomic) IBOutlet UIImageView *modelTypeImage;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
- (IBAction)selectAct:(UIButton *)sender;

@end
@implementation SZAnnualInspectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//创建可重用的cell对象
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"SZAnnualInspectionTableViewCell";
    SZAnnualInspectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SZAnnualInspectionTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
    
}

//cell内项目赋值
-(void)setSzannual:(SZFinalMaintenanceUnitItem *)szannual
{
    _szannual = szannual;
    self.unitNo.text = szannual.UnitNo;
    self.organizationName.text = szannual.BuildingName;
    self.route.text = szannual.Route;
    //[self.route.layer setBorderWidth:1];
    self.route.layer.borderColor =[UIColor colorWithHexString:@"d2d2d2"].CGColor;
    //超期日数计算
//    NSInteger dayCount = [self computeDaysWithDataFromString:szannual.YCheckDateStr];
    NSMutableAttributedString *text0;
    
    if (szannual.inNextTwoMonths && szannual.isChaoqi == NO ) {
        text0 = [[NSMutableAttributedString alloc] initWithString:SZLocal(@"btn.title.Off due day")];
        [text0 addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, text0.length)];
        NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", abs((int)szannual.TipDays) ]];
        [text1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, text1.length)];
        [text0 insertAttributedString:text1 atIndex:3];
        self.yCheakPDate.text = szannual.inNextTwoMonths;

        
    }else{
        text0 = [[NSMutableAttributedString alloc] initWithString:SZLocal(@"btn.title.Extended day")];
        [text0 addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, text0.length)];
        NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",szannual.OverdueDays]];
        [text1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, text1.length)];
        [text0 insertAttributedString:text1 atIndex:2];
        
        self.yCheakPDate.text = szannual.showDateStr;

    }
    //超期日期变色
    if (szannual.isAnnualled) {
        self.overDate.text = SZLocal(@"btn.title.Annual inspection completion");
        self.overDate.textColor = [UIColor colorWithHexString:@"#006400"];

        
    }else{
        self.overDate.attributedText = text0;
    }
    
    //
    //[self.overDate.layer setBorderWidth:1];
    self.overDate.layer.borderColor =[UIColor colorWithHexString:@"d2d2d2"].CGColor;
    
//    if (szannual.inNextTwoMonths) {
//        self.yCheakPDate.text = szannual.inNextTwoMonths;
//
//    }else{
//        self.yCheakPDate.text = szannual.showDateStr;
//
//    }
    
    
    
    //图片
    self.modelTypeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",szannual.CardTypeStr]];
    [self.modelTypeImage.layer setMasksToBounds:YES];
    [self.modelTypeImage.layer setCornerRadius:5.0];
    
    self.selectBtn.selected = szannual.selected;
}

////计算日期间隔天数
//- (NSInteger)computeDaysWithDataFromString:(NSString *)string
//{
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    [gregorian setFirstWeekday:2];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSDate *fromDate;
//    NSDate *toDate;
//    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:[dateFormatter dateFromString:string]];
//    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:[NSDate date]];
//    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
//    
//    return dayComponents.day;
//}
- (IBAction)selectAct:(UIButton *)sender {
    sender.selected = !sender.selected;
    _szannual.selected = sender.selected;
    
}


@end
