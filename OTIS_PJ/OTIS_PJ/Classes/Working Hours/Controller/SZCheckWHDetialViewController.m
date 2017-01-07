//
//  SZCheckWHDetialViewController.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZCheckWHDetialViewController.h"

#import "SZCheckLookTableViewDetialCell.h"
#import "NSDate+Extention.h"
#import "CustomIOSAlertView.h"
#import "SZTable_LaborType.h"

@interface SZCheckWHDetialViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *unitNo;
@property (weak, nonatomic) IBOutlet UILabel *jihuariqi;
@property (weak, nonatomic) IBOutlet UILabel *totalTime;
@property (weak, nonatomic) IBOutlet UITextField *dateTF;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UITextField *tf;
- (IBAction)saveAct:(UIButton *)sender;
@property (nonatomic, assign) NSInteger selectedRow;

//@property (nonatomic , strong) SZCheckLookModel *modelAll;
@property (nonatomic , strong) NSMutableArray *deleteArray;

@property (nonatomic , assign) float initialTime;

@end

@implementation SZCheckWHDetialViewController
- (BOOL)shouldAutorotate{
    
    return NO;
}
- (IBAction)saveBtnClick:(UIButton *)sender {
    
}



-(NSMutableArray *)deleteArray{
    if (_deleteArray ==nil) {
        _deleteArray = [NSMutableArray array];
    }
    return _deleteArray;
}

#pragma mark - KMDatePickerDelegate
- (void)datePicker:(KMDatePicker *)datePicker didSelectDate:(KMDatePickerDateModel *)datePickerDate {
    if (datePicker.tag == 10000) {
        NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@",
                             datePickerDate.year,
                             datePickerDate.month,
                             datePickerDate.day
                             ];
        self.dateTF.text = dateStr;

    }else{
        
        
        NSString *dateStr = [NSString stringWithFormat:@"%@:%@",
                             datePickerDate.hour,
                             datePickerDate.minute];
//        NSString *dateF = [NSString stringWithFormat:@"%.2f",
//                           (float)(datePickerDate.minute.floatValue/60.00)];
//        NSString *dateH = [NSString stringWithFormat:@"%@",datePickerDate.hour];
//        float time = dateF.floatValue + dateH.intValue;
//        NSString *strDate = [NSString stringWithFormat:@"%.2f",time];
        self.tf.text = dateStr;
        
        SZLaborHoursItem *gb = self.model.laborHours[self.selectedRow];
        
        switch (self.tf.tag) {
            case 100:
//                gb.Hour1Rate = strDate.floatValue;
                gb.Hour1Str = dateStr;
                break;
            case 101:
//                gb.Hour15Rate = strDate.floatValue;
                gb.Hour15Str = dateStr;
                
                break;
            case 102:
//                gb.Hour2Rate = strDate.floatValue;
                gb.Hour2Str = dateStr;
                
                break;
            case 103:
//                gb.Hour3Rate = strDate.floatValue;
                gb.Hour3Str = dateStr;
                
                break;
                
            default:
                break;
        }
        
       
        self.totalTime.text = [NSString stringWithFormat:@"%@：%.2f",SZLocal(@"time.Total working hours"),self.model.gongshi];
    }
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SZLocal(@"time.Time modification");
    [self setBackItem];
    [self setUpUI];
    [self setExtraCellLineHidden:self.tableView];
}

-(void)setBackItem{
    
    UIButton* backBtn=[[UIButton alloc] init];
    backBtn.bounds=CGRectMake(0, 0, 50, 30);
    backBtn.imageEdgeInsets=UIEdgeInsetsMake(0, -10, 0, 0);
    backBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitle:SZLocal(@"btn.title.back") forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}


-(void)back{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                 dialogContents:SZLocal(@"dialog.content.Work change content is not saved, whether to return?")
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        if(buttonIndex == 0){
            [self.navigationController popViewControllerAnimated:YES];
            [alertView close];
        }else if(buttonIndex == 1){
            [alertView close];
        }
    };
    [alertView show];
}

-(void)setUpUI
{
    if ([self.model.unitNo isEqualToString:@""]||self.model.unitNo==nil) {
        self.unitNo.hidden=YES;
        self.jihuariqi.frame=CGRectMake(self.jihuariqi.frame.origin.x, self.jihuariqi.frame.origin.y-20, self.jihuariqi.frame.size.width, self.jihuariqi.frame.size.height);
    }
    self.unitNo.text = [NSString stringWithFormat:@"%@：%@",SZLocal(@"dialog.title.Elevator number"),self.model.unitNo];
    self.jihuariqi.text = [NSString stringWithFormat:@"%@：%@",SZLocal(@"btn.title.Date"),self.model.createDate];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    if (!self.model.GenerateDate) {
        self.dateTF.text = [NSDate currentDate];
    }else{
        self.dateTF.text = self.model.GenerateDate;

    }
    KMDatePicker *datePicker = [[KMDatePicker alloc]
                                initWithFrame:CGRectMake(0.0, 0.0, rect.size.width, 216.0)
                                delegate:self
                                datePickerStyle:KMDatePickerStyleYearMonthDay];
    datePicker.tag = 10000;
    self.dateTF.delegate = self;
    self.dateTF.inputView = datePicker;
    
    self.initialTime = self.model.gongshi;

    self.totalTime.text = [NSString stringWithFormat:@"%@：%.2f",SZLocal(@"time.Total working hours"),self.model.gongshi];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 102;
}

//返回每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.laborHours.count;

}
//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    SZCheckLookTableViewDetialCell *cell = [SZCheckLookTableViewDetialCell cellWithTableView:tableView];
    SZLaborHoursItem *item = self.model.laborHours[indexPath.row];
    
    cell.item = item;
    cell.didClickedTFBlock = ^(UITextField* textField){
     //删除选中的row
        weakSelf.tf = textField;
        weakSelf.selectedRow = indexPath.row;
    };
    
    cell.didDeleteClick=^(SZLaborHoursItem *itemDelete){
        
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:SZLocal(@"dialog.content.confirmDelWorkinghour")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
        
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            if (buttonIndex == 0) {
                
                SZLaborHoursItem *itemOther ;
                
                for (SZLaborHoursItem *otherItem in weakSelf.model.laborHours) {
                    int otherLaborTypeId = [SZTable_LaborType quaryOtherLaborTypeIDWithLaborTypeID:itemDelete.LaborTypeId];
                    if (otherItem.LaborTypeId == otherLaborTypeId && itemDelete.GroupID == otherItem.GroupID) {
                        itemOther = otherItem;
                    }
                }
                [weakSelf.model.laborHours removeObject:itemDelete];
                
                [weakSelf.deleteArray addObject:itemDelete];
                if (itemOther) {
                    [weakSelf.model.laborHours removeObject:itemOther];
                    [weakSelf.deleteArray addObject:itemOther];
                }
                weakSelf.totalTime.text = [NSString stringWithFormat:@"%@：%.2f",SZLocal(@"time.Total working hours"),self.model.gongshi];
                [weakSelf.tableView reloadData];
            }
            [alertView close];
        };
        [alertView show];
       
    };
    
    return cell;
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.dateTF = textField;
}

/**
 * 判断选择的日期是否在范围内。在范围内返回输入的日期，不在范围内返回当天日期。
 */
-(NSString *)inRangeDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString] || [dateString isEqualToString:yesterdayString]) {
        return dateString;
    } else {
        return todayString;
    }
}


/**
 * 判断选择的日期是否在范围内。在范围内返回YES，不在范围内返回NO。
 *
 */
-(BOOL)dateIsRange:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString] || [dateString isEqualToString:yesterdayString]) {
        return YES;
    } else {
        return NO;
    }
}


- (IBAction)saveAct:(UIButton *)sender {

    
    // 判断日期是否超出范围
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:[_dateTF.text stringByAppendingString:@" 08:00:00" ]];
    if (![self dateIsRange:date]) {
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.fillWorkingHour")
                                                                                     dialogContents:SZLocal(@"dialog.content.dateIsOutOfRange")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            
            
            [alertView close];
            _dateTF.text = [self inRangeDate:date];
        };
        [alertView show];
        return;
    }

    
    /**
     0:正常
     1:主工时为0
     2:总工时>=8
     3.总工时>=24
     */
    switch ([self tipType]) {
        case 0:
            [self tip0];
            break;
        case 1:
            [self tip1];
            break;
        case 2:
            [self tip2];
            break;
        case 3:
            [self tip3];
            break;
        default:
            break;
    }
}

-(void)tip0{
    
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                 dialogContents:SZLocal(@"dialog.content.Are the changes determined?")
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
    
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        if (buttonIndex == 0) {
            
            [SZTable_LaborHours updateLaborHoursItemsWithCheckLookModel:self.model andDeleteArray:self.deleteArray andDate:self.dateTF.text];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        [alertView close];
    };
    [alertView show];
  
    
}

-(void)tip1{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                 dialogContents:SZLocal(@"dialog.content.gongshiweitianxie")
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        [alertView close];
    };
    [alertView show];
    
}

-(void)tip2{
    
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                 dialogContents:SZLocal(@"dialog.content.Total working hours have been more than 8 hours!")
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
    
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        if (buttonIndex == 0) {
            
            [self tip0];
        }
        [alertView close];
    };
    [alertView show];
    
    
}


-(void)tip3{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                 dialogContents:SZLocal(@"dialog.content.Today, more than 24 hours of processing time, the work can not be saved.")
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        [alertView close];
    };
    [alertView show];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

/**
 0:正常
 *  1:主工时为0
 2:总工时>=8
 3.总工时>=24
 */
-(int)tipType{
    if (self.model.laborHours.count) {
        SZLaborHoursItem *labor = self.model.laborHours[0];
        if (labor.gongshi == 0) {
            return 1;
        }
        
        float total = [SZTable_LaborHours quaryTotlaTimesWithDate:[NSDate currentDate]];
        float thisTotal = [[[self.totalTime.text componentsSeparatedByString:@"："] lastObject] floatValue];
        if (total-self.initialTime+thisTotal >= 24) {
            return 3;
        }

        if (self.model.gongshi>7.99 && self.model.gongshi<24) {
            return 2;
        }
        
       
        return 0;
    }
    return 0;
}


@end
