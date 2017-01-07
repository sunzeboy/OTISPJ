//
//  SZInputWorkingHourNonProductiveViewController.m
//  OTIS_PJ
//
//  Created by zhangyang on 16/6/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZInputWorkingHourNonProductiveViewController.h"
#import "SZNavigationController.h"
#import "MASConstraintMaker.h"
#import "View+MASAdditions.h"
#import "SZBottomSaveOperationView.h"
#import "KMDatePicker.h"
#import "CustomIOSAlertView.h"
#import "NSDate+Extention.h"
#import "SZBottomMainView.h"

@interface SZInputWorkingHourNonProductiveViewController ()<UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic , strong) SZLabor *labor;

@property (nonatomic , strong) UITextView *remarksTV;

@property (nonatomic, strong) NSMutableArray *types;

@property (nonatomic , strong)  SZBottomSaveOperationView *operationView;

@property (strong, nonatomic)  UITextField *dateTF;

@property (strong, nonatomic)  UITextField *timeTF;

@property(nonatomic,strong) UIView *subTitleView;

@property(nonatomic,assign)BOOL dateIsOver;

@property(nonatomic,strong) UILabel *totalHourText;

@property (nonatomic , assign) float initialTime;

@property (nonatomic , strong)  SZBottomMainView *bottomMainView;

@end

@implementation SZInputWorkingHourNonProductiveViewController

-(SZLaborHoursItem *)item{
    if (_item == nil) {
        _item = [[SZLaborHoursItem alloc] init];
    }
    return _item;
}


#pragma mark - KMDatePickerDelegate
- (void)datePicker:(KMDatePicker *)datePicker didSelectDate:(KMDatePickerDateModel *)datePickerDate {
    
    if (datePicker.tag ==1111) {
        NSString *dateStr = [NSString stringWithFormat:@"%@/%@/%@",
                             datePickerDate.year,
                             datePickerDate.month,
                             datePickerDate.day];
        NSString *dateStr1 = [NSString stringWithFormat:@"%@%@%@",
                             datePickerDate.year,
                             datePickerDate.month,
                             datePickerDate.day];
        [self judgeDateIsOver:dateStr nowDate:dateStr1];
        
    }else{
        self.hasInput = YES;
        
        NSString *dateStr = [NSString stringWithFormat:@"%@:%@",
                             datePickerDate.hour,
                             datePickerDate.minute];
//        NSString *dateF = [NSString stringWithFormat:@"%.2f",
//                           (float)(datePickerDate.minute.floatValue/60.00)];
//        NSString *dateH = [NSString stringWithFormat:@"%@",datePickerDate.hour];
//        float time = dateF.floatValue + dateH.intValue;
//        NSString *strDate = [NSString stringWithFormat:@"%.2f",time];
        SZLog(@"------------%@",dateStr);
        self.timeTF.text = dateStr;

        switch (self.timeTF.tag) {
            case 100:
                self.item.Hour1Str = dateStr;
                break;
            case 101:
                self.item.Hour15Str =dateStr;
                break;
            case 102:
                self.item.Hour2Str = dateStr;
                break;
            case 103:
                self.item.Hour3Str = dateStr;
                break;
            default:
                break;
        }
        
        self.totalHourText.text = [NSString stringWithFormat:@"%@：%.2f",SZLocal(@"time.Total working hours"),self.item.gongshi];
    }
}

-(void)judgeDateIsOver:(NSString*)date1 nowDate:(NSString*)date2{
    
    self.dateTF.text = [date1 stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    self.item.GenerateDate = date1;

    
    
    
    NSDate *date = [NSDate dateFromString:date1];
    
    
    // begin sunze
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [NSDate date];
    long inputLong =[date timeIntervalSince1970 ];
    long todayLong =[today timeIntervalSince1970 ];
    
    int day = (int)(todayLong/secondsPerDay);
    int dayFor10 = (int)(todayLong/secondsPerDay +11);
    int inputDay = (int )inputLong/secondsPerDay;

    if((inputDay>day && inputDay<dayFor10)||[NSDate isDateThisWeek:date]){
        _dateIsOver=NO;
        return ;
    }
    // end sunze
    
    
    
//    NSTimeInterval interval = [date timeIntervalSinceNow];
//    int day = (interval/24/60/60) ;
//    if (day >9||count<modayInteger) {
//        _dateIsOver=YES;
//    }else{
//        _dateIsOver=NO;
//    }
    
   _dateIsOver = YES;

    
}




////1 懒加载
- (SZLabor *)labor
{
    if (_labor ==nil) {
        SZNavigationController *nav = (SZNavigationController*)self.navigationController;
        if (self.model) {
            _labor = [SZTable_LaborType quaryLaborWithLaborTypeID:self.LaborTypeID];

        }else{
            _labor = [SZTable_LaborType quaryLaborWithLaborTypeID:nav.laborTypeID==0?1:nav.laborTypeID];

        }
    }
    return _labor;
}

//1 懒加载
- (NSMutableArray *)types
{
    if (_types ==nil) {
        _types = [NSMutableArray arrayWithObject:self.labor];
    }
    return _types;
}

-(SZBottomSaveOperationView *)operationView{
    
    if(_operationView ==nil){
        _operationView =[SZBottomSaveOperationView loadSZBottomSaveOperationView];
        _operationView.frame = CGRectMake(0,SCREEN_HEIGHT-OTIS_BottomOperationH, SCREEN_WIDTH, OTIS_BottomOperationH);
        [self.view addSubview:_operationView];
    }
    return _operationView;
    
}

-(SZBottomMainView *) bottomMainView{
    
    if(_bottomMainView ==nil){
        _bottomMainView =[SZBottomMainView loadSZBottomMainView];
        _bottomMainView.frame = CGRectMake(0,SCREEN_HEIGHT-OTIS_BottomOperationH, SCREEN_WIDTH, OTIS_BottomOperationH);
        [_bottomMainView.findBtn setImage:[UIImage imageNamed:@"delete"] forState:0];
        [_bottomMainView.findBtn setTitle:SZLocal(@"btn.title.Delete") forState:0];
        [_bottomMainView.scanBtn setImage:[UIImage imageNamed:@"btn_save_blue"] forState:0];
        [_bottomMainView.scanBtn setTitle:SZLocal(@"btn.title.save") forState:0];
        if (self.model) {
            [self.view addSubview:_bottomMainView];
        }
    }
    return _bottomMainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self initNav];
    
    [self setSubTitleViewWithTitleDate:self.model.createDate totalHours:@"0"];
    // Do any additional setup after loading the view.
    [self operationView];
    [self setNavItem];
    
    if (self.model) {
        self.title = [NSString stringWithFormat:@"%@－%@",SZLocal(@"time.Time modification"),self.labor.LaborName];
        NSString *strDate = self.model.GenerateDate;
        self.dateTF.text = [strDate stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        
    }else{
        self.title = [NSString stringWithFormat:@"%@－%@",SZLocal(@"title.WorkingHoursViewController"), self.labor.LaborName];
        self.dateTF.text = [NSDate currentDate];

    }
    
    WEAKSELF
    self.operationView.confirmActBlock = ^(UIButton *btn) {
        [weakSelf save];
    };
    
    self.bottomMainView.findBtnClickBlock = ^(UIButton *btn) {
        [weakSelf delete];
    };
    self.bottomMainView.scanBtnClickBlock = ^(UIButton *btn) {
        [weakSelf save];
    };
}

-(void)delete{
    
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                 dialogContents:[NSString stringWithFormat:@"是否确认删除%@工时？",self.labor.LaborName]
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
    WEAKSELF
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        if (buttonIndex == 0) {
         
            SZLaborHoursItem *item = weakSelf.model.laborHours[0];
            [SZTable_LaborHours deleteFeiProductiveWithCreateTime:item.CreateTime];
            [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
        [alertView close];
    };
    [alertView show];
    
   
    

}

-(void)setNavItem{
    
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
    [self.view endEditing:YES];
    
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.workingHourSave")
                                                                                 dialogContents:SZLocal(@"dialog.content.workhourContentDoNotSave")
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

-(void)save {
    
    if (_dateIsOver) {
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:SZLocal(@"dialog.content.Date is out of range, click OK to set the current date!")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            [alertView close];
            self.dateTF.text = [self getCurrentDate] ;
            self.item.GenerateDate = [self getCurrentDate];
            _dateIsOver=NO;
        };
        [alertView show];
        return;
    }
    
    // 判断工时是否输入。
    if (!self.hasInput) {
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:SZLocal(@"dialog.content.gongshiweitianxie")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            [alertView close];
        };
        [alertView show];
        return;
    }
    
    // 判断备注文字长度。
    if ([self convertToInt:self.remarksTV.text] > 100) {
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.fillWorkingHour")
                                                                                     dialogContents:SZLocal(@"dialog.content.remarkMoreThan50")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            [alertView close];
        };
        [alertView show];
        return;
    }
    /**
     0:正常
     1:主工时为0
     3.总工时>=24
     */
    switch ([self tipType]) {
        case 1:
            [self tip1];
            return;
        case 3:
            [self tip3];
            return;
        default:
            break;
    }
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                 dialogContents:[NSString stringWithFormat:@"是否确认保存%@工时？",self.labor.LaborName]
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
    WEAKSELF
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        if (buttonIndex == 0) {
            weakSelf.item.LaborTypeId = weakSelf.LaborTypeID;
            weakSelf.item.GenerateDate = [self.dateTF.text stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
            if (weakSelf.model) {
                [SZTable_LaborHours updateFeiShengchanLaborHoursItems:weakSelf.item];
                
            }else{
                [SZTable_LaborHours storageFeiShengchanLaborHoursItems:weakSelf.item];
            }
            
            [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
        [alertView close];
    };
    [alertView show];
    return;
}



/**
 0:正常
 *  1:主工时为0
 2:总工时>=8
 3.总工时>=24
 */
-(int)tipType{
    

    
    float total = [SZTable_LaborHours quaryTotlaTimesWithDate:[NSDate currentDate]];
    float thisTotal = [[[self.totalHourText.text componentsSeparatedByString:@"："] lastObject] floatValue];
    if (total-self.initialTime+thisTotal >= 24) {
        return 3;
    }

    
    if (self.item.gongshi == 0) {
        return 1;
    }

    
    return 0;
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

//-(void)tip2{
//    
//    NSString *strNO ;
//    if (self.item.UnitNo) {
//        strNO =[NSString stringWithFormat:@"电梯%@的总工时已超过8小时!",self.item.UnitNo];
//    }else{
//        strNO = @"电梯的总工时已超过8小时!";
//    }
//    
//    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
//                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
//                                                                                 dialogContents:strNO
//                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
//    
//    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
//        if (buttonIndex == 0) {
//            
//            [self tip0];
//        }
//        [alertView close];
//    };
//    [alertView show];
//    
//    
//}



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
// Height 80
- (void) setSubTitleViewWithTitleDate :(NSString *)subTitleDate  totalHours : (NSString *)totalHours {
    
//    UIScrollView* backScrollview=[[UIScrollView alloc] initWithFrame:self.view.bounds];
//    backScrollview.backgroundColor=[UIColor whiteColor];
//    backScrollview.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.5);
//    self.view=backScrollview;
    
    
    
    UIView *subTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 80)];
    subTitleView.backgroundColor = [UIColor colorWithRed:3.0f/255.0f green:96.0f/255.0f blue:169.0f/255.0f alpha:1.0f];
    self.subTitleView=subTitleView;
    // 日期内容
    UILabel *subDateText = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, SCREEN_WIDTH - 80, 20)];
    if ([subTitleDate isEqualToString:@""]||subTitleDate==nil) {
        subDateText.text =[NSString stringWithFormat:@"%@：%@",SZLocal(@"btn.title.Date"),[NSDate currentDate]];
    }else{
        subDateText.text =[NSString stringWithFormat:@"%@：%@",SZLocal(@"btn.title.Date"),subTitleDate];
    }
    subDateText.font =[UIFont fontWithName:@"Microsoft YaHei" size:16];
    subDateText.textAlignment = NSTextAlignmentLeft;
    subDateText.textColor = [UIColor whiteColor];

    // 总工时内容
    UILabel *totalHourText = [[UILabel alloc] initWithFrame:CGRectMake(20, 47, SCREEN_WIDTH - 80, 20)];
    totalHourText.text =[NSString stringWithFormat:@"%@：%.2f",SZLocal(@"time.Total working hours"),self.item.gongshi];
    totalHourText.font =[UIFont fontWithName:@"Microsoft YaHei" size:16];
    totalHourText.textAlignment = NSTextAlignmentLeft;
    totalHourText.textColor = [UIColor whiteColor];
    self.totalHourText = totalHourText;
    
    self.initialTime = self.item.gongshi;

    [subTitleView addSubview:subDateText];
    [subTitleView addSubview:totalHourText];
    [self.view addSubview:subTitleView];
    self.initialTime = self.item.gongshi;
    // 标题下白色部分
    int padding = 10;
    UIView *contentsview = UIView.new;
    contentsview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentsview];
    
    [contentsview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subTitleView.mas_bottom); //with with
        make.left.equalTo(self.view.mas_left); //without with
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    UILabel *dateLabel = [[UILabel alloc]init];
    dateLabel.textAlignment = NSTextAlignmentLeft;
    dateLabel.text = SZLocal(@"btn.title.Date");
    [contentsview addSubview:dateLabel];

    //with is semantic and option
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentsview.mas_top).offset(padding); //with with
        make.left.equalTo(contentsview.mas_left).offset(padding); //without with
        make.right.equalTo(contentsview.mas_right).offset(-padding);
        make.height.equalTo(@(padding *2));
    }];
    KMDatePicker *datePicker = [[KMDatePicker alloc]
                                initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 216.0)
                                delegate:self
                                datePickerStyle:KMDatePickerStyleYearMonthDay];
    datePicker.tag = 1111;
    UITextField *dateField = UITextField.new;
    dateField.borderStyle = UITextBorderStyleRoundedRect; //外框类型
    dateField.text = [self getCurrentDate];
    dateField.inputView = datePicker;
    self.dateTF = dateField;
    self.dateTF.tag = 1111;
    
    UILabel *infoLabel = UILabel.new;
    infoLabel.text =[NSString stringWithFormat:@"(%@)",SZLocal(@"dialog.content.When the week or the next 10 days")];
    infoLabel.textColor = [UIColor colorWithHexString:@"124183"];
    
    [contentsview addSubview:dateField];
    [contentsview addSubview:infoLabel];
    [dateField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLabel.mas_bottom).offset(padding);
        make.left.equalTo(contentsview.mas_left).offset(padding);
        make.right.equalTo(infoLabel.mas_left).offset(-padding*2);
        make.width.equalTo(@130);
        make.height.equalTo(@20);
    }];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLabel.mas_bottom).offset(padding);
        make.right.equalTo(contentsview.mas_right).offset(-padding);
        make.height.equalTo(@20);
    }];
    UIView *lineView = UIView.new;
    lineView.backgroundColor = [UIColor lightGrayColor];
    [contentsview addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateField.mas_bottom).offset(padding);
        make.left.equalTo(contentsview.mas_left).offset(padding);
        make.right.equalTo(contentsview.mas_right).offset(-padding);
        make.height.equalTo(@1);
    }];
    
    UILabel * titleLabel = UILabel.new;
    titleLabel.text = [NSString stringWithFormat:@"%@工时",self.labor.LaborName];
    [contentsview addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(padding);
        make.left.equalTo(contentsview.mas_left).offset(padding);
        make.right.equalTo(contentsview.mas_right).offset(-padding);
        make.height.equalTo(@30);
    }];
    UILabel *weekdayLabel = UILabel.new;
    UILabel *weekdayOvertimeLabel = UILabel.new;
    UILabel *weekendOvertimeLabel = UILabel.new;
    UILabel *holidayOvertimeLabel = UILabel.new;
    
    weekdayLabel.text = SZLocal(@"dialog.content.X1 weekdays");
    weekdayOvertimeLabel.text = SZLocal(@"dialog.content.X1.5 overtime on weekdays");
    weekendOvertimeLabel.text = SZLocal(@"dialog.content.X2 weekend overtime");
    holidayOvertimeLabel.text = SZLocal(@"dialog.content.X3 national day overtime");
    
    weekdayLabel.font = [UIFont fontWithName:@"Microsoft YaHei" size:15];
    weekdayOvertimeLabel.font = [UIFont fontWithName:@"Microsoft YaHei" size:15];
    weekendOvertimeLabel.font = [UIFont fontWithName:@"Microsoft YaHei" size:15];
    holidayOvertimeLabel.font = [UIFont fontWithName:@"Microsoft YaHei" size:15];
    
    weekdayLabel.textColor = [UIColor colorWithHexString:@"124183"];
    weekdayOvertimeLabel.textColor = [UIColor colorWithHexString:@"124183"];
    weekendOvertimeLabel.textColor = [UIColor colorWithHexString:@"124183"];
    holidayOvertimeLabel.textColor = [UIColor colorWithHexString:@"124183"];
    
    weekdayLabel.textAlignment = NSTextAlignmentRight;
    weekdayOvertimeLabel.textAlignment = NSTextAlignmentRight;
    weekendOvertimeLabel.textAlignment = NSTextAlignmentRight;
    holidayOvertimeLabel.textAlignment = NSTextAlignmentRight;
    
    [contentsview addSubview:weekdayLabel];
    [contentsview addSubview:weekdayOvertimeLabel];
    [contentsview addSubview:weekendOvertimeLabel];
    [contentsview addSubview:holidayOvertimeLabel];

    
    KMDatePicker *hmPicker = [[KMDatePicker alloc]
                                initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 216.0)
                                delegate:self
                                datePickerStyle:KMDatePickerStyleHourMinute];
    
    UITextField *weekdayTF = UITextField.new;
    UITextField *weekdayOvertimeTF = UITextField.new;
    UITextField *weekendOvertimeTF = UITextField.new;
    UITextField *holidayOvertimeTF = UITextField.new;
    
    //weekdayTF.delegate = self;
    weekdayTF.inputView = hmPicker;
    weekdayOvertimeTF.inputView = hmPicker;
    weekendOvertimeTF.inputView = hmPicker;
    holidayOvertimeTF.inputView = hmPicker;
    
    weekdayTF.delegate = self;
    weekdayOvertimeTF.delegate = self;
    weekendOvertimeTF.delegate = self;
    holidayOvertimeTF.delegate = self;
    
    weekdayTF.borderStyle = UITextBorderStyleRoundedRect;         //外框类型
    weekdayOvertimeTF.borderStyle = UITextBorderStyleRoundedRect; //外框类型
    weekendOvertimeTF.borderStyle = UITextBorderStyleRoundedRect; //外框类型
    holidayOvertimeTF.borderStyle = UITextBorderStyleRoundedRect; //外框类型
    
    SZLaborHoursItem *item = [self.model.laborHours lastObject];
    
    weekdayTF.font = [UIFont fontWithName:@"Microsoft YaHei" size:14.0];
    weekdayOvertimeTF.font = [UIFont fontWithName:@"Microsoft YaHei" size:14.0];
    weekendOvertimeTF.font = [UIFont fontWithName:@"Microsoft YaHei" size:14.0];
    holidayOvertimeTF.font = [UIFont fontWithName:@"Microsoft YaHei" size:14.0];
    
    if (item == nil) {
        weekdayTF.text = @"00:00";
        weekdayOvertimeTF.text = @"00:00";
        weekendOvertimeTF.text = @"00:00";
        holidayOvertimeTF.text = @"00:00";
    } else {
        weekdayTF.text = item.Hour1Str;
        weekdayOvertimeTF.text = item.Hour15Str;
        weekendOvertimeTF.text = item.Hour2Str;
        holidayOvertimeTF.text = item.Hour3Str;
    }
    
    self.item.Hour1Str = item.Hour1Str;
    self.item.Hour15Str = item.Hour15Str;
    self.item.Hour2Str = item.Hour2Str;
    self.item.Hour3Str = item.Hour3Str;

//    self.timeTF1 = weekdayTF;
//    self.timeTF15 = weekdayOvertimeTF;
//    self.timeTF2 = weekendOvertimeTF;
//    self.timeTF3 = holidayOvertimeTF;

    weekdayTF.tag = 100;
    weekdayOvertimeTF.tag = 101;
    weekendOvertimeTF.tag = 102;
    holidayOvertimeTF.tag = 103;

    
    weekdayTF.textAlignment = NSTextAlignmentCenter;
    weekdayOvertimeTF.textAlignment = NSTextAlignmentCenter;
    weekendOvertimeTF.textAlignment = NSTextAlignmentCenter;
    holidayOvertimeTF.textAlignment = NSTextAlignmentCenter;
    
    [contentsview addSubview:weekdayTF];
    [contentsview addSubview:weekdayOvertimeTF];
    [contentsview addSubview:weekendOvertimeTF];
    [contentsview addSubview:holidayOvertimeTF];
    
    [weekdayTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(padding);
        make.right.equalTo(contentsview.mas_centerX).offset(-padding);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
        make.width.equalTo(weekdayOvertimeTF.mas_width);
        make.width.equalTo(weekendOvertimeTF.mas_width);
        make.width.equalTo(holidayOvertimeTF.mas_width);
    }];
    [weekdayOvertimeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(padding);
        make.right.equalTo(contentsview.mas_right).offset(-padding);
        make.height.equalTo(@30);
    }];
    [weekendOvertimeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weekdayTF.mas_bottom).offset(padding);
        make.right.equalTo(contentsview.mas_centerX).offset(-padding);
        make.height.equalTo(@30);
    }];
    [holidayOvertimeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weekdayOvertimeTF.mas_bottom).offset(padding);
        make.right.equalTo(contentsview.mas_right).offset(-padding);
        make.height.equalTo(@30);
    }];
    // X1平日Label
    [weekdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(padding);
        make.right.equalTo(weekdayTF.mas_left).offset(-padding/2);
        make.height.equalTo(@30);
    }];
    // X1.5平日加班Label
    [weekdayOvertimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(padding);
        make.right.equalTo(weekdayOvertimeTF.mas_left).offset(-padding/2);
        make.height.equalTo(@30);
    }];
    // X2双休日加班Label
    [weekendOvertimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weekdayLabel.mas_bottom).offset(padding);
        make.right.equalTo(weekendOvertimeTF.mas_left).offset(-padding/2);
        make.height.equalTo(@30);
    }];
    // X3国定假日加班Label
    [holidayOvertimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weekdayOvertimeLabel.mas_bottom).offset(padding);
        make.right.equalTo(holidayOvertimeTF.mas_left).offset(-padding/2);
        make.height.equalTo(@30);
    }];
    weekdayLabel.font = [UIFont systemFontOfSize:14];
    weekdayOvertimeLabel.font = [UIFont systemFontOfSize:12];
    weekendOvertimeLabel.font = [UIFont systemFontOfSize:12];
    holidayOvertimeLabel.font = [UIFont systemFontOfSize:12];

    UIView *lineView2 = UIView.new;
    lineView2.backgroundColor = [UIColor lightGrayColor];
    [contentsview addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weekendOvertimeLabel.mas_bottom).offset(padding);
        make.left.equalTo(contentsview.mas_left).offset(padding);
        make.right.equalTo(contentsview.mas_right).offset(-padding);
        make.height.equalTo(@1);
    }];
    
    // 备注
    UILabel *remarksLabel = UILabel.new;
    remarksLabel.text = SZLocal(@"title.SZMaintenanceOperation.comments");
    [contentsview addSubview:remarksLabel];
    [remarksLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView2.mas_bottom).offset(0);
        make.left.equalTo(contentsview.mas_left).offset(padding);
        make.right.equalTo(contentsview.mas_right).offset(-padding);
        make.height.equalTo(@30);
    }];
    // 备注输入框
    UITextView *remarksTV = [UITextView new];
    remarksTV.font = [UIFont fontWithName:@"Microsoft YaHei" size:15];
    remarksTV.layer.borderWidth = 1;
    remarksTV.backgroundColor = [UIColor lightGrayColor];
    remarksTV.delegate = self;
    if (item.Remark && ![item.Remark isEqualToString:@"(null)"]) {
        remarksTV.text = item.Remark;
    }
   
    self.remarksTV = remarksTV;
    [contentsview addSubview:remarksTV];
    [remarksTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remarksLabel.mas_bottom).offset(0);
        make.left.equalTo(contentsview.mas_left).offset(padding);
        make.right.equalTo(contentsview.mas_right).offset(-padding);
        make.bottom.equalTo(contentsview.mas_bottom).with.offset(-80);
        //make.height.equalTo(@150);
    }];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.subTitleView.frame=CGRectMake(0, -128, SCREEN_WIDTH, 80);
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    self.item.Remark = textView.text;

    self.subTitleView.frame=CGRectMake(0, 64, SCREEN_WIDTH, 80);
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 1111) {
        self.dateTF = textField;
    }else{
        self.timeTF = textField;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}

// 取得当前日期
-(NSString *) getCurrentDate {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString *currentDate = [formatter stringFromDate:[NSDate date]];
    return currentDate;
}


//判断中英混合的的字符串长度
- (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}

@end
