//
//  SZPlain2ViewController.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZSelectWH2ViewController.h"
#import "SZFinalMaintenanceUnitItem.h"
#import "SZElevatorRepairTableViewCell.h"
#import "SZMaintainDetailViewController.h"
#import "SZManHourFillViewController.h"
#import "CustomIOSAlertView.h"
#import "SZNavigationController.h"
#import "SZBottomMainView.h"
#import "SZTable_LaborType.h"
#import "LBXScan/LBXScanView.h"
#import "LBXScan/LBXScanViewController.h"
#import "SubLBXScanViewController.h"
#import "SZScanErrorViewController.h"
#import "SZFinalMaintenanceUnitItem.h"
#import "SZModuleQueryTool.h"
#import "SZTable_QRCode.h"


@interface SZSelectWH2ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic , strong)  SZBottomMainView *bottomMainView;

@property (nonatomic , strong) SZLabor *labor;

@end

@implementation SZSelectWH2ViewController

- (BOOL)shouldAutorotate{
    
    return NO;
}
-(SZBottomMainView *) bottomMainView{
    
    if(_bottomMainView ==nil){
        _bottomMainView =[SZBottomMainView loadSZBottomMainView];
        _bottomMainView.frame = CGRectMake(0,SCREEN_HEIGHT-OTIS_BottomOperationH, SCREEN_WIDTH, OTIS_BottomOperationH);
        [_bottomMainView.scanBtn setImage:[UIImage imageNamed:@"btn_allSelect_blue"] forState:0];
        [_bottomMainView.scanBtn setTitle:SZLocal(@"btn.title.allSelect") forState:0];
        [_bottomMainView.findBtn setImage:[UIImage imageNamed:@"btn_confirm"] forState:0];
        [_bottomMainView.findBtn setTitle:SZLocal(@"btn.title.confirm") forState:0];
        [self.view addSubview:_bottomMainView];
    }
    return _bottomMainView;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SZFinalMaintenanceUnitItem *gb = self.records[0];

    [self setSubTitleWithName:gb.BuildingName];

    [self setTableView];
    self.title = [NSString stringWithFormat:@"%@－%@",SZLocal(@"title.WorkingHoursViewController"), self.labor.LaborName];
    

    
    WEAKSELF
    self.bottomMainView.scanBtnClickBlock = ^(UIButton * scanBtn) {
        [weakSelf selectedAll];
    };
    self.bottomMainView.findBtnClickBlock = ^(UIButton * scanBtn) {
        [weakSelf okAct];
    };
    
}

-(BOOL)allSelected{
    for (SZFinalMaintenanceUnitItem *gb in self.records) {
        if (gb.selected == NO) {
            return NO;
        }
    }
    return YES;
}

- (void)selectedAll {
    
    if ([self allSelected]) {
        for (SZFinalMaintenanceUnitItem *gb in self.records) {
            gb.selected = NO;
        }
        [self.bottomMainView.scanBtn setTitle:SZLocal(@"btn.title.allSelect") forState:0];
    }else{
        for (SZFinalMaintenanceUnitItem *gb in self.records) {
            gb.selected = YES;
        }
        [self.bottomMainView.scanBtn setTitle:SZLocal(@"btn.title.noSelect") forState:0];
    }
    
    [self.tableView reloadData];
}

- (void)okAct {
//    NSMutableArray *arraySelected = [NSMutableArray array];
//    for (SZFinalMaintenanceUnitItem *gb in self.records) {
//        if (gb.selected == YES) {
//            [arraySelected addObject:gb];
//        }
//    }
    if (self.confirmActBlock) {
        self.confirmActBlock(self.records);
    }
    [self.navigationController popViewControllerAnimated:YES];

}


//返回每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.records.count;
}
//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1 创建可重用的自定义的cell
    SZElevatorRepairTableViewCell *cell = [SZElevatorRepairTableViewCell cellWithTableView:tableView];
    
    //2 设置cell内部的子控件
    SZFinalMaintenanceUnitItem *gb = self.records[indexPath.row];
    cell.maintain = gb;
    //3 返回
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    SZFinalMaintenanceUnitItem *item = self.records[indexPath.row];
    SZMaintainDetailViewController *controller = [[SZMaintainDetailViewController alloc] init];
    controller.scheduleID = item.ScheduleID;
    controller.isWorkingHours = YES;
    controller.isfentan = YES;
    controller.title = self.title;
    controller.unitNostr = item.UnitNo;
    [self.navigationController pushViewController:controller animated:YES];
    

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
        
        SZFinalMaintenanceUnitItem *unitItem = [self isExistenceWithQRCode:item];
        if (unitItem.UnitNo||unitItem.ScheduleID) {//如果找到了二维码
            SZMaintainDetailViewController *controller = [[SZMaintainDetailViewController alloc] init];
            controller.title = weakSelf.title;
            controller.isWorkingHours = YES;
            controller.scheduleID = unitItem.ScheduleID;
            controller.rCode = item.rCode;
            [weakSelf.navigationController pushViewController:controller animated:YES];
            
        }else{//如果没找到二维码
            //[weakSelf alertDialogShow];
            SZScanErrorViewController *controller = [[SZScanErrorViewController alloc] init];
            controller.title = weakSelf.title;
            controller.code = item.rCode;
            controller.tips = SZLocal(@"dialog.content.Two dimensional code recognition success, but the elevator is not in the current site!");
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }
    };
    vc.style = style;
    //vc.isOpenInterestRect = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


// 设置副标题
- (void) setSubTitleWithName :(NSString *)subTitleName {
    UIView *subTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
    subTitleView.backgroundColor = [UIColor colorWithRed:3.0f/255.0f green:96.0f/255.0f blue:169.0f/255.0f alpha:1.0f];
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH, 20)];
    subTitleLabel.text =subTitleName;
    subTitleLabel.textColor = [UIColor whiteColor];
    [subTitleView addSubview:subTitleLabel];
    [self.view addSubview:subTitleView];
}
// 设置TableView
- (void) setTableView {
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CXTitilesViewY + 40, SCREEN_WIDTH, SCREEN_HEIGHT - (CXTitilesViewY + 40 + OTIS_BottomOperationH))];
    tableView.delegate = self;
    tableView.dataSource =self;
    tableView.rowHeight = 77;
    tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

-(SZFinalMaintenanceUnitItem *)isExistenceWithQRCode:(SZQRCodeProcotolitem *)item{
    
    for (SZFinalMaintenanceUnitItem *unitItem in self.records) {
        
        if (item.strArray&&item.strArray.count) {
            
            if (unitItem.UnitRegcode == nil) continue;
            for (NSString *strCode in item.strArray) {
                if ([strCode containsString:unitItem.UnitRegcode]) {
                    return unitItem;
                }
            }
            
            
        }else{
            
            if (item.REG_CODE && [item.REG_CODE isEqualToString:unitItem.UnitRegcode]) {
                return unitItem;
            }else{
                
                if ([item.UNIT_NO isEqualToString:unitItem.UnitNo]) {
                    return unitItem;
                }
                
            }
            
            
        }
        
        
    }
    
    return nil;
}

@end
