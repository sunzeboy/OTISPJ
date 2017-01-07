//
//  SZDuoxuanViewController.m
//  OTIS_PJ
//
//  Created by sunze on 16/7/21.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZDuoxuanViewController.h"
#import "SZAnnualInspectionTableViewCell.h"
#import "KMDatePicker.h"
#import "SZTable_YearlyCheck.h"
#import "CustomIOSAlertView.h"

@interface SZDuoxuanViewController ()<UITextFieldDelegate,KMDatePickerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *dateTF;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)saveAct:(id)sender;

@end

@implementation SZDuoxuanViewController
- (BOOL)shouldAutorotate{
    
    return NO;
}
- (NSMutableArray *)arraySelected
{
    if (_arraySelected ==nil) {
        _arraySelected = [NSMutableArray array];
    }
    return _arraySelected;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SZLocal(@"title.annualInspection");

    CGRect rect = [[UIScreen mainScreen] bounds];
    KMDatePicker *datePicker = [[KMDatePicker alloc]
                                initWithFrame:CGRectMake(0.0, 0.0, rect.size.width, 216.0)
                                delegate:self
                                datePickerStyle:KMDatePickerStyleYearMonthDay];
    datePicker.tag = 1111;
    self.dateTF.delegate = self;
    self.dateTF.inputView = datePicker;
}



#pragma mark - KMDatePickerDelegate
- (void)datePicker:(KMDatePicker *)datePicker didSelectDate:(KMDatePickerDateModel *)datePickerDate {
    
        NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@",
                             datePickerDate.year,
                             datePickerDate.month,
                             datePickerDate.day];
        self.dateTF.text = dateStr;
    
        
    
}

- (IBAction)saveAct:(id)sender {
//    SZYearCheckItem *checkItem = [[SZYearCheckItem alloc] init];
//    checkItem.ADate = self.detailView.yCheakADate.text.longLongValue;
//    checkItem.PDate = self.detailView.yCheakPDate.text.longLongValue;
//    checkItem.UnitNo = self.UnitNo;
    WEAKSELF
    if (self.dateTF.text.length) {
        
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:[NSString stringWithFormat:@"是否确认保存实际年检日期%@？",self.dateTF.text]
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            if(buttonIndex == 0){
                [SZTable_YearlyCheck storageYearlyChecks:weakSelf.arraySelected WithTime:weakSelf.dateTF.text];
                [weakSelf.navigationController popViewControllerAnimated:YES];
                if (self.confirmActBlock) {
                    self.confirmActBlock();
                }
            }
            [alertView close];
        };
        [alertView show];


    }else{
    
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:SZLocal(@"dialog.content.Please enter the actual annual inspection date!")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            [alertView close];
        };
        [alertView show];
        
    }
    
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arraySelected.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SZAnnualInspectionTableViewCell *cell;
    cell = [SZAnnualInspectionTableViewCell cellWithTableView:tableView];
    cell.szannual = self.arraySelected[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 81;
}

////move to detail
//- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//   
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [self.dateTF resignFirstResponder];

}


@end
