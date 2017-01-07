//
//  SZAnnualInspectionReminderViewController.m
//  OTIS_PJ
//
//  Created by jQ on 16/5/10.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZAnnualInspectionReminderViewController.h"
#import "SZModuleQueryTool.h"
#import "SZFinalMaintenanceUnitDetialItem.h"
#import "CustomIOSAlertView.h"
#import "NSDate+Extention.h"

@interface SZAnnualInspectionReminderViewController ()<KMDatePickerDelegate,UITextFieldDelegate>
@property (strong,nonatomic)SZAnnualInspectionDetailView *detailView;
@property (strong,nonatomic)SZFinalMaintenanceUnitDetialItem *reminder;
@end

@implementation SZAnnualInspectionReminderViewController
- (BOOL)shouldAutorotate{
    
    return NO;
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.detailView.yCheakADate = textField;
}
#pragma mark - KMDatePickerDelegate
- (void)datePicker:(KMDatePicker *)datePicker didSelectDate:(KMDatePickerDateModel *)datePickerDate {
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@",
                         datePickerDate.year,
                         datePickerDate.month,
                         datePickerDate.day
                         ];
    self.detailView.yCheakADate.text = dateStr;
}

//设置数据（from plist）
-(SZFinalMaintenanceUnitDetialItem *)reminder
{
    if(_reminder ==nil){
        _reminder =[SZModuleQueryTool queryYearCheckDetialItemWithUnitNo:self.UnitNo];
    }
    return _reminder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SZLocal(@"title.annualInspection");
    self.alertTitle=SZLocal(@"dialog.content.Actual annual inspection date is not saved, whether to quit?");
    [self setUpDetailView];
}

-(void)backControllerBack{
    
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                 dialogContents:self.alertTitle
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        if(buttonIndex == 0){
            [alertView close];
            if (![self.detailView.yCheakADate.text isEqualToString:@""]) {
                //如果已完成年检在此更新数据库字段
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else if(buttonIndex == 1){
            [alertView close];
        }
    };
    [alertView show];
}

-(void)setUpDetailView
{
    self.reminder.isChaoqi = self.isChaoqi;
    _detailView = [SZAnnualInspectionDetailView loadSZAnnualInspectionDetailView];
    //数据设置给View
    _detailView.szreminder = self.reminder;
    _detailView.backgroundColor = [UIColor whiteColor];
    _detailView.frame =CGRectMake(0, 64, SCREEN_WIDTH,(SCREEN_HEIGHT - 64));
    _detailView.delegate = self;

    [self.view addSubview:_detailView];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    KMDatePicker *datePicker = [[KMDatePicker alloc]
                                initWithFrame:CGRectMake(0.0, 0.0, rect.size.width, 216.0)
                                delegate:self
                                datePickerStyle:KMDatePickerStyleYearMonthDay];
    
    self.detailView.yCheakADate.delegate = self;
    self.detailView.yCheakADate.inputView = datePicker;
}

//代理方法
- (void)saveEvent{
    
    SZYearCheckItem *checkItem = [[SZYearCheckItem alloc] init];
    
//    NSInteger dateTime = [NSDate sinceDistantPastToDate:[NSDate dateFromString:time]];

    checkItem.ADate = [NSDate sinceDistantPastToDate:[NSDate dateFromString:self.detailView.yCheakADate.text]];
    checkItem.PDate = self.reminder.YCheckDate;
    checkItem.PDate_Save = [NSDate sinceDistantPastToDate:[NSDate dateFromString:self.detailView.yCheakPDate.text]];
    checkItem.UnitNo = self.UnitNo;
    
//    NSDateComponents *comps = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond)
//                        fromDate:[NSDate date]];
//    NSInteger hour = [comps hour];
//    NSInteger minute = [comps minute];
//    NSInteger second = [comps second];
//    checkItem.ADate += ((hour*60+minute)*60+second)*10000000;
    
    [SZTable_YearlyCheck storageYearlyCheck:checkItem];
    
    if (self.confirmActBlock) {
        self.confirmActBlock();
    }
    //返回上级页面
    [self.navigationController popViewControllerAnimated:YES];
}

@end
