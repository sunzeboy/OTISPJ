//
//  SZWorkingHoursSmallCell.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/17.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZWorkingHoursSmallCell.h"
#import "UIView+Extension.h"
#import "SZInputWorkingHourViewController.h"

@interface SZWorkingHoursSmallCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *laborName;

@property (weak, nonatomic) IBOutlet UITextField *pingri;
@property (weak, nonatomic) IBOutlet UITextField *pingrijiaban;
@property (weak, nonatomic) IBOutlet UITextField *shuangxiuri;
@property (weak, nonatomic) IBOutlet UITextField *shuangxiurijiaban;
- (IBAction)deleteAct:(UIButton *)sender;

@end

@implementation SZWorkingHoursSmallCell

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
    self.pingri.tag = 100;
    
    self.pingrijiaban.delegate = self;
    self.pingrijiaban.inputView = datePicker;
    self.pingrijiaban.tag = 101;


    self.shuangxiuri.delegate = self;
    self.shuangxiuri.inputView = datePicker;
    self.shuangxiuri.tag = 102;

    self.shuangxiurijiaban.delegate = self;
    self.shuangxiurijiaban.inputView = datePicker;
    self.shuangxiurijiaban.tag = 103;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.didClickedTFBlock) {
        self.didClickedTFBlock(textField);
    }
}


//创建可重用的cell对象
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"SZWorkingHoursSmallCell";
    SZWorkingHoursSmallCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SZWorkingHoursSmallCell" owner:self options:nil] lastObject];
    }
    return cell;
    
}

-(void)setLabor:(SZLabor*)labor{
    //self.time1.text = labor.
    _labor = labor;

    self.laborName.text = labor.LaborName;
    
    SZLaborHoursItem *item1 = labor.item1;
    
    self.pingri.text =item1.Hour1Str;
    self.pingrijiaban.text = item1.Hour15Str;
    self.shuangxiuri.text =item1.Hour2Str;
    self.shuangxiurijiaban.text =item1.Hour3Str;
    
}
- (IBAction)deleteAct:(UIButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock(self.labor);
    }
}
@end
