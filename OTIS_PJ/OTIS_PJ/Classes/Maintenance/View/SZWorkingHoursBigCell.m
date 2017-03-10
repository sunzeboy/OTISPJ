//
//  SZWorkingHoursBigCell.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/16.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZWorkingHoursBigCell.h"
#import "UIView+Extension.h"
#import "SZInputWorkingHourViewController.h"

@interface SZWorkingHoursBigCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *laborName;

@property (weak, nonatomic) IBOutlet UITextField *pingri;
@property (weak, nonatomic) IBOutlet UITextField *pingrijiaban;
@property (weak, nonatomic) IBOutlet UITextField *shuangxiuri;
@property (weak, nonatomic) IBOutlet UITextField *shuangxiurijiaban;


@property (weak, nonatomic) IBOutlet UITextField *pingri2;
@property (weak, nonatomic) IBOutlet UITextField *pingrijiaban2;
@property (weak, nonatomic) IBOutlet UITextField *shuangxiuri2;
@property (weak, nonatomic) IBOutlet UITextField *shuangxiurijiaban2;

- (IBAction)deletAct:(UIButton *)sender;

@end


@implementation SZWorkingHoursBigCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CGRect rect = [[UIScreen mainScreen] bounds];
    UINavigationController *nav =  (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    SZInputWorkingHourViewController *vc = (SZInputWorkingHourViewController *)nav.topViewController;
    KMDatePicker *datePicker = [[KMDatePicker alloc]
                                initWithFrame:CGRectMake(0.0, 0.0, rect.size.width, 216.0)
                                delegate:vc
                                datePickerStyle:KMDatePickerStyleHourMinute];
    
    self.pingri.delegate = self;
    self.pingri.inputView = datePicker;
    
    self.pingrijiaban.delegate = self;
    self.pingrijiaban.inputView = datePicker;
    
    self.shuangxiuri.delegate = self;
    self.shuangxiuri.inputView = datePicker;
    
    self.shuangxiurijiaban.delegate = self;
    self.shuangxiurijiaban.inputView = datePicker;
    
    self.pingri2.delegate = self;
    self.pingri2.inputView = datePicker;
    
    self.pingrijiaban2.delegate = self;
    self.pingrijiaban2.inputView = datePicker;
    
    self.shuangxiuri2.delegate = self;
    self.shuangxiuri2.inputView = datePicker;
    
    self.shuangxiurijiaban2.delegate = self;
    self.shuangxiurijiaban2.inputView = datePicker;
    
    self.pingri.tag = 100;
    self.pingrijiaban.tag = 101;
    self.shuangxiuri.tag = 102;
    self.shuangxiurijiaban.tag = 103;
    self.pingri2.tag = 104;
    self.pingrijiaban2.tag = 105;
    self.shuangxiuri2.tag = 106;
    self.shuangxiurijiaban2.tag = 107;

}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.didClickedTFBlock) {
        self.didClickedTFBlock(textField);
    }
}


//创建可重用的cell对象
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"SZWorkingHoursBigCell";
    SZWorkingHoursBigCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SZWorkingHoursBigCell" owner:self options:nil] lastObject];
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
    self.shuangxiuri.text =item1.Hour2Str;
    self.shuangxiurijiaban.text =item1.Hour3Str;
    
    self.pingri2.text =item2.Hour1Str;
    self.pingrijiaban2.text = item2.Hour15Str;
    self.shuangxiuri2.text =item2.Hour2Str;
    self.shuangxiurijiaban2.text =item2.Hour3Str;


}



- (IBAction)deletAct:(UIButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock(self.labor);
    }
}
@end
