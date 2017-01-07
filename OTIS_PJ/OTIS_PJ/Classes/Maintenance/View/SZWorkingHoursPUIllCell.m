//
//  SZWorkingHoursPUIllCell.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/28.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZWorkingHoursPUIllCell.h"
#import "UIView+Extension.h"
#import "SZInputWorkingHourViewController.h"

@interface SZWorkingHoursPUIllCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *puiNo;
@property (weak, nonatomic) IBOutlet UITextField *pingri;
@property (weak, nonatomic) IBOutlet UITextField *pingrijiaban;

@property (weak, nonatomic) IBOutlet UITextField *shuangxiurijiaban;
@property (weak, nonatomic) IBOutlet UITextField *guodingjiaban;
@property (weak, nonatomic) IBOutlet UITextField *pingri2;
@property (weak, nonatomic) IBOutlet UITextField *pingrijiaban2;
@property (weak, nonatomic) IBOutlet UITextField *shuangxiurijiaban2;
@property (weak, nonatomic) IBOutlet UITextField *guodingjiaban2;
@property (weak, nonatomic) IBOutlet UILabel *laborName;
- (IBAction)deleteAct:(UIButton *)sender;

@end


@implementation SZWorkingHoursPUIllCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    UINavigationController *nav =  (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    SZInputWorkingHourViewController *vc = (SZInputWorkingHourViewController *)nav.topViewController;
    KMDatePicker *datePicker = [[KMDatePicker alloc]
                                initWithFrame:CGRectMake(0.0, 0.0, rect.size.width, 216.0)
                                delegate:vc
                                datePickerStyle:KMDatePickerStyleHourMinute];
    self.puiNo.delegate = self;
    [self.puiNo addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.pingri.delegate = self;
    self.pingri.inputView = datePicker;
    
    self.pingrijiaban.delegate = self;
    self.pingrijiaban.inputView = datePicker;
    
    self.shuangxiurijiaban.delegate = self;
    self.shuangxiurijiaban.inputView = datePicker;
    
    self.guodingjiaban.delegate = self;
    self.guodingjiaban.inputView = datePicker;
    
    self.pingri2.delegate = self;
    self.pingri2.inputView = datePicker;
    
    self.pingrijiaban2.delegate = self;
    self.pingrijiaban2.inputView = datePicker;
    
    self.shuangxiurijiaban2.delegate = self;
    self.shuangxiurijiaban2.inputView = datePicker;
    
    self.guodingjiaban2.delegate = self;
    self.guodingjiaban2.inputView = datePicker;
    
    self.pingri.tag = 100;
    self.pingrijiaban.tag = 101;
    self.shuangxiurijiaban.tag = 102;
    self.guodingjiaban.tag = 103;
    self.pingri2.tag = 104;
    self.pingrijiaban2.tag = 105;
    self.shuangxiurijiaban2.tag = 106;
    self.guodingjiaban2.tag = 107;
}
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == self.puiNo) {
        if (textField.text.length > 12) {
            textField.text = [textField.text substringToIndex:12];
        }
    }
}
//创建可重用的cell对象
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"SZWorkingHoursPUIllCell";
    SZWorkingHoursPUIllCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SZWorkingHoursPUIllCell" owner:self options:nil] lastObject];
    }
    return cell;
    
}

-(void)setLabor:(SZLabor*)labor{
    //self.time1.text = labor.
    _labor = labor;
    self.laborName.text = labor.LaborName;
    SZLaborHoursItem *item1 = labor.item1;
    SZLaborHoursItem *item2 = labor.item2;
    
    self.pingri.text =item1.Hour1Str;
    self.pingrijiaban.text = item1.Hour15Str;
    self.shuangxiurijiaban.text =item1.Hour2Str;
    self.guodingjiaban.text =item1.Hour3Str;
    
    self.pingri2.text =item2.Hour1Str;
    self.pingrijiaban2.text = item2.Hour15Str;
    self.shuangxiurijiaban2.text =item2.Hour2Str;
    self.guodingjiaban2.text =item2.Hour3Str;
    
    if (item1.PUINo) {
        self.puiNo.text = item1.PUINo;
    }
}


- (IBAction)deleteAct:(UIButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock(self.labor);
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.puiNo resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (self.didClickedTFBlock) {
        self.didClickedTFBlock(textField);
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.didClickedTFBlock) {
        self.didClickedTFBlock(textField);
    }
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField == self.puiNo) {
        _labor.item1.PUINo = textField.text;
    }

    return YES;
}

@end
