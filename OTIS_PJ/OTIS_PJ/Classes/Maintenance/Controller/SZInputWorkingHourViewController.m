//
//  SZInputWorkingHourViewController.m
//  OTIS_PJ
//
//  Created by zhangyang on 16/5/30.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZInputWorkingHourViewController.h"
#import "SZWorkingHoursBigCell.h"
#import "SZWorkingHoursSmallCell.h"

#import "SZWorkingHourTableViewCell.h"

#import "UIBarButtonItem+Extention.h"
#import "SZTable_LaborType.h"
#import "SZNavigationController.h"
#import "SZAddWorkingHoursController.h"
#import "SZTable_LaborHours.h"
#import "SZNavigationController.h"
#import "MaintenanceViewController.h"
#import "SZOtisElevatorSelectViewController.h"
#import "SZBottomWhInputView.h"
#import "SZWorkingHoursPUIllCell.h"
#import "SZTable_QRCode.h"
#import "SZWorkAdjustmentController.h"
#import "SZSelectWH2ViewController.h"
#import "NSDate+Extention.h"
#import "CustomIOSAlertView.h"
#import "SZNonOtisElevatorViewController.h"
#import "SZOtisElevatorViewController.h"
#import "SZBottomFindView.h"
#import "NSDate+Extention.h"
#import "SZTable_Schedules.h"
#import "SZTable_Report.h"
#import "SZBottomSaveOperationView.h"

@interface SZInputWorkingHourViewController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic , strong) SZLabor *labor;

@property (nonatomic, strong) NSMutableArray *types;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *tf;

@property (nonatomic, assign) NSInteger selectedRow;

@property (nonatomic, strong) UITextField *dateTf;
// 电梯编号
@property (nonatomic, strong) UILabel *subEvelatorText;
// 日期
@property (nonatomic, strong) UILabel *subDateText;
// 总工时
@property (nonatomic, strong) UILabel *totalHourText;

@property(nonatomic,strong) UITextField* dateTextField;

@property (nonatomic , strong)  SZBottomWhInputView *bottomWhInputView;

// 是否有PUI
@property (nonatomic, assign) BOOL hasPUI;

@property (nonatomic , strong)  SZBottomFindView *bottomFindView;

@property(nonatomic,assign)BOOL isLastObject;

@property (nonatomic , assign) float initialTime;

@property (nonatomic , strong)  SZBottomSaveOperationView *operationView;


@end

@implementation SZInputWorkingHourViewController
- (BOOL)shouldAutorotate{
    
    return NO;
}


-(SZBottomSaveOperationView *)operationView{
    
    if(_operationView ==nil){
        _operationView =[SZBottomSaveOperationView loadSZBottomSaveOperationView];
        _operationView.frame = CGRectMake(0,SCREEN_HEIGHT-OTIS_BottomOperationH, SCREEN_WIDTH, OTIS_BottomOperationH);
        [self.view addSubview:_operationView];
    }
    return _operationView;
    
}

-(SZBottomFindView *) bottomFindView{
    
    if(_bottomFindView ==nil){
        _bottomFindView =[SZBottomFindView loadSZBottomFindView];
        _bottomFindView.frame = CGRectMake(0,SCREEN_HEIGHT-OTIS_BottomOperationH, SCREEN_WIDTH, OTIS_BottomOperationH);
        [_bottomFindView.findbtn setImage:[UIImage imageNamed:@"btn_save_blue"] forState:0];
        [_bottomFindView.findbtn setTitle:SZLocal(@"btn.title.save") forState:0];
        [self.view addSubview:_bottomFindView];
    }
    return _bottomFindView;
}
-(SZBottomWhInputView *) bottomWhInputView{
    
    if(_bottomWhInputView ==nil){
        _bottomWhInputView =[SZBottomWhInputView loadSZBottomWhInputView];
        _bottomWhInputView.frame = CGRectMake(0,SCREEN_HEIGHT-OTIS_BottomOperationH, SCREEN_WIDTH, OTIS_BottomOperationH);
        SZNavigationController *nav = (SZNavigationController*)self.navigationController;
        if (nav.laborTypeID == 9||nav.laborTypeID == 10) {
            [_bottomWhInputView.addBtn setImage:[UIImage imageNamed:@"btn_toolsList"] forState:0];
            [_bottomWhInputView.addBtn setTitle:SZLocal(@"btn.title.Detail") forState:0];
            if (self.records.count>1) {
                [_bottomWhInputView.saveBtn setTitle:SZLocal(@"btn.title.Share") forState:0];
            }else{
                [_bottomWhInputView.saveBtn setTitle:SZLocal(@"btn.title.save") forState:0];

            }
        }
        [self.view addSubview:_bottomWhInputView];
    }
    return _bottomWhInputView;
}

-(void)judegeBottomView{

    SZNavigationController *nav = (SZNavigationController*)self.navigationController;
    WEAKSELF
    
    if (nav.laborTypeID>99) {
        self.bottomFindView.findBtnClickBlock =^(UIButton *btn) {
            [weakSelf save];
        };
        
    }else{
        self.bottomWhInputView.addBtnClickBlock = ^(UIButton *btn){
            [weakSelf add];
        };
        self.bottomWhInputView.saveBtnClickBlock = ^(UIButton *btn) {
            [weakSelf save];
        };
        
    }


}

#pragma mark - KMDatePickerDelegate
- (void)datePicker:(KMDatePicker *)datePicker didSelectDate:(KMDatePickerDateModel *)datePickerDate {
    if (datePicker.tag ==1111) {
        NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@",
                             datePickerDate.year,
                             datePickerDate.month,
                             datePickerDate.day];
        _dateTextField.text = dateStr;
        for (SZLabor *gb in self.types) {
            gb.item1.GenerateDate = dateStr;
            gb.item2.GenerateDate = dateStr;
        }
        
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
        
        SZLabor *gb = self.types[self.selectedRow];
        
        SZNavigationController *nav = (SZNavigationController *)self.navigationController;
        
        gb.item1.LaborTypeId = gb.LaborTypeID;
        if (gb.isLutu) {
            gb.item2.LaborTypeId = [SZTable_LaborType quaryLuTuLaborTypeIDWithLaborTypeID:gb.LaborTypeID];
            if (nav.laborTypeID) {//生产性工时
                gb.item2.Property = 1;
            }else{//维保工时
                gb.item2.Property = 0;
            }
        }
        if (nav.laborTypeID) {//生产性工时
            gb.item1.Property = 1;
        }else{//维保工时
            gb.item1.Property = 0;
        }
        if (self.contant_NO) {
            gb.item1.Property = 2;
        }
        switch (self.tf.tag) {
            case 100:
//                gb.item1.Hour1Rate = strDate.floatValue;
                gb.item1.Hour1Str = dateStr;
                break;
            case 101:
//                gb.item1.Hour15Rate = strDate.floatValue;
                gb.item1.Hour15Str = dateStr;

                break;
            case 102:
//                gb.item1.Hour2Rate = strDate.floatValue;
                gb.item1.Hour2Str = dateStr;

                break;
            case 103:
//                gb.item1.Hour3Rate = strDate.floatValue;
                gb.item1.Hour3Str = dateStr;

                break;
            case 104:
//                gb.item2.Hour1Rate = strDate.floatValue;
                gb.item2.Hour1Str = dateStr;

                break;
            case 105:
//                gb.item2.Hour15Rate = strDate.floatValue;
                gb.item2.Hour15Str = dateStr;

                break;
            case 106:
//                gb.item2.Hour2Rate = strDate.floatValue;
                gb.item2.Hour2Str = dateStr;

                break;
            case 107:
//                gb.item2.Hour3Rate = strDate.floatValue;
                gb.item2.Hour3Str = dateStr;

                break;
                
            default:
                break;
        }
        
        float totalHour = 0;
        for (SZLabor *labor in self.types) {
            totalHour+=labor.gongshi;
        }
        
        self.totalHourText.text = [NSString stringWithFormat:@"%.2f",totalHour];
    }
}

//1 懒加载
- (SZLabor *)labor
{
    if (_labor ==nil) {
        SZNavigationController *nav = (SZNavigationController*)self.navigationController;
            _labor = [SZTable_LaborType quaryLaborWithLaborTypeID:nav.laborTypeID==0?1:nav.laborTypeID];
    }
    return _labor;
}

//1 懒加载
- (NSMutableArray *)types
{
    if (_types ==nil) {
        SZNavigationController *nav = (SZNavigationController*)self.navigationController;
        if (nav.laborTypeID) {//生产性工时
            _types = [NSMutableArray arrayWithObject:self.labor];

        }else{//维保工时
            _types = [NSMutableArray arrayWithArray:[SZTable_LaborHours quaryMaintenanceWithScheduleID:(int)self.scheduleID]];
            if (_types.count == 0) {
                _types = [NSMutableArray arrayWithObject:self.labor];
            }
        }
    }
    return _types;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"工时填写－%@", self.labor.LaborName];
    self.view.backgroundColor=[UIColor lightGrayColor];
    [self dateView];
    if (self.inWarranty || self.isWorkhour) {
        NSString *titleDate = nil;
        if (self.item.GenerateDate == 0||!self.item.GenerateDate) {
            titleDate = [self getCurrentDate];
        } else {
            titleDate = self.item.GenerateDate;
        }
        [self setSubTitleViewWithEvelatorNumber:self.item.UnitNo subTitleDate:titleDate totalHour:@"0"];
        

        [self setManHourTableView];
        [self bottomWhInputView];
        
        [self judegeBottomView];
        
        
    } else {
        
        NSInteger yymmdd =  [NSDate currentYYMMDD];
        
        NSString *startKey = [NSString stringWithFormat:@"%ld_%@START",yymmdd,self.item.UnitNo];
        
        NSNumber *start = (NSNumber *)[USER_DEFAULT objectForKey:startKey];
        
        NSString *endKey;
        if (self.inputMode== 1 || self.inputMode== 2 ) { // 维保灰色，工时进入
            endKey = [NSString stringWithFormat:@"%ld_%@ENDJHA",yymmdd,self.item.UnitNo];
            
        }else {
            endKey = [NSString stringWithFormat:@"%ld_%@END",yymmdd,self.item.UnitNo];
        }
        
        NSNumber *end = (NSNumber *)[USER_DEFAULT objectForKey:endKey];
        
        float gongshihours = fabs((end.longLongValue - start.longLongValue)/10000000.0/3600.0);
        
        NSNumber *lutuEnd = [USER_DEFAULT objectForKey:@"ENDTIME"]?[USER_DEFAULT objectForKey:@"ENDTIME"]:@(MAXFLOAT);
        
        float hours = (start.longLongValue-lutuEnd.longLongValue)/10000000.0/3600.0;
        float lutuhours = hours>0?hours:0 ;
        
        SZLabor *labor = self.types[0];
        labor.item1.Hour1Rate = gongshihours ;
        labor.item1.Hour1Str = [NSString stringWithFormat:@"%d:%d",(int)gongshihours,(int)((gongshihours-(int)gongshihours)*60)];
        labor.item2.Hour1Rate = lutuhours ;
        labor.item2.Hour1Str = [NSString stringWithFormat:@"%d:%d",(int)lutuhours,(int)((lutuhours-(int)lutuhours)*60)];
        
        NSNumber *zhongduanTime = [USER_DEFAULT objectForKey:[NSString stringWithFormat:@"%ld_%@zhongduanTime",yymmdd,self.item.UnitNo]]?:@(0);
        NSNumber *lutuTime = [USER_DEFAULT objectForKey:[NSString stringWithFormat:@"%ld_%@lutuTime",yymmdd,self.item.UnitNo]]?:@(0);

        if (self.zhongduan) {
            NSNumber *numTime = [USER_DEFAULT objectForKey:[NSString stringWithFormat:@"%ld_%@zhongduan",yymmdd,self.item.UnitNo]];
            
            
            gongshihours = fabs((numTime.longLongValue-start.longLongValue)/10000000.0/3600.0)+zhongduanTime.floatValue;
            
        }else{
            
            if (self.inputMode== 1 || self.inputMode== 2) {
                
            }else{
                gongshihours = zhongduanTime.floatValue + gongshihours;
                lutuhours = lutuhours + lutuTime.floatValue;
            }
            
        }
        
        [self setUpAutoWorkingHoursWithtime:gongshihours lutuTime:lutuhours];
        
        WEAKSELF
        self.operationView.confirmActBlock = ^(UIButton *btn){
            
            if ([btn.titleLabel.text isEqualToString:SZLocal(@"btn.title.save")]) {
                [weakSelf confirmSaveWorkingHours];
                [USER_DEFAULT setObject:@(gongshihours) forKey:[NSString stringWithFormat:@"%ld_%@zhongduanTime",yymmdd,weakSelf.item.UnitNo]];
                [USER_DEFAULT setObject:@(lutuhours) forKey:[NSString stringWithFormat:@"%ld_%@lutuTime",yymmdd,weakSelf.item.UnitNo]];

                if (weakSelf.inputMode == 0&&weakSelf.zhongduan == NO) {
                    [USER_DEFAULT setObject:@"NO" forKey:[NSString stringWithFormat:@"%ld_%@zhongduan",yymmdd,weakSelf.item.UnitNo]];
                    [USER_DEFAULT setObject:@(0) forKey:[NSString stringWithFormat:@"%ld_%@zhongduanTime",yymmdd,weakSelf.item.UnitNo]];
                    [USER_DEFAULT setObject:@(0) forKey:[NSString stringWithFormat:@"%ld_%@lutuTime",yymmdd,weakSelf.item.UnitNo]];
                }
                

            }
        };
        
        [self setSubTitleViewWithEvelatorNumber:self.item.UnitNo subTitleDate:[self getCurrentDate] totalHour:[NSString stringWithFormat:@"%.2f",gongshihours+lutuhours]];
    }
    
    
   
    [self setNavItem];

    //AddLaborHoursState状态
    SZNavigationController *nav = (SZNavigationController *)self.navigationController;
    if (!nav.laborTypeID) {
        if (self.inputMode== 1 || self.inputMode== 2 ) { // 维保灰色，工时进入
            if (self.totalHourText.text.floatValue>0) {
                [SZTable_Schedules updateAddLaborHoursState:2 andScheduleID:self.item.ScheduleID];
            }
            
        }
    }
    
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
// 取得当前日期
-(NSString *) getCurrentDate {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate = [formatter stringFromDate:[NSDate date]];
    return currentDate;
}

-(void)dateView{

    
    
    UIView* view=[[UIView alloc] initWithFrame:CGRectMake(0, 144, SCREEN_WIDTH, 79)];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel* dateLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 30)];
    dateLabel.text=SZLocal(@"btn.title.Date");
    dateLabel.textColor=[UIColor blueColor];
    [view addSubview:dateLabel];
    
    UITextField* dateTextField=[[UITextField alloc] initWithFrame:CGRectMake(dateLabel.frame.origin.x, CGRectGetMaxY(dateLabel.frame)+5, 200, 30)];
    dateTextField.text=[NSDate currentDate];
    dateTextField.backgroundColor=[UIColor lightGrayColor];
    dateTextField.textAlignment=NSTextAlignmentCenter;
    [view addSubview:dateTextField];
    _dateTextField=dateTextField;
    CGRect rect = [[UIScreen mainScreen] bounds];
    KMDatePicker *datePicker = [[KMDatePicker alloc]
                                initWithFrame:CGRectMake(0.0, 0.0, rect.size.width, 216.0)
                                delegate:self
                                datePickerStyle:KMDatePickerStyleYearMonthDay];
    datePicker.tag = 1111;
    _dateTextField.delegate = self;
    _dateTextField.inputView = datePicker;
    
    SZNavigationController *nav = (SZNavigationController*)self.navigationController;
    if (!nav.laborTypeID) {
        view.hidden=YES;
    }else{
        view.hidden=NO;
    }
    
    
    float totalHour = 0;
    
    
    for (SZLabor *labor in self.types) {
        totalHour+=labor.gongshi;
    }
    self.initialTime = totalHour;
   
    
    
    self.totalHourText.text = [NSString stringWithFormat:@"%.2f",totalHour];
}
-(void)back{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.workingHourSave")
                                                                                 dialogContents:SZLocal(@"dialog.content.workhourDoNotSave")
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        if(buttonIndex == 0){
            [self.navigationController popViewControllerAnimated:YES];
            [USER_DEFAULT setObject:@"YES" forKey:@"BACKACT"];
            [alertView close];
        }else if(buttonIndex == 1){
            [alertView close];
        }
    };
    [self.view endEditing:YES];
    [alertView show];
}

//-(void)initNav{
//
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_toolsList"] landscapeImagePhone:[UIImage imageNamed:@"btn_toolsList"] style:UIBarButtonItemStylePlain target:self action:@selector(detial)];
//    
//    self.navigationItem.rightBarButtonItem = item;
//
//}

-(void)detial{
    WEAKSELF
    SZSelectWH2ViewController *vc = [[SZSelectWH2ViewController alloc] init];
    vc.subTitle = self.outItem.BuildingName;
    vc.confirmActBlock = ^(NSArray *array){
        weakSelf.records = array;
    };
    if (self.records.count) {
        vc.records = self.records;
    }else{
        vc.records = [NSMutableArray arrayWithObject:self.item];
    }
    [self.navigationController pushViewController:vc animated:YES];
}


// Height 80
- (void) setSubTitleViewWithEvelatorNumber : (NSString *)evelatorNumber subTitleDate :(NSString *)subTitleDate  totalHour : (NSString *)totalHour {
    UIView *subTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 80)];
    subTitleView.backgroundColor = [UIColor colorWithRed:3.0f/255.0f green:96.0f/255.0f blue:169.0f/255.0f alpha:1.0f];
   // if (_inWarranty || _isWorkhour) {
        // 设置电梯编号
    if (![evelatorNumber isEqualToString:@""]&&evelatorNumber!=nil) {
        UILabel *subEvelatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, SCREEN_WIDTH, 20)];
        subEvelatorLabel.text =[NSString stringWithFormat:@"%@:",SZLocal(@"dialog.title.Elevator number")];
        subEvelatorLabel.font =[UIFont fontWithName:@"Microsoft YaHei" size:16.0f];
        subEvelatorLabel.textAlignment = NSTextAlignmentLeft;
        subEvelatorLabel.textColor = [UIColor whiteColor];
    
        SZNavigationController *nav = (SZNavigationController*)self.navigationController;
        if ((nav.laborTypeID == 9||nav.laborTypeID == 10)&&self.records.count>1) {//工时分摊（详情）
            subEvelatorLabel.hidden = YES;
        }
        // 电梯编号内容
        self.subEvelatorText = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, SCREEN_WIDTH - 80, 20)];
        self.subEvelatorText.text =evelatorNumber;
        self.subEvelatorText.font =[UIFont fontWithName:@"Microsoft YaHei" size:16];
        self.subEvelatorText.textAlignment = NSTextAlignmentLeft;
        self.subEvelatorText.textColor = [UIColor whiteColor];
        
        [subTitleView addSubview:subEvelatorLabel];
        [subTitleView addSubview:self.subEvelatorText];
    }

   // }
    
    CGRect frame;
    CGFloat y;
    if (![evelatorNumber isEqualToString:@""]&&evelatorNumber!=nil) {
        frame=CGRectMake(20, 30, 90, 20);
        y=frame.origin.y+25;
    }else{
        frame=CGRectMake(20, 10, 90, 20);
        y=frame.origin.y+40;
    }
    // 设置日期
    UILabel *subDateLabel = [[UILabel alloc] initWithFrame:frame];
    
    subDateLabel.font =[UIFont fontWithName:@"Microsoft YaHei" size:16.0f];
    [subDateLabel  setFont:[UIFont fontWithName:@"Microsoft YaHei" size:16.0f]];
    subDateLabel.textAlignment = NSTextAlignmentLeft;
    subDateLabel.textColor = [UIColor whiteColor];
    // 日期内容
    self.subDateText = [[UILabel alloc] initWithFrame:CGRectMake(100, frame.origin.y, SCREEN_WIDTH - 80, 20)];
    self.subDateText.text =subTitleDate;
    self.subDateText.font =[UIFont fontWithName:@"Microsoft YaHei" size:16];
    self.subDateText.textAlignment = NSTextAlignmentLeft;
    self.subDateText.textColor = [UIColor whiteColor];
    
    // 总工时控件
    UILabel *totalHourLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,y, 80, 20)];
    totalHourLabel.text =@"总 工 时：";
    totalHourLabel.font =[UIFont fontWithName:@"Microsoft YaHei" size:16];
    totalHourLabel.textAlignment = NSTextAlignmentLeft;
    totalHourLabel.textColor = [UIColor whiteColor];
    // 总工时内容
    self.totalHourText = [[UILabel alloc] initWithFrame:CGRectMake(100, y, SCREEN_WIDTH - 80, 20)];
    self.totalHourText.text =totalHour;
    self.totalHourText.font =[UIFont fontWithName:@"Microsoft YaHei" size:16];
    self.totalHourText.textAlignment = NSTextAlignmentLeft;
    self.totalHourText.textColor = [UIColor colorWithRed:243.0f/255.0f green:172.0f/255.0f blue:0.0f alpha:1.0f];
    
    [subTitleView addSubview:subDateLabel];
    [subTitleView addSubview:self.subDateText];
    [subTitleView addSubview:totalHourLabel];
    [subTitleView addSubview:self.totalHourText];
    
    [self.view addSubview:subTitleView];
    
    if (self.isWorkhour) {
        subDateLabel.text =@"日      期：";
        self.subDateText.text =[self getCurrentDate];

    } else {
        
        SZNavigationController *nav = (SZNavigationController*)self.navigationController;
        
        if (nav.laborProperty == 4 || self.records.count) {
            subDateLabel.text =@"日   期：";
//            self.subDateText.text =self.item.CheckDateStr;
            self.subDateText.text =[self getCurrentDate];

        }else{
            subDateLabel.text =[NSString stringWithFormat:@"%@:",SZLocal(@"title.planeDate")];
            self.subDateText.text =self.item.CheckDateStr;
        }
    }
}


- (void)setUpAutoWorkingHoursWithtime:(float)gongzuoVale lutuTime:(float)lutuVale {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 80+64, SCREEN_WIDTH, SCREEN_HEIGHT-(80+64))];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];

    
    
    UILabel *gongzuo = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 100, 30)];
    gongzuo.text = @"工作工时：";
    gongzuo.font = [UIFont systemFontOfSize:14.0];
    gongzuo.textColor = RGB(30, 32, 81);
    
    UILabel *gongzuoTime = [[UILabel alloc] initWithFrame:CGRectMake(25, 60, 100, 30)];
    gongzuoTime.text = [NSString stringWithFormat:@"%.2f小时",gongzuoVale];
    gongzuoTime.font = [UIFont systemFontOfSize:14.0];
    gongzuoTime.textColor = RGB(30, 32, 81);
    
    UILabel *lutu = [[UILabel alloc] initWithFrame:CGRectMake(15, 100, 100, 30)];
    lutu.text = @"路途工时：";
    lutu.font = [UIFont systemFontOfSize:14.0];
    lutu.textColor = RGB(30, 32, 81);
    
    UILabel *lutuTime = [[UILabel alloc] initWithFrame:CGRectMake(25, 140, 100, 30)];
    lutuTime.text = [NSString stringWithFormat:@"%.2f小时",lutuVale];
    lutuTime.font = [UIFont systemFontOfSize:14.0];
    lutuTime.textColor = RGB(30, 32, 81);
    
    [view addSubview:gongzuo];
    [view addSubview:gongzuoTime];
    [view addSubview:lutu];
    [view addSubview:lutuTime];
}

// 设置TableView
- (void) setManHourTableView {
    CGRect frame;
    SZNavigationController *nav = (SZNavigationController*)self.navigationController;
    if (!nav.laborTypeID) {
         frame=CGRectMake(0, 144, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 134);
    }else{
        frame=CGRectMake(0, 224, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 214);
    }
    
//    UITableView *tableView = [[UITableView alloc] initWithFrame:frame];
//    tableView.delegate = self;
//    tableView.dataSource = self;
//     tableView.rowHeight = 240;
//    [self.view addSubview:tableView];
//    self.tableView = tableView;
//    [self setExtraCellLineHidden:self.tableView];
    
    
    UITableViewController *tvc = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    _tableView                 = tvc.tableView;
    _tableView.frame           = frame;
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 240;
    [self addChildViewController:tvc];
    [self.view addSubview:_tableView];
    [self setExtraCellLineHidden:_tableView];

    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SZLabor *gb = self.types[indexPath.row];
    if (gb.isLutu){
        if (gb.LaborTypeID == 8) return 270;
        return 240;
    }
    return 137;
}

//返回每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isLastObject) {
        _bottomWhInputView.addBtn.enabled=NO;
    }else{
        _bottomWhInputView.addBtn.enabled=YES;
    }
    return self.types.count;
}


//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SZLabor *gb = self.types[indexPath.row];
    if (gb.isLutu) {
        
        if (gb.LaborTypeID == 8) {
            //1 创建可重用的自定义的cell
            SZWorkingHoursPUIllCell *cell = [SZWorkingHoursPUIllCell cellWithTableView:tableView];
            cell.labor =gb;
            self.hasPUI = YES;
            WEAKSELF
            cell.didClickedTFBlock = ^(UITextField *tf){
                weakSelf.tf = tf;
                if (![tf.text containsString:@":"]) {
                    gb.item1.PUINo = tf.text;
                }
                weakSelf.selectedRow = indexPath.row;
            };
            cell.deleteBlock = ^(SZLabor *gb ){
                
                CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                                dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                             dialogContents:SZLocal(@"dialog.content.confirmDelWorkinghour")
                                                                                              dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
                
                alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
                    if (buttonIndex == 0) {
                        
                        [weakSelf.types removeObject:gb];
                        _isLastObject=NO;
                        [weakSelf.tableView reloadData];
                    }
                    [alertView close];
                };
                
                [alertView show];
            };
            if (indexPath.row == 0) {
                cell.deleteBtn.hidden = YES;
            }
            //3 返回
            return cell;
        }
        //1 创建可重用的自定义的cell
        SZWorkingHoursBigCell *cell = [SZWorkingHoursBigCell cellWithTableView:tableView];
        cell.labor =gb;
        WEAKSELF
        cell.didClickedTFBlock = ^(UITextField *tf){
            weakSelf.tf = tf;
            weakSelf.selectedRow = indexPath.row;
        };
        cell.deleteBlock = ^(SZLabor *gb ){

            CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                            dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                         dialogContents:SZLocal(@"dialog.content.confirmDelWorkinghour")
                                                                                          dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
            
            alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
                if (buttonIndex == 0) {
                    
                    [weakSelf.types removeObject:gb];
                    _isLastObject=NO;
                    [weakSelf.tableView reloadData];
                }
                [alertView close];
            };
            [alertView show];
            
        };
        if (indexPath.row == 0) {
            cell.deleteBtn.hidden = YES;
        }
        //3 返回
        return cell;
    }
    //1 创建可重用的自定义的cell
    SZWorkingHoursSmallCell *cell = [SZWorkingHoursSmallCell cellWithTableView:tableView];
    cell.labor =gb;
    WEAKSELF
    cell.didClickedTFBlock = ^(UITextField *tf){
        weakSelf.tf = tf;
        weakSelf.selectedRow = indexPath.row;
    };
    cell.deleteBlock = ^(SZLabor *gb ){
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:SZLocal(@"dialog.content.confirmDelWorkinghour")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
        
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            if (buttonIndex == 0) {
                
                [weakSelf.types removeObject:gb];
                [weakSelf.tableView reloadData];
            }
            [alertView close];
        };
        
        [alertView show];

    };
    if (indexPath.row == 0) {
        cell.deleteBtn.hidden = YES;
    }
    //3 返回
    return cell;
}


-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
-(void)add {
    
    SZNavigationController *nav = (SZNavigationController*)self.navigationController;
    if (nav.laborTypeID == 9||nav.laborTypeID == 10) {//工时分摊（详情）
        
        [self detial];
        
    }else{//正常工时填写保存（添加）
        
        SZAddWorkingHoursController *vc = [[SZAddWorkingHoursController alloc] init];
        vc.selectedTypes = [NSMutableArray array];
        for (SZLabor *gb  in self.types) {
            [vc.selectedTypes addObject:@(gb.LaborTypeID)];
        }
        WEAKSELF
        vc.selectedBlock = ^(SZLabor *labor,BOOL isLastObject){
            _isLastObject=isLastObject;
            [weakSelf.types addObject:labor];
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/**
    0:正常
 *  1:主工时为0
    2:总工时>=8
    3.总工时>=24
 */
-(int)tipType{
    
    SZLabor *labor = self.types[0];
    
    SZNavigationController *nav = (SZNavigationController *)self.navigationController;
    if (nav.laborTypeID) {
        if (labor.mainGongshi == 0) {
            return 1;
        }
    }else{
        if (labor.gongshi == 0) {
            return 1;
        }
    }
    
    

    float total = [SZTable_LaborHours quaryTotlaTimesWithDate:[NSDate currentDate]];
    float thisTotal = [[[self.totalHourText.text componentsSeparatedByString:@"："] lastObject] floatValue];

    if (total-self.initialTime+thisTotal >= 24) {
        return 3;
    }
    
    if (self.totalHourText.text.floatValue > 7.99 &&self.totalHourText.text.floatValue<=24) {
        return 2;
    }
    
   

    return 0;
}


-(BOOL)hasPUI{
    for (SZLabor *labor in self.types) {
        if (labor.LaborTypeID == 8 &&(labor.item1.PUINo.length==0||!labor.item1.PUINo)) {
            
            return YES;
        }
    }

    return NO;
}


-(void)save {

    SZNavigationController *nav = (SZNavigationController *)self.navigationController;
    if (nav.laborTypeID) {
        // 判断日期是否超出范围
        
        BOOL retDate = [NSDate compareDate:_dateTextField.text];
        if (retDate == NO) {
            CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                            dialogTitle:SZLocal(@"dialog.title.fillWorkingHour")
                                                                                         dialogContents:SZLocal(@"dialog.content.dateIsOutOfRange")
                                                                                          dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
            
            alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
                
                
                [alertView close];
                _dateTextField.text = [NSDate currentDate];
            };
            [alertView show];
            return;
            
        }

        
        

    }
    
    if (self.hasPUI) {
        for (SZLabor *labor in self.types) {
            if (labor.LaborTypeID == 8 &&(labor.item1.PUINo.length==0||!labor.item1.PUINo)) {
                CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                                dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                             dialogContents:SZLocal(@"dialog.content.Please enter the PUI number!")
                                                                                              dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
                alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
                    [alertView close];
                };
                [alertView show];
                return;
            }
        }
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

    [USER_DEFAULT setObject:@"NO" forKey:@"BACKACT"];

}




-(void)tip0{

    SZNavigationController *nav = (SZNavigationController*)self.navigationController;
    if (nav.laborTypeID == 9||nav.laborTypeID == 10) {//工时分摊
        
        if (self.records.count) {
            
        }else{
            self.item.selected = YES;
            self.records = [NSMutableArray arrayWithObject:self.item];
        }
        
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:[NSString stringWithFormat:@"是否确认保存%@工时？",self.labor.LaborName]
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            if(buttonIndex == 0){
                [SZTable_LaborHours storageLaborHoursItems:self.types withUnits:self.records andGenerateDate:self.dateTextField.text];
                [self.navigationController popToViewController:[self.navigationController.childViewControllers objectAtIndex:2] animated:YES];
            }
            [alertView close];
        };
        [alertView show];
        
    }else{//正常工时填写保存
        
        [self confirmSaveWorkingHours];
        
    }

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
    
    NSString *strNO ;
    if (self.item.UnitNo) {
        strNO =[NSString stringWithFormat:@"电梯%@的总工时已超过8小时!",self.item.UnitNo];
    }else{
        strNO = @"电梯的总工时已超过8小时!";
    }
    
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                 dialogContents:strNO
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
                                                                                 dialogContents:[NSString stringWithFormat:SZLocal(@"dialog.content.Today, more than 24 hours of processing time, the work can not be saved.")]
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        [alertView close];
    };
    [alertView show];
    
}


-(void) confirmSaveWorkingHours {
//    if (self.scheduleID== -1||self.scheduleID== 0) {
//        self
//    }
  
    
    if (self.dateTextField.text == nil||self.dateTextField == nil) {
        self.dateTextField.text = [NSDate currentDate];
    }
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                 dialogContents:[NSString stringWithFormat:@"是否确认保存%@工时？",self.labor.LaborName]
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        if(buttonIndex == 0){
            SZNavigationController *nav = (SZNavigationController *)self.navigationController;
            if (nav.laborTypeID) {//生产性工时(直接插入数据)
                
                if (nav.laborProperty == 4) {//非本公司生产性工时
                    [SZTable_LaborHours storageLaborHoursItems:self.types withCONTACT_NO:self.contant_NO andCustomerName:self.CustomerName andGenerateDate:self.dateTextField.text];
                }else{//本公司生产性工时andGenerateDate:GenerateDate
                  int groupId =  [SZTable_LaborHours storageLaborHoursItems:self.types withScheduleID:self.scheduleID andUnitNo:self.unitNo andOpration:self.item andGenerateDate:self.dateTextField.text];
                    /**
                     *  更新t_QRCode
                     */
                    [SZTable_QRCode storageWeiBaoWorkingHoursWithParams:self.item andGroupID:groupId withProperty:3];
                }
                
                //修改是否填写工时的标志状态
                [SZTable_LaborHours isLaborHoursed];
                
            }else{//维保工时（更新数据）
                
                if (self.inputMode== 1 || self.inputMode== 2 ) { // 维保灰色，工时进入
                    
                    [SZTable_Schedules updateAddLaborHoursState:2 andScheduleID:self.item.ScheduleID];
                    
                }//else if(self.inputMode==1){ // 有维保的情况进入，填写完工时将LastStat置为0，已经完成状态，否则上传工时的时候，找不到此项
                 //    [SZTable_Report updateLastStatusOnTabReport:0 andScheduleID:self.item.ScheduleID];
                //}
                [SZTable_LaborHours updateLaborHoursItems:self.types withScheduleID:self.scheduleID andUnitNo:self.unitNo];
                
               
                
                /**
                 *  保存t_QRCode(，如果有进如果没有进行过正常维保操作就保存一条操作记录行过完整的维保操作，就不保存)
                 */
                NSNumber *scheduleID = [USER_DEFAULT objectForKey:[NSString stringWithFormat:@"%d",(int)self.item.ScheduleID]];
                if (scheduleID.integerValue != self.item.ScheduleID) {//没有进行过正常维保操作（不会产生一条维保记录）
                    [SZTable_QRCode storageWeiBaoWorkingHoursWithParams:self.item andGroupID:0 withProperty:1];
                }
                /**
                 *  更新report的LastStatus状态
                 */
                if (self.zhongduan == NO) {
                    [SZTable_Report updateReportState:self.item];

                }
                
                [USER_DEFAULT setObject:@(self.item.ScheduleID) forKey:[NSString stringWithFormat:@"%d",(int)self.item.ScheduleID]];

            }
            
            if (self.zhongduan) {
                SZWorkAdjustmentController *vcAdjustment = [[SZWorkAdjustmentController alloc] init];
                vcAdjustment.item = self.item;
                [self.navigationController pushViewController:vcAdjustment animated:YES]; //跳转
                
            }else{
                
                UIViewController *target = nil;
                for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
                    if ([controller isKindOfClass:[nav.popVc class]]) { //这里判断是否为你想要跳转的页面
                        target = controller;
                    }
                }
                if (target) {
                    [self.navigationController popToViewController:target animated:YES]; //跳转
                }
                
                
            }
        } else {

            
        }
        [alertView close];
    };
    [alertView show];
}
-(void)initTableHeadView{
    CGRect rect = [[UIScreen mainScreen] bounds];
    KMDatePicker *datePicker = [[KMDatePicker alloc]
                                initWithFrame:CGRectMake(0.0, 0.0, rect.size.width, 216.0)
                                delegate:self
                                datePickerStyle:KMDatePickerStyleYearMonthDay];
    datePicker.tag = 1111;
    self.dateTf = [[UITextField alloc] initWithFrame:CGRectMake(15, 5, 100, 30)];
    self.dateTf.delegate = self;
    self.dateTf.inputView = datePicker;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _dateTf = textField;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_dateTf resignFirstResponder];
}

-(void)dealloc{
    SZLog(@"sile...");
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

/**
 * 判断选择的日期是否在范围内。在范围内返回输入的日期，不在范围内返回当天日期。
 */
-(NSString *)inRangeDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [NSDate date];
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
@end
