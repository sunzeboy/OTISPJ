//
//  MaintenanceViewController.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/21.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "MaintenanceViewController.h"
#import "SZNavigationController.h"
#import "LBXScan/LBXScanView.h"
#import "LBXScan/LBXScanViewController.h"
#import "SubLBXScanViewController.h"
#import "SZModuleQueryTool.h"
#import "SZFinalMaintenanceUnitItem.h"
#import "SZMaintainDetailViewController.h"
#import "CustomIOSAlertView.h"
#import "UIBarButtonItem+Extention.h"
#import "SZScanErrorViewController.h"
#import "NSDate+Extention.h"
#import "UnplannedViewController.h"
#import "SZBottomMainView.h"
#import "MASConstraintMaker.h"
#import "View+MASAdditions.h"

#import "SignViewController.h"

@interface MaintenanceViewController ()

@property (nonatomic , strong)  SZBottomMainView *bottomMainView;

@end

@implementation MaintenanceViewController



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    TodayViewController *today = [self.childViewControllers objectAtIndex:0];
    [today viewWillAppear:YES];
    
}


-(SZBottomMainView *) bottomMainView{
    
    if(_bottomMainView ==nil){
        _bottomMainView =[SZBottomMainView loadSZBottomMainView];
        _bottomMainView.frame = CGRectMake(0,SCREEN_HEIGHT-OTIS_BottomOperationH, SCREEN_WIDTH, OTIS_BottomOperationH);
        [self.view addSubview:_bottomMainView];
    }
    return _bottomMainView;
}

-(void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    [self bottomMainView];
    WEAKSELF
    self.bottomMainView.scanBtnClickBlock = ^(UIButton * scanBtn) {
        [weakSelf ZhiFuBaoStyle];
    };
    self.bottomMainView.findBtnClickBlock = ^(UIButton * scanBtn) {
        [weakSelf search];
    };
    self.title = SZLocal(@"title.MaintenanceViewController");
    
    SZNavigationController *nav = (SZNavigationController*)self.navigationController;
    nav.laborTypeID = 0;
    nav.popVc = self;
    //    [self addObserver: self forKeyPath: @"contentOffset" options: NSKeyValueChangeNewKey context: nil];
    
}



-(void)search{
    
    for (UIViewController *childViewController in self.childViewControllers) {
        
        if ([childViewController.title isEqualToString:self.selectedButton.titleLabel.text]) {
            
            if ([childViewController.title isEqualToString:SZLocal(@"title.TodayViewController")]) {
                
                TodayViewController *today = (TodayViewController *)childViewController;
                today.isHidden = !today.isHidden;
                break;
                
            }else if ([childViewController.title isEqualToString:SZLocal(@"title.NotCompletedViewController")]){
                NotCompletedViewController *notCompleted = (NotCompletedViewController *)childViewController;
                notCompleted.isHidden = !notCompleted.isHidden;
                break;
            }else if ([childViewController.title isEqualToString:SZLocal(@"title.TwoWeeksViewController")]){
                TwoWeeksViewController *twoWeeks = (TwoWeeksViewController *)childViewController;
                twoWeeks.isHidden = !twoWeeks.isHidden;
                break;
            }else if ([childViewController.title isEqualToString:SZLocal(@"title.UnplannedViewController")]){
                UnplannedViewController *unPlanned = (UnplannedViewController *)childViewController;
                unPlanned.isHidden = !unPlanned.isHidden;
                break;
            }
        }
    }
}

-(void)unitRegcode{
    
    [self ZhiFuBaoStyle];
}


#pragma mark --模仿支付宝
- (void)ZhiFuBaoStyle
{
    
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 60;
    style.xScanRetangleOffset = 30;
    
    if ([UIScreen mainScreen].bounds.size.height <= 480 )
    {
        //3.5inch 显示的扫码缩小
        style.centerUpOffset = 40;
        style.xScanRetangleOffset = 20;
    }
    
    
    style.alpa_notRecoginitonArea = 0.6;
    
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 2.0;
    style.photoframeAngleW = 16;
    style.photoframeAngleH = 16;
    
    style.isNeedShowRetangle = NO;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    
    //使用的支付宝里面网格图片
    UIImage *imgFullNet = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_full_net"];
    
    style.animationImage = imgFullNet;
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    
    WEAKSELF
    vc.SuccessBlock = ^(SZQRCodeProcotolitem *item){
        
        SZFinalMaintenanceUnitItem *unitItem;
        
        for (UIViewController *childViewController in self.childViewControllers) {
            
            
            if ([childViewController.title isEqualToString:weakSelf.selectedButton.titleLabel.text]) {
                
                if ([childViewController.title isEqualToString:SZLocal(@"title.TodayViewController")]) {
                    TodayViewController *today = (TodayViewController *)childViewController;
                    unitItem = [today isExistenceWithQRCode:item];
                    break;
                }else if ([childViewController.title isEqualToString:SZLocal(@"title.NotCompletedViewController")]){
                    NotCompletedViewController *notCompleted = (NotCompletedViewController *)childViewController;
                    unitItem = [notCompleted isExistenceWithQRCode:item];
                    break;
                }else if ([childViewController.title isEqualToString:SZLocal(@"title.TwoWeeksViewController")]){
                    TwoWeeksViewController *twoWeeks = (TwoWeeksViewController *)childViewController;
                    unitItem = [twoWeeks isExistenceWithQRCode:item];
                    break;
                }else if ([childViewController.title isEqualToString:SZLocal(@"title.UnplannedViewController")]){
                    UnplannedViewController *unPlanned = (UnplannedViewController *)childViewController;
                    unitItem = [unPlanned isExistenceWithQRCode:item];
                    break;
                }
            }
        }
        
        if (unitItem.ScheduleID!=0) {//如果找到了二维码
            SZMaintainDetailViewController *controller = [[SZMaintainDetailViewController alloc] init];
            controller.title = weakSelf.selectedButton.titleLabel.text;
            controller.scheduleID = unitItem.ScheduleID;
            controller.rCode = item.rCode;
            controller.isDirectEntry = NO;
            controller.isWorkingHours = unitItem.isFixMode;
            controller.isFixMode = unitItem.isFixMode;
            [weakSelf.navigationController pushViewController:controller animated:YES];
            
        }else{//如果没找到二维码
            //[weakSelf alertDialogShow];
            SZScanErrorViewController *controller = [[SZScanErrorViewController alloc] init];
            controller.title = weakSelf.selectedButton.titleLabel.text;
            controller.code = item.rCode;
            controller.planDateStr =[NSString stringWithFormat:@"%@:",SZLocal(@"title.planeDate")];
            controller.tips = [NSString stringWithFormat:@"二维码扫描成功，但不属于%@维保电梯！",weakSelf.selectedButton.titleLabel.text];
            controller.tips2 = SZLocal(@"error.OTISScanOrSelectElevator");
            
            [weakSelf.navigationController pushViewController:controller animated:YES];
            
        }
        
    };
    vc.style = style;
    //vc.isOpenInterestRect = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setupChildVces
{
    TodayViewController *today = [[TodayViewController alloc] init];
    today.title = SZLocal(@"title.TodayViewController");
    today.delegate = self;
    [self addChildViewController:today];
    
    NotCompletedViewController *notCompleted = [[NotCompletedViewController alloc] init];
    notCompleted.delegate = self;
    notCompleted.title = SZLocal(@"title.NotCompletedViewController");
    [self addChildViewController:notCompleted];
    
    TwoWeeksViewController *twoWeeks = [[TwoWeeksViewController alloc] init];
    twoWeeks.title = SZLocal(@"title.TwoWeeksViewController");
    twoWeeks.delegate = self;
    [self addChildViewController:twoWeeks];
    
    UnplannedViewController *unPlanned = [[UnplannedViewController alloc] init];
    unPlanned.title = SZLocal(@"title.UnplannedViewController");
    unPlanned.isWorkingHours = NO;
    unPlanned.delegate=self;
    [self addChildViewController:unPlanned];
    
//    SignViewController *signVc = [[SignViewController alloc] init];
//    signVc.title = SZLocal(@"title.signViewController");
//    [self addChildViewController:signVc];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [super scrollViewDidEndDecelerating:scrollView];
    [self initSearchState];
    for (UIViewController *childViewController in self.childViewControllers){
        [childViewController.view endEditing:YES];
    }
    /**
     *  根据子控制器的滚动判断标题
     */
    [self judgeNavTitleWithBtn:nil];
}

-(void)clickTitle:(UIButton *)button{
    [super clickTitle:button];
    [self initSearchState];
    for (UIViewController *childViewController in self.childViewControllers){
        [childViewController.view endEditing:YES];
    }
    [self judgeNavTitleWithBtn:button];
}

-(void)judgeNavTitleWithBtn:(UIButton *)btn{
    
    NSString *one = [NSDate thisWeekMondayOrNextWeekSunday:@"Monday"];
    NSString *two = [NSDate thisWeekMondayOrNextWeekSunday:@"Sunday"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,70, 44)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment =  NSTextAlignmentCenter;
    
    self.bottomMainView.hidden = NO;
    
    if ([self.selectedButton.titleLabel.text isEqualToString:SZLocal(@"title.TwoWeeksViewController")]) {
        titleLabel.font = [UIFont boldSystemFontOfSize:13];
        titleLabel.text = [NSString stringWithFormat:@"%@-%@",one,two];
        self.navigationItem.titleView = titleLabel;
    }else if([self.selectedButton.titleLabel.text isEqualToString:SZLocal(@"title.signViewController")]){
        
        self.bottomMainView.hidden = YES;
        
    }else {
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.text = SZLocal(@"title.MaintenanceViewController");
        self.navigationItem.titleView = titleLabel;
    }
    
}

-(void)initSearchState{
    
    for (UIViewController *childViewController in self.childViewControllers) {
        
        if ([childViewController.title isEqualToString:self.selectedButton.titleLabel.text]) {
            
            if ([childViewController.title isEqualToString:SZLocal(@"title.TodayViewController")]) {
                
                TodayViewController *today = (TodayViewController *)childViewController;
                today.isHidden=NO;
                break;
                
            }else if ([childViewController.title isEqualToString:SZLocal(@"title.NotCompletedViewController")]){
                NotCompletedViewController *notCompleted = (NotCompletedViewController *)childViewController;
                notCompleted.isHidden = NO;
                break;
            }else if ([childViewController.title isEqualToString:SZLocal(@"title.TwoWeeksViewController")]){
                TwoWeeksViewController *twoWeeks = (TwoWeeksViewController *)childViewController;
                twoWeeks.isHidden = NO;
                break;
            }else if ([childViewController.title isEqualToString:SZLocal(@"title.UnplannedViewController")]){
                UnplannedViewController *unPlanned = (UnplannedViewController *)childViewController;
                unPlanned.isHidden = NO;
                break;
            }
        }
    }
}






@end
