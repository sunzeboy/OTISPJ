//
//  SZAnnualInspectionDetailView.m
//  OTIS_PJ
//
//  Created by jQ on 16/5/11.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZAnnualInspectionDetailView.h"
#import "CustomIOSAlertView.h"
#import "UIView+Extension.h"
#import "SZTable_YearlyCheck.h"
@interface SZAnnualInspectionDetailView()
//@interface SZAnnualInspectionDetailView()

// Image
@property (weak, nonatomic) IBOutlet UIImageView *modelTypeImage;
// 电梯编号
@property (weak, nonatomic) IBOutlet UILabel *unitNo;
// 超过天数
//@property (weak, nonatomic) IBOutlet UILabel *overDate;
// 电梯型号
@property (weak, nonatomic) IBOutlet UILabel *modelType;
// 路线
@property (weak, nonatomic) IBOutlet UILabel *route;
// 工地
@property (weak, nonatomic) IBOutlet UILabel *buildingName;
// 地址
@property (weak, nonatomic) IBOutlet UILabel *buildingAddr;
// 电梯负责人
@property (weak, nonatomic) IBOutlet UILabel *elevatorowner;
// 电话
@property (weak, nonatomic) IBOutlet UILabel *tel;

// 实际年检日期

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@end

@implementation SZAnnualInspectionDetailView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code


}




+ (instancetype) loadSZAnnualInspectionDetailView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"SZAnnualInspectionDetailView" owner:self options:nil]lastObject];
}

//项目赋值
-(void)setSzreminder:(SZFinalMaintenanceUnitDetialItem *)szreminder
{
    _szreminder = szreminder;

    self.modelTypeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",szreminder.CardTypeStr]];
    [self.modelTypeImage.layer setMasksToBounds:YES];
    [self.modelTypeImage.layer setCornerRadius:5.0];
    //
    self.unitNo.text = szreminder.UnitNo;
    //超期日数计算
    //---
//    SZLog(@"today :%@,planDay :%@",[NSDate date],szreminder.YCheckDateStr);
    
    NSMutableAttributedString *text0;
    
    if (szreminder.inNextTwoMonths && szreminder.isChaoqi == NO ) {
        text0 = [[NSMutableAttributedString alloc] initWithString:SZLocal(@"btn.title.Off due day")];
        [text0 addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, text0.length)];
        NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", abs((int)szreminder.TipDays) ]];
        [text1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, text1.length)];
        [text0 insertAttributedString:text1 atIndex:3];
        
        self.yCheakPDate.text = szreminder.inNextTwoMonths;
        
        
    }else{
        text0 = [[NSMutableAttributedString alloc] initWithString:SZLocal(@"btn.title.Extended day")];
        [text0 addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, text0.length)];
        NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",szreminder.OverdueDays]];
        [text1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, text1.length)];
        [text0 insertAttributedString:text1 atIndex:2];
        
        self.yCheakPDate.text = szreminder.showDateStr;
        
    }
    //超期日期变色
    if (szreminder.isAnnualled) {
        self.overDate.text =SZLocal(@"btn.title.Completed annual inspection");
        self.overDate.textColor = [UIColor colorWithHexString:@"#006400"];
        
        
    }else{
        self.overDate.attributedText = text0;
    }
    
    //
    //[self.overDate.layer setBorderWidth:1];
    self.overDate.layer.borderColor =[UIColor colorWithHexString:@"d2d2d2"].CGColor;
    
    //---
//    NSInteger dayCount =[self computeDaysWithDataFromString:szreminder.YCheckDateStr];
//    //超期日数变色
//    NSMutableAttributedString *text0 = [[NSMutableAttributedString alloc] initWithString:@"超期天"];
//    [text0 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, text0.length)];
//    NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",(long)dayCount]];
//    [text1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, text1.length)];
//    [text0 insertAttributedString:text1 atIndex:2];
//    self.overDate.attributedText = text0;
    //
    self.modelType.text = szreminder.ModelType;
    self.route.text = szreminder.Route;
    self.buildingName.text = szreminder.BuildingName;
    self.buildingAddr.text = szreminder.BuildingAddr;
    self.elevatorowner.text = szreminder.Owner;
    if (szreminder.Tel==nil||[szreminder.Tel isEqualToString:@""]) {
        self.tel.text=SZLocal(@"dialog.title.No");
    }else{
        self.tel.text = szreminder.Tel;
    }
    
    NSInteger adate = [SZTable_YearlyCheck qyaryYearlyCheckDateWithUnitNo:szreminder.UnitNo];
//    self.yCheakPDate.text = szreminder.YCheckDateStr;

    if (adate) {
        NSTimeInterval secs = adate/10000000 - 62135557865;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        
        [format setDateFormat:@"yyyy-MM-dd"];
        
        NSString *str = [format stringFromDate:date];
        self.yCheakADate.text = str;
        self.overDate.text =SZLocal(@"btn.title.Annual inspection completion");
        self.overDate.textColor = [UIColor colorWithHexString:@"#006400"];

    }else{
        self.yCheakADate.text = @"";

    }
    //按钮圆角
    [self.saveBtn.layer setMasksToBounds:YES];
    [self.saveBtn.layer setCornerRadius:5.0];
}

//计算日期间隔天数
- (NSInteger)computeDaysWithDataFromString:(NSString *)string
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:[dateFormatter dateFromString:string]];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:[NSDate date]];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return dayComponents.day;
}
- (IBAction)saveBtnClick:(id)sender {
    if([self.yCheakADate.text  isEqual: @""]){
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.annualInspection")
                                                                                     dialogContents:SZLocal(@"dialog.content.checkDateInput")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            [alertView close];
        };
        [alertView show];
    }else{
        NSMutableString * dialog1 = [[NSMutableString alloc] initWithString:SZLocal(@"dialog.content.Actual annual inspection date is saved?")];
        [dialog1 insertString:self.yCheakADate.text atIndex:6];
        
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.annualInspection")
                                                                                     dialogContents:dialog1
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            if(buttonIndex == 0){
                //确认
                [alertView close];
                //保存代理方法执行
                [self.delegate saveEvent];
            }else if(buttonIndex == 1){
                self.yCheakADate.text=@"";
                [alertView close];
            }
        };
        [alertView show];
        //[self.delegate saveEvent];
    }
}
@end
