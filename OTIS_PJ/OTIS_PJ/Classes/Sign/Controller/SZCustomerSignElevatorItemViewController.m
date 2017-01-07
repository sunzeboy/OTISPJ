//
//  SZCustomerSignElevatorItemViewController.m
//  OTIS_PJ
//
//  Created by jQ on 16/5/4.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZCustomerSignElevatorItemViewController.h"




#import "SZCustomerSignCommentViewController.h"
#import "SZCustomerSignViewController.h"

#import "SZFinalMaintenanceUnitItem.h"
#import "SZSignBottomOperationView.h"
#import "SZMaintenanceHalfMonthViewController.h"
#import "SZMaintenanceQuarterViewController.h"
#import "SZMaintenanceHalfYearViewController.h"
#import "SZMaintenanceYearViewController.h"
//#import "SZMaintenanceCommentsViewController.h"
#import "SZSignCommentsViewController.h"
#import "SZTable_Report.h"
#import "CustomIOSAlertView.h"

@interface SZCustomerSignElevatorItemViewController ()
@property(nonatomic,strong) NSArray * rowArray;
@property(nonatomic,assign) NSInteger  rowIndex;
@property(nonatomic,strong) UILabel * subLabel1;
@property(nonatomic,strong) UILabel * subLabel2;
@property(nonatomic,strong) UILabel * subLabel3;

@property (nonatomic , strong)  SZSignBottomOperationView *operationView;

@end

@implementation SZCustomerSignElevatorItemViewController

-(SZSignBottomOperationView *)operationView{
    
    if(_operationView ==nil){
        _operationView =[SZSignBottomOperationView loadSZSignBottomOperationView];
        _operationView.frame = CGRectMake(0,SCREEN_HEIGHT-OTIS_BottomOperationH, SCREEN_WIDTH, OTIS_BottomOperationH);
        [_operationView.querenBtn setTitle:SZLocal(@"btn.title.confirm") forState:0];
        [self.view addSubview:_operationView];
        if (self.rowArray.count == 1) {
            self.operationView.nextBtn.enabled = NO;
            self.operationView.querenBtn.enabled=YES;
        }else if (self.rowArray.count>1){
            self.operationView.querenBtn.enabled=NO;
        }
        self.operationView.preBtn.enabled = NO;
    }
    return _operationView;
    
}

//
- (instancetype)initWithNSArray:(NSArray *)array index:(NSInteger )index{
    if(self = [super init]){
        _rowArray = array;
        _rowIndex = index;
    }
//     SZLog(@"count:%lu",(unsigned long)self.rowArray.count);
    return self;
}
//

- (void)viewDidLoad {
    self.isNeedSpace = YES;
    [super viewDidLoad];
    [self setNavItem];
    self.title = SZLocal(@"title.signViewController");
    [self setSubTitleWithName];
    self.navigationController.toolbarHidden = YES;
//    [self initToolBar];
    
    [self operationView];
    WEAKSELF
    self.operationView.confirmActBlock = ^(UIButton *btn){
        SZLog(@"SZLocal(@btn.title.confirm) %@",SZLocal(@"btn.title.confirm"));
        SZLog(@"SZLocal(@btn.title.confirm) %@",btn.titleLabel.text);
        

        if ([btn.titleLabel.text isEqualToString:SZLocal(@"btn.title.confirm")]) {
            [weakSelf signIn];
        }else if ([btn.titleLabel.text isEqualToString:SZLocal(@"dialog.content.Last one")]){
            [weakSelf previousRow];
        }else{
            [weakSelf nextRow];
        }
    };
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
    SZSignCommentsViewController *comments = self.childViewControllers[4];
    [comments.view endEditing:YES];

    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                 dialogContents:SZLocal(@"dialog.content.Whether to return to the elevator list screen, fill in the problem description will not be saved?")
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





// 设置副标题
- (void) setSubTitleWithName{
    UIView *subTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 80)];
    subTitleView.backgroundColor = [UIColor colorWithRed:3.0f/255.0f green:96.0f/255.0f blue:169.0f/255.0f alpha:1.0f];
//编辑项目
//    _subLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 3, SCREEN_WIDTH, 14)];
//    _subLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 19, SCREEN_WIDTH, 14)];
//    _subLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, SCREEN_WIDTH, 14)];
    
    _subLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 6, SCREEN_WIDTH, 20)];
    _subLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 31, SCREEN_WIDTH, 20)];
    _subLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 56, SCREEN_WIDTH, 20)];

    [self subtitleEdit];
        [subTitleView addSubview:_subLabel1];
        [subTitleView addSubview:_subLabel2];
        [subTitleView addSubview:_subLabel3];
    [self.view addSubview:subTitleView];
}

//副标题项目编辑方法
- (void) subtitleEdit{
    //labelName.font = [UIFont fontWithName:@"MicrosoftYaHei" size:15];
    SZFinalMaintenanceUnitItem *szModel = self.rowArray[self.rowIndex];
    //工地名称
    NSString * laber3=[NSString stringWithFormat:@"%@:",SZLocal(@"dialog.title.Site name")];
    NSString * laber4;
    laber4 = [laber3 stringByAppendingString:szModel.BuildingName];
    _subLabel1.text =laber4;
    _subLabel1.textColor = [UIColor whiteColor];
    //_subLabel1.font = [UIFont boldSystemFontOfSize:20.0];
    _subLabel1.font = [UIFont fontWithName:@"MicrosoftYaHei" size:14];
    //电梯编号
    NSString * laber1;
    NSString * laber2 = [NSString stringWithFormat:@"%@:",SZLocal(@"dialog.title.Elevator number")];
    laber1 = [laber2 stringByAppendingString:szModel.UnitNo];
    _subLabel2.text =laber1;
    _subLabel2.textColor = [UIColor whiteColor];
    _subLabel2.font = [UIFont fontWithName:@"MicrosoftYaHei" size:14];
    //计划日期
    NSString * laber5= [NSString stringWithFormat:@"%@:",SZLocal(@"title.planeDate")];
    NSString * laber6;
    laber6 = [laber5 stringByAppendingString:szModel.CheckDateStr];
    _subLabel3.text =laber6;
    _subLabel3.textColor = [UIColor whiteColor];
    _subLabel3.font = [UIFont fontWithName:@"MicrosoftYaHei" size:14];
    //
}


-(void)setupChildVces
{
    SZFinalMaintenanceUnitDetialItem *szModel = self.rowArray[self.rowIndex];

    SZMaintenanceHalfMonthViewController *halfMonth = [[SZMaintenanceHalfMonthViewController alloc] init];
    halfMonth.ispreView = YES;
    halfMonth.isSign = YES;
    halfMonth.title = SZLocal(@"title.SZMaintenanceOperation.halfMonth");
    halfMonth.item = szModel;
    [self addChildViewController:halfMonth];
    
    SZMaintenanceQuarterViewController *quarter = [[SZMaintenanceQuarterViewController alloc] init];
    quarter.ispreView = YES;
    quarter.isSign = YES;
    quarter.title = SZLocal(@"title.SZMaintenanceOperation.quarter");
    quarter.item = szModel;
    [self addChildViewController:quarter];
    
    SZMaintenanceHalfYearViewController *halfYear = [[SZMaintenanceHalfYearViewController alloc] init];
    halfYear.ispreView = YES;
    halfYear.isSign = YES;
    halfYear.title = SZLocal(@"title.SZMaintenanceOperation.halfYear");
    halfYear.item = szModel;
    [self addChildViewController:halfYear];
    
    SZMaintenanceYearViewController *year = [[SZMaintenanceYearViewController alloc] init];
    year.ispreView = YES;
    year.isSign = YES;
    year.title = SZLocal(@"title.SZMaintenanceOperation.year");
    year.item = szModel;
    [self addChildViewController:year];
    
    //SZMaintenanceCommentsViewController *comments = [[SZMaintenanceCommentsViewController alloc] init];
    SZSignCommentsViewController *comments = [[SZSignCommentsViewController alloc] init];
    comments.commentTextDetailBlock = ^(NSString *question){
        szModel.question = question;
    };
    SZMaintenanceRemarks *remark = [SZTable_Report quaryRemarkWithScheduleID:(int)szModel.ScheduleID];
    //内容编辑
    comments.maintenanceComments = remark.Question;
    comments.needReform = remark.isRepair;
    comments.needReplace = remark.isReplace;
    comments.title = SZLocal(@"title.SZMaintenanceOperation.comments");
    [self addChildViewController:comments];
    
    [self updateData];
    
}

-(void)updateData{
    
    SZFinalMaintenanceUnitDetialItem *szModel = self.rowArray[self.rowIndex];
    
    SZMaintenanceRemarks *remark = [SZTable_Report quaryRemarkWithScheduleID:(int)szModel.ScheduleID];

    SZMaintenanceHalfMonthViewController *halfMonth = [self.childViewControllers objectAtIndex:0];
    SZMaintenanceQuarterViewController *quarter  = [self.childViewControllers objectAtIndex:1];
    SZMaintenanceHalfYearViewController *halfYear = [self.childViewControllers objectAtIndex:2];
    SZMaintenanceYearViewController *year = [self.childViewControllers objectAtIndex:3];
    
    SZSignCommentsViewController *comments = [self.childViewControllers objectAtIndex:4];
    
    comments.commentTextDetailBlock = ^(NSString *question){
        szModel.question = question;
        [USER_DEFAULT setObject:question forKey:[NSString stringWithFormat:@"Comments_%ld",(long)self.rowIndex]];
        [USER_DEFAULT synchronize];
    };
    
    
    halfMonth.item = szModel;
    quarter.item = szModel;
    halfYear.item = szModel;
    year.item = szModel;
    //内容编辑
    comments.maintenanceComments = remark.Question;
    comments.needReform = remark.isRepair;
    comments.needReplace = remark.isReplace;
    comments.commentTextDetail.text = szModel.question;
    

}

//进入签字明细页面
-(void)signIn{
    SZSignCommentsViewController *comments = [self.childViewControllers objectAtIndex:4];
    if (comments.commentTextDetail.text.length>100) {
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:SZLocal(@"dialog.content.More than 100 of the text can not be saved")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            [alertView close];
        };
        [alertView show];
        
        return;
    }
    
    SZCustomerSignViewController *controller = [[SZCustomerSignViewController alloc] initWithNSArray:self.rowArray];
    controller.signComment = comments.commentTextDetail.text;
//    controller.signCommentArray = comments.commentTextDetail.text;
    controller.item = self.signArray[self.rowIndex];
    controller.signArray = self.signArray;
    [self.navigationController pushViewController:controller animated:YES];
    
}
//返回 取消签字
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)previousRow{
    if (self.rowIndex > 0) {
        NSInteger rowIdx = (NSInteger)self.rowIndex - 1;
        self.rowIndex = rowIdx;
        if (rowIdx>0) {
            self.operationView.preBtn.enabled = YES;

        }else{
            self.operationView.preBtn.enabled = NO;
        }
        //重新载入数据
        [self updateData];
        //重新显示副标题内容
        [self subtitleEdit];
    }
    self.operationView.nextBtn.enabled = YES;
}

-(void)nextRow{
    NSInteger rowIdx =(NSInteger)self.rowIndex + 1;
    if (rowIdx < self.rowArray.count) {
        self.rowIndex = rowIdx;
        //重新载入数据
        [self updateData];
        //重新显示副标题内容
        [self subtitleEdit];
        if (rowIdx+1<self.rowArray.count) {
            self.operationView.nextBtn.enabled = YES;
        }else{
            self.operationView.nextBtn.enabled = NO;
        }
    }
    
//    SZLog(@"---%lu",self.rowArray.count-1);
    if (rowIdx==(self.rowArray.count-1)){
        self.operationView.querenBtn.enabled=YES;
    }
    self.operationView.preBtn.enabled = YES;
}
-(void)titleClick:(UIButton *)button{
    [super titleClick:button];
    for (UIViewController *childViewController in self.childViewControllers){
        [childViewController.view endEditing:YES];
    }
    
}
@end
