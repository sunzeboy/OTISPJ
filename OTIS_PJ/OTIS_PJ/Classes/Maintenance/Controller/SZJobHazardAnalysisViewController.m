//  工作危险性分析
//  SZJobHazardAnalysisViewController.m
//  OTIS_PJ
//
//  Created by zy on 16/5/4.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZJobHazardAnalysisViewController.h"
#import "SZMachineRoomViewController.h"
#import "SZCarTopViewController.h"
#import "SZPitViewController.h"
#import "SZMaintenanceOperationViewController.h"
#import "SZJHATitleItem.h"
#import "SZModuleQueryTool.h"
#import "NSMutableArray+Extention.h"
#import "CustomIOSAlertView.h"
#import "SZInputWorkingHourViewController.h"
#import "SZTable_Report.h"
#import "SZBottomSaveOperationView.h"
#import "SZTable_QRCode.h"
#import "SZTable_Schedules.h"
#import "NSDate+Extention.h"

@interface SZJobHazardAnalysisViewController ()

@property (nonatomic , strong) NSArray *arrayCompetedJHA;

@property (nonatomic , strong) SZBottomSaveOperationView *operationView;

@end

@implementation SZJobHazardAnalysisViewController
-(SZBottomSaveOperationView *)operationView{
    
    if(_operationView ==nil){
        _operationView =[SZBottomSaveOperationView loadSZBottomSaveOperationView];
        _operationView.frame = CGRectMake(0,SCREEN_HEIGHT-OTIS_BottomOperationH, SCREEN_WIDTH, OTIS_BottomOperationH);
        [self.view addSubview:_operationView];
    }
    return _operationView;
    
}
//1 懒加载
- (NSArray *)arrayCompetedJHA
{
    if (_arrayCompetedJHA ==nil) {
        _arrayCompetedJHA = [SZModuleQueryTool quaryCompetedJHAArrayWithDetialItem:self.item andIsFixItem:self.IsFixItem];
    }
    return _arrayCompetedJHA;
}

- (void)viewDidLoad {
    self.isNeedSpace = YES;
    [super viewDidLoad];
    
    [self jhaJage];
    
    self.title = SZLocal(@"title.SZJobHazardAnalysisViewController");
    [self setSubTitleView];
    [self operationView];
    [self setBackItem];
    WEAKSELF
    self.operationView.confirmActBlock = ^(UIButton *btn){
        
        if ([btn.titleLabel.text isEqualToString:SZLocal(@"btn.title.save")]) {
            [weakSelf okAct];
        }
    };
}


-(void)jhaJage{

    if (self.inputMode == 2) { // 灰色进入的时候，清除数据
        
        int curAddLaborHoursState = [SZTable_Schedules quaryLaborHoursStateWithScheduleID:(int)self.item.ScheduleID];
        
        if (curAddLaborHoursState == 0 ) {
            
            [SZTable_Schedules updateAddLaborHoursStateWithScheduleID:(int)self.item.ScheduleID];
        }
        
        
    }
    


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
                                                                                 dialogContents:SZLocal(@"dialog.content.JHA has not been saved")
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        if(buttonIndex == 0){
            [self.navigationController popViewControllerAnimated:YES];
            [alertView close];
        }else if(buttonIndex == 1){
            [alertView close];
        }
    };
    [self.view endEditing:YES];
    [alertView show];
}


- (void) setSubTitleView {
    UIView *subTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 80)];
    subTitleView.backgroundColor = [UIColor colorWithRed:3.0f/255.0f green:96.0f/255.0f blue:169.0f/255.0f alpha:1];
    // 电梯编号
    UILabel *evelatorNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 16, 80, 20)];
    evelatorNumLabel.textColor = [UIColor whiteColor];
    evelatorNumLabel.text =[NSString stringWithFormat:@"%@:",SZLocal(@"dialog.title.Elevator number")];
    UILabel *evelatorNumText =[[UILabel alloc]initWithFrame:CGRectMake(100, 16, 120, 20)];
    evelatorNumText.textColor = [UIColor whiteColor];
    evelatorNumText.text = self.item.UnitNo;
    // 计划日期
    UILabel *plannedDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 44, 80, 20)];
    plannedDateLabel.textColor = [UIColor whiteColor];
    plannedDateLabel.text = [NSString stringWithFormat:@"%@:",SZLocal(@"title.planeDate")];;
    UILabel *plannedDateText =[[UILabel alloc]initWithFrame:CGRectMake(100, 44, 120, 20)];
    plannedDateText.textColor = [UIColor whiteColor];
    plannedDateText.text = self.item.CheckDateStr;
    
    [subTitleView addSubview:evelatorNumLabel];
    [subTitleView addSubview:evelatorNumText];
    [subTitleView addSubview:plannedDateLabel];
    [subTitleView addSubview:plannedDateText];
    
    [self.view addSubview:subTitleView];
}

-(void)okAct{
    
   
   
    
    
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        SZMachineRoomViewController *mr = [self.childViewControllers objectAtIndex:0];
        
        BOOL ret1 = [NSMutableArray whetherEachGroupHasSelectedElementsWithArray:mr.titleArray];
        
        
        SZCarTopViewController *carTop = [self.childViewControllers objectAtIndex:1];
        
        BOOL ret2 = [NSMutableArray whetherEachGroupHasSelectedElementsWithArray:carTop.titleArray];
        
        
        SZPitViewController *pit = [self.childViewControllers objectAtIndex:2];
        
        BOOL ret3 = [NSMutableArray whetherEachGroupHasSelectedElementsWithArray:pit.titleArray];
        
        
        
        /**
         *  得到选中的JHA项目数组
         */
        NSMutableArray *arraySelected = [NSMutableArray arrayWithArray:[NSMutableArray selectedElementsWithArray:mr.titleArray]];
        [arraySelected addObjectsFromArray:[NSMutableArray selectedElementsWithArray:carTop.titleArray]];
        [arraySelected addObjectsFromArray:[NSMutableArray selectedElementsWithArray:pit.titleArray]];
        /**
         *  保存JHA项目
         */
        [SZModuleQueryTool storageJHAItemsWithSelectedJHAArray:arraySelected andDetialItem:self.item andIsFixItem:self.IsFixItem];
        /**
         *  保存t_QRCode(如果没有进行过正常维保操作就保存一条操作记录，如果有进行过完整的维保操作，就不保存)
         */
        NSNumber *scheduleID = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d",(int)self.item.ScheduleID]];
        if (scheduleID.integerValue != self.item.ScheduleID) {//没有进行过正常维保操作（不会产生一条维保记录）
            [SZTable_QRCode storageWeiBaoWorkingHoursWithParams:self.item andGroupID:0 withProperty:1];
        }
        
        self.arrayCompetedJHA = nil;
        
        int ret4 = [NSMutableArray whetherHadSelectedElementsWithArray:self.arrayCompetedJHA];
        
        /**
          *  保存Report,不是维修换件的时候，如果有维修换件，需要加参数
          */
        [SZTable_Report storageJHAWithDetialItem:self.item andinputMode:self.inputMode];
        
        dispatch_async(dispatch_get_main_queue(), ^{

            
//            if (self.IsFixItem) {
//                SZMaintenanceOperationViewController *vc = [[SZMaintenanceOperationViewController alloc] init];
//                vc.isJHAComplete = NO;
//                vc.isFixMode = YES;
//                vc.item = self.item;
//                [self.navigationController pushViewController:vc animated:YES];
//                return;
//            }
            
            if (self.isCheckItem) {//维保
        
                if ((ret1 || ret2 || ret3)||ret4) {
//                    WEAKSELF
                    if (ret4 == 2||ret4 == 0) {//JHA没做完
                        
                            CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                                            dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                                         dialogContents:SZLocal(@"dialog.content.jha.aaa")
                                                                                                          dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
                            
                            alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
                                if (buttonIndex == 0) {
                                    SZMaintenanceOperationViewController *vc = [[SZMaintenanceOperationViewController alloc] init];
                                    vc.isJHAComplete = NO;
                                    vc.item = self.item;
                                    vc.isFixMode = self.item.isFixMode;
                                    [self.navigationController pushViewController:vc animated:YES];
                                }
                                [alertView close];
                            };
                        
                            [alertView show];
                        
                    }else{//JHA已做完
                        
                        SZMaintenanceOperationViewController *vc = [[SZMaintenanceOperationViewController alloc] init];
                        vc.isJHAComplete = YES;
                        vc.item = self.item;
                        vc.isFixMode = self.item.isFixMode;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@"person"
                                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                                     dialogContents:SZLocal(@"dialog.content.jha")
                                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
                        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
                            [alertView close];
                        };
                        [alertView show];
                    });
                }
        
            }else{//工时
        
                if (ret1 && ret2 && ret3) {
                    NSInteger yymmdd =  [NSDate currentYYMMDD];

                    NSString *strKey = [NSString stringWithFormat:@"%ld_%@ENDJHA",yymmdd,self.item.UnitNo];

                    if (![[NSUserDefaults standardUserDefaults] objectForKey:strKey]) {
                        [[NSUserDefaults standardUserDefaults] setObject:@([NSDate sinceDistantPastTime]) forKey:strKey];
//                        [[NSUserDefaults standardUserDefaults] setObject:@([NSDate sinceDistantPastTime]) forKey:@"ENDTIME"];
                    }
                    

                    SZInputWorkingHourViewController *vc = [[SZInputWorkingHourViewController alloc] init];
                    vc.inputMode = self.inputMode;
                    if (self.inputMode== 1 || self.inputMode== 2) { // 只要是工时进入，将状态传入工时页面;为2的情况，进入状态更新
                        [SZTable_Schedules updateAddLaborHoursState:1 andScheduleID:self.item.ScheduleID];

                    }
                        vc.item = self.item;
                        vc.scheduleID = self.item.ScheduleID;
                    
                        [self.navigationController pushViewController:vc animated:YES];

                
                }else {
                        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@"person"
                                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                                     dialogContents:SZLocal(@"dialog.content.jha.all")
                                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
                        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
                            [alertView close];
                        };
                        [alertView show];
                }
            }
        });
        
    });
}

-(void)setupChildVces
{

    NSArray *array = [SZModuleQueryTool quaryTitleNameWithCardType:self.item.CardType];

    SZJHATitleItem *jhaItem1 = (SZJHATitleItem *)array[0];
    SZJHATitleItem *jhaItem2 = (SZJHATitleItem *)array[1];
    SZJHATitleItem *jhaItem3 = (SZJHATitleItem *)array[2];

    

    NSMutableArray *array1 = [NSMutableArray array];
    NSMutableArray *array2 = [NSMutableArray array];
    NSMutableArray *array3 = [NSMutableArray array];

    
   
    for (SZJHATitleItem *jhaItem in self.arrayCompetedJHA) {
        
        if (jhaItem.JhaCodeId <= 26) {
            [array1 addObject:jhaItem];
        }else if ((jhaItem.JhaCodeId>26)&&(jhaItem.JhaCodeId < 53)){
            [array2 addObject:jhaItem];
        }else{
            [array3 addObject:jhaItem];
        }
    }
    
    SZMachineRoomViewController *mr = [[SZMachineRoomViewController alloc] init];
    mr.title = jhaItem1.title;
    mr.item = jhaItem1;
    mr.selectedtitleArray = array1;
    [self addChildViewController:mr];

    SZCarTopViewController *carTop = [[SZCarTopViewController alloc] init];
    carTop.title = jhaItem2.title;
    carTop.item = jhaItem2;
    carTop.selectedtitleArray = array2;
    [self addChildViewController:carTop];
    
    SZPitViewController *pit = [[SZPitViewController alloc] init];
    pit.title = jhaItem3.title;
    pit.item = jhaItem3;
    pit.selectedtitleArray = array3;
    [self addChildViewController:pit];
    
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [super scrollViewDidEndDecelerating:scrollView];
    [self.view endEditing:YES];
    /**
     *  根据子控制器的滚动判断标题
     */
//    self.title = [self.selectedButton.titleLabel.text isEqualToString:SZLocal(@"title.TwoWeeksViewController")]?[NSString stringWithFormat:@"23412432412"]:SZLocal(@"title.MaintenanceViewController");
    
}

@end
