//
//  SZSelectWHViewController.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZSelectWHViewController.h"
#import "SZModuleQueryTool.h"
#import "SZFinalMaintenanceUnitItem.h"
#import "SZElevatorRepairTableViewCell.h"
#import "SZMaintainDetailViewController.h"
#import "SZManHourFillViewController.h"
#import "CustomIOSAlertView.h"
#import "SZNavigationController.h"
#import "SZBottomMainView.h"
#import "LBXScan/LBXScanView.h"
#import "LBXScan/LBXScanViewController.h"
#import "SubLBXScanViewController.h"
#import "SZInputWorkingHourViewController.h"
#import "SZTable_LaborType.h"
#import "SZScanErrorViewController.h"
#import "SZTable_QRCode.h"


@interface SZSelectWHViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *records;

@property (nonatomic , assign) BOOL isHidden;

@property (nonatomic , strong) UISearchBar *bar;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic , strong) SZLabor *labor;

@property (nonatomic , strong)  SZBottomMainView *bottomMainView;

@end

@implementation SZSelectWHViewController
- (BOOL)shouldAutorotate{
    
    return NO;
}
//1 懒加载
- (NSArray *)records
{
    if (_records ==nil) {
//        _records = [SZModuleQueryTool queryTheCompanyMaintenanceElevatorsWithOutsidePlanMaintenanceItem:self.item];
        _records = [SZModuleQueryTool queryGongshiOutsidePlanMaintenanceUnitsWithOutsidePlanMaintenanceItem:self.item];;

    }
    return _records;
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

-(SZBottomMainView *) bottomMainView{
    
    if(_bottomMainView ==nil){
        _bottomMainView =[SZBottomMainView loadSZBottomMainView];
        _bottomMainView.frame = CGRectMake(0,SCREEN_HEIGHT-OTIS_BottomOperationH, SCREEN_WIDTH, OTIS_BottomOperationH);
        [_bottomMainView.findBtn setImage:[UIImage imageNamed:@"btn_confirm"] forState:0];
        [_bottomMainView.findBtn setTitle:SZLocal(@"btn.title.confirm") forState:0];
        [self.view addSubview:_bottomMainView];
    }
    return _bottomMainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubTitleWithName:self.item.BuildingName];
    [self setTableView];
    [self bottomMainView];
    self.title = self.title = [NSString stringWithFormat:@"%@－%@",SZLocal(@"title.WorkingHoursViewController"), self.labor.LaborName];
    
    SZNavigationController *nav = (SZNavigationController*)self.navigationController;
    nav.popVc = self;
    
    if (nav.laborTypeID == 9||nav.laborTypeID == 10) {
        for (SZFinalMaintenanceUnitItem *item in self.records) {
            item.showSelected = YES;
        }
        WEAKSELF
        self.bottomMainView.scanBtnClickBlock = ^(UIButton * scanBtn) {
            [weakSelf ZhiFuBaoStyle];
        };
        self.bottomMainView.findBtnClickBlock = ^(UIButton * scanBtn) {
            [weakSelf okAct];
        };
    }
   

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
            controller.scheduleID = unitItem.ScheduleID;
            controller.unitNostr = unitItem.UnitNo;
            controller.rCode = item.rCode;
            controller.isWorkingHours = YES;
            [weakSelf.navigationController pushViewController:controller animated:YES];
            
        }else{//如果没找到二维码
            //[weakSelf alertDialogShow];
            SZScanErrorViewController *controller = [[SZScanErrorViewController alloc] init];
            controller.title = weakSelf.title;
            controller.code = item.rCode;
            SZFinalMaintenanceUnitItem * findItem = [self isExistenceOutRange:item];
            if (findItem.ScheduleID != 0||findItem.UnitNo.length) {
                controller.tips=SZLocal(@"dialog.content.Two dimensional code recognition success, but the elevator is not in the current site!");
            } else  {
                controller.tips = SZLocal(@"error.Two dimensional code scanning success, but can not recognize the elevator!");
                controller.tips2 = SZLocal(@"error.OTISSelectElevator");
            }
            [weakSelf.navigationController pushViewController:controller animated:YES];
            
        }
    };
    vc.style = style;
    //vc.isOpenInterestRect = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
-(SZFinalMaintenanceUnitItem *)isExistenceOutRange:(SZQRCodeProcotolitem *)item{
    
    return [SZModuleQueryTool queryGongshiUnitesWithUnitRegcodes:item];
}




- (void)okAct {
    
//    NSMutableArray *arraySelected = [NSMutableArray array];
    BOOL canjump = NO;
    for (SZFinalMaintenanceUnitItem *item in self.records) {
        if (item.selected == YES) {
            canjump = YES;
            break;
//            [arraySelected addObject:item];
        }
    }
    if (!canjump) {
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:SZLocal(@"dialog.content.fentandianti")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            [alertView close];
        };
        [alertView show];
    }else{
    
        SZInputWorkingHourViewController *controller = [[SZInputWorkingHourViewController alloc] init];
        controller.records = self.records;
        controller.outItem = self.item;
        [self.navigationController pushViewController:controller animated:YES];
    }


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
    
    WEAKSELF
    
    __block NSInteger iCell = 0;
    __block NSString *cellContent = @"";
    
    [self.view endEditing:YES];

    
    SZFinalMaintenanceUnitItem *gb = self.records[indexPath.row];
    CustomIOSAlertView *alertView = nil;
    BOOL ret = [SZTable_QRCode hasScandWithUnitNo:gb.UnitNo];
    if (ret) {
        
        alertView = [[CustomIOSAlertView alloc] initSelectDialogVieWithImageName:@""
                                                                     dialogTitle:SZLocal(@"dialog.title.selectNext")
                                                                  dialogContents:[NSMutableArray arrayWithObjects:SZLocal(@"dialog.content.scanBarcode"),
                                                                                  SZLocal(@"dialog.content.noBarcodeButExist"),
                                                                                  SZLocal(@"dialog.content.canNotIdentify"),nil]
                                                                   dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),
                                                                                  SZLocal(@"btn.title.cencel"), nil]];
        
    } else {
        
        alertView = [[CustomIOSAlertView alloc] initSelectDialogVieWithImageName:@""
                                                                     dialogTitle:SZLocal(@"dialog.title.selectNext")
                                                                  dialogContents:[NSMutableArray arrayWithObjects:SZLocal(@"dialog.content.scanBarcode"),
                                                                                  SZLocal(@"dialog.content.noBarcode"),
                                                                                  SZLocal(@"dialog.content.canNotIdentify"),nil]
                                                                   dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),
                                                                                  SZLocal(@"btn.title.cencel"), nil]];
        
    }

    

    
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        if (iCell == 0 && buttonIndex == 0) {
            [alertView close];
            [self ZhiFuBaoStyle];
        } else if (iCell > 0) {
            if (buttonIndex == 0) {
                SZFinalMaintenanceUnitItem *item = weakSelf.records[indexPath.row];
                SZMaintainDetailViewController *controller = [[SZMaintainDetailViewController alloc] initWithBarcodeType:cellContent];
                controller.scheduleID = item.ScheduleID;
                controller.isWorkingHours = YES;
                controller.title = self.title;
                controller.unitNostr = item.UnitNo;
                
                [weakSelf.navigationController pushViewController:controller animated:YES];
                [alertView close];
            } else {
                [alertView close];
            }
        } else if (buttonIndex == 1){
            [alertView close];
        }
    };
    
    alertView.onTableViewSelect = ^(SZBaseLineViewCell *cell, NSInteger cellIndex){
        iCell = cellIndex;
        if (cellIndex >= 0) {
            cellContent = cell.contentLabel.text;
        }
    };
    [alertView show];

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
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CXTitilesViewY + 40, SCREEN_WIDTH, SCREEN_HEIGHT - (104 + OTIS_BottomOperationH))];
    tableView.delegate = self;
    tableView.dataSource =self;
    tableView.rowHeight = 77;
    tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView];
}


@end
