//
//  SZCheckLookTableViewDetialCell.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZCheckLookTableViewDetialCell.h"
#import "SZCheckWHDetialViewController.h"
#import "KMDatePicker.h"
#import "SZTable_LaborType.h"

@interface SZCheckLookTableViewDetialCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *laborName;

@property (weak, nonatomic) IBOutlet UITextField *pingri;
@property (weak, nonatomic) IBOutlet UITextField *pingrijiaban;
@property (weak, nonatomic) IBOutlet UITextField *shuangxiuri;
@property (weak, nonatomic) IBOutlet UITextField *guodingjiaban;
@property (weak, nonatomic) IBOutlet UITextField *puiTF;


@end
@implementation SZCheckLookTableViewDetialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    CGRect rect = [[UIScreen mainScreen] bounds];
    UINavigationController *nav =  (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    SZCheckWHDetialViewController *vc = (SZCheckWHDetialViewController *)nav.topViewController;
    KMDatePicker *datePicker = [[KMDatePicker alloc]
                                initWithFrame:CGRectMake(0.0, 0.0, rect.size.width, 216.0)
                                delegate:vc
                                datePickerStyle:KMDatePickerStyleHourMinute];

    self.pingri.delegate = self;
    self.pingri.inputView = datePicker;
    self.pingri.tag = 100;
    
    self.pingrijiaban.delegate = self;
    self.pingrijiaban.inputView = datePicker;
    self.pingrijiaban.tag = 101;
    
    
    self.shuangxiuri.delegate = self;
    self.shuangxiuri.inputView = datePicker;
    self.shuangxiuri.tag = 102;
    
    self.guodingjiaban.delegate = self;
    self.guodingjiaban.inputView = datePicker;
    self.guodingjiaban.tag = 103;
    self.puiTF.delegate = self;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.didClickedTFBlock) {
        self.didClickedTFBlock(textField);
    }
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"SZCheckLookTableViewDetialCell";
    SZCheckLookTableViewDetialCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SZCheckLookTableViewDetialCell" owner:self options:nil] lastObject];
    }
    return cell;
}

-(void)setItem:(SZLaborHoursItem *)item{
    _item = item;
    
    if (item.LaborTypeId == 1) {
        self.laborName.text = SZLocal(@"dialog.title.Normal maintenance");
        self.deleteBtn.hidden = YES;
    }else if (item.LaborTypeId == 2){
        self.laborName.text = SZLocal(@"dialog.title.Normal road maintenance");
        self.deleteBtn.hidden = YES;

    }else{
      SZLabor *labor = [SZTable_LaborType quaryLaborWithLaborTypeID:item.LaborTypeId];
        if (labor.LaborName) {
            self.laborName.text = labor.LaborName;
        }else{
            SZLabor *labor2 = [SZTable_LaborType quaryLutuLaborWithLaborTypeID:item.LaborTypeId];
            self.laborName.text = labor2.LaborName;
        }
    }
    
    self.pingri.text = item.Hour1Str;
    self.pingrijiaban.text = item.Hour15Str;
    self.shuangxiuri.text = item.Hour2Str;
    self.guodingjiaban.text = item.Hour3Str;
    if (item.PUINo) {
        self.puiTF.text = item.PUINo;
    }else{
        self.puiTF.hidden = YES;
    }
}
- (IBAction)deleteClick:(id)sender {
    if (self.didDeleteClick) {
        self.didDeleteClick(self.item);
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.puiTF resignFirstResponder];
    return YES;
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    if (self.didClickedTFBlock) {
//        self.didClickedTFBlock(textField);
//    }
//}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField == self.puiTF) {
        _item.PUINo = textField.text;
    }
    return YES;
}


@end
