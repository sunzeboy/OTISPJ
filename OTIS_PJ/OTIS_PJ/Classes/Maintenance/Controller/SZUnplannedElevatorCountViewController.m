//
//  SZUnplannedElevatorCountViewController.m
//  OTIS_PJ
//
//  Created by zhangyang on 16/5/13.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZUnplannedElevatorCountViewController.h"
#import "SZTableViewCell.h"
#import "SZModuleQueryTool.h"
#import "SZMaintainDetailViewController.h"
#import "SZFinalMaintenanceUnitItem.h"
#import "CustomIOSAlertView.h"
#import "LBXScanViewStyle.h"
#import "SubLBXScanViewController.h"
#import "SZScanErrorViewController.h"
#import "SZBottomMainView.h"
#import "NSDate+Extention.h"
#import "SZTable_QRCode.h"

@interface SZUnplannedElevatorCountViewController ()<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) NSArray *maintain;

@property (nonatomic , strong)  SZBottomMainView *bottomMainView;

@property (strong,nonatomic) UITableView *tableView;


@property (nonatomic , strong) UISearchBar *bar;

@property (nonatomic , assign) BOOL isHidden;

@property (nonatomic, strong) NSMutableArray *sousuoArray;
@end

@implementation SZUnplannedElevatorCountViewController
- (BOOL)shouldAutorotate{
    
    return NO;
}

- (NSMutableArray *)sousuoArray
{
    if (_sousuoArray ==nil) {
        _sousuoArray = [NSMutableArray array];
    }
    return _sousuoArray;
}
-(UISearchBar *)bar{
    if (!_bar) {
        _bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _bar.placeholder =[NSString stringWithFormat:@"%@/%@",SZLocal(@"dialog.title.Site name"),SZLocal(@"dialog.title.Elevator number")];
        _bar.delegate = self;
    }
    return _bar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sousuoArray = [NSMutableArray arrayWithArray:self.maintain];

    [self judgeNavTitle];
    [self setUpTableView];
    self.tableView.rowHeight = 81;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self bottomMainView];

    WEAKSELF
    self.bottomMainView.scanBtnClickBlock = ^(UIButton * scanBtn) {
        [weakSelf ZhiFuBaoStyle];
    };
    self.bottomMainView.findBtnClickBlock = ^(UIButton * scanBtn) {
        [weakSelf search];
    };
}

//1 懒加载
- (NSArray *)maintain
{
    if (_maintain ==nil) {
        _maintain = [SZModuleQueryTool queryOutsidePlanMaintenanceUnitsWithOutsidePlanMaintenanceItem:self.item];
    }
    return _maintain;
}

-(SZBottomMainView *) bottomMainView{
    
    if(_bottomMainView ==nil){
        _bottomMainView =[SZBottomMainView loadSZBottomMainView];
        _bottomMainView.frame = CGRectMake(0,SCREEN_HEIGHT-OTIS_BottomOperationH, SCREEN_WIDTH, OTIS_BottomOperationH);
        [self.view addSubview:_bottomMainView];
    }
    return _bottomMainView;
}

-(void)setUpTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 55) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource =self;
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
}
//返回每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sousuoArray.count;
}
//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1 创建可重用的自定义的cell
    SZTableViewCell *cell = [SZTableViewCell cellWithTableView:tableView];
    
    //2 设置cell内部的子控件
    SZFinalMaintenanceUnitItem *gb = self.sousuoArray[indexPath.row];
    cell.maintain = gb;
    //3 返回
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    

    
    __block NSInteger iCell = 0;
    __block NSString *cellContent = @"";
    [self.view endEditing:YES];

    
    SZFinalMaintenanceUnitItem *gb = self.sousuoArray[indexPath.row];
    
    BOOL isShowDlg = [SZTable_QRCode isShowQRSelectDlg:NO andScheduleID:(int)gb.ScheduleID];
    if(!isShowDlg){
        // 不显示DLG的情况下，直接进入详情
        SZMaintainDetailViewController *controller = [[SZMaintainDetailViewController alloc] init];
        controller.scheduleID = gb.ScheduleID;
        controller.title = self.title;
        controller.isDirectEntry = YES;
        [self.navigationController pushViewController:controller animated:YES];
        
        return;
    }
    
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
//            if (self.unPlanBlock) {
//                self.unPlanBlock();
//            }
            [self ZhiFuBaoStyle];
        } else if (iCell >= 0) {
            if (buttonIndex == 0) {
//                SZFinalOutsidePlanMaintenanceItem *item = weakSelf.maintain[indexPath.row];
//                SZUnplannedElevatorCountViewController *vc = [[SZUnplannedElevatorCountViewController alloc] init];
//                vc.item = item;
//                [weakSelf.navigationController pushViewController:vc animated:YES];
                SZFinalMaintenanceUnitItem *item = self.sousuoArray[indexPath.row];
                
                SZMaintainDetailViewController *controller = [[SZMaintainDetailViewController alloc] initWithBarcodeType:cellContent];
                controller.isWorkingHours = self.isWorkingHours;
                controller.scheduleID = item.ScheduleID;
                controller.title = SZLocal(@"title.UnplannedViewController");
                
                [self.navigationController pushViewController:controller animated:YES];
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
    vc.SuccessBlock = ^(SZQRCodeProcotolitem *item){
            
            SZFinalMaintenanceUnitItem *unitItem;
            
            unitItem = [self isExistenceWithQRCode:item];
                
            if (unitItem.UnitNo||unitItem.ScheduleID) {//如果找到了二维码
                SZMaintainDetailViewController *controller = [[SZMaintainDetailViewController alloc] init];
                controller.scheduleID = unitItem.ScheduleID;
                controller.title = self.selectTitle;
                controller.rCode = item.rCode;
                [self.navigationController pushViewController:controller animated:YES];
                    
            }else{//如果没找到二维码
                //[weakSelf alertDialogShow];
                SZScanErrorViewController *controller = [[SZScanErrorViewController alloc] init];
                controller.title = self.selectTitle;
                controller.planDateStr =[NSString stringWithFormat:@"%@:",SZLocal(@"title.planeDate")];
                controller.code = item.rCode;
                if ([self isExistenceOutRange:item].ScheduleID != 0) {
                    controller.tips=SZLocal(@"dialog.content.Two dimensional code recognition success");
                } else {
                    controller.tips = SZLocal(@"dialog.content.Do not belong to the elevator maintenance plan");
                    controller.tips2 = SZLocal(@"error.OTISScanOrSelectElevator");
                }
                [self.navigationController pushViewController:controller animated:YES];
                    
            }
    };
    vc.style = style;
    //vc.isOpenInterestRect = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)judgeNavTitle {
    
    NSString *one = [NSDate thisWeekMondayOrNextWeekSunday:@"Monday"];
    NSString *two = [NSDate thisWeekMondayOrNextWeekSunday:@"Sunday"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 200, 44)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment =  NSTextAlignmentCenter;
    
    titleLabel.font = [UIFont boldSystemFontOfSize:13];
    
    titleLabel.text = [NSString stringWithFormat:@"%@-%@",one,two];
    
    self.navigationItem.titleView = titleLabel;
}

+(NSString *)thisWeekMondayOrNextWeekSunday:(NSString *)dayOfTheWeek{
    
    //获取系统当前时间
    NSDate*day=[NSDate thisWeekMondayOrNextSunday:dayOfTheWeek];
    //用于格式化NSDate对象
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    //NSDate转NSString
    return [dateFormatter stringFromDate:day];
}



#pragma mark - UISearchBarDelegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self.sousuoArray removeAllObjects];
    NSString *studentUp  = [searchText uppercaseString];
    if ([searchText isEqualToString: @""]) self.sousuoArray = [NSMutableArray arrayWithArray:self.maintain];
    for (SZFinalMaintenanceUnitItem *unitItem in self.maintain) {
        if ([unitItem.BuildingName containsString:searchText]||[unitItem.UnitNo containsString:searchText]||[unitItem.UnitNo containsString:studentUp]) {
            [self.sousuoArray addObject:unitItem];
        }
    }

    [self.tableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(void)search{
    self.isHidden = !self.isHidden;
}


-(void)setIsHidden:(BOOL)isHidden{
    _isHidden = isHidden;
    if (!isHidden) {
        self.tableView.tableHeaderView = nil;
    }else{
        self.bar.text = @"";
        self.tableView.tableHeaderView = self.bar;
        CGPoint offect = self.tableView.contentOffset;
        offect.y = - self.tableView.contentInset.top;
        [self.tableView setContentOffset:offect animated:YES];
    }
}

//-(SZFinalMaintenanceUnitItem *)isExistenceWithQRCode:(NSArray *)arrayCode{
//    SZLog(@"%@",arrayCode[0]);
//    
//    for (SZFinalMaintenanceUnitItem *unitItem in self.maintain) {
//        SZLog(@"%@/n",unitItem.UnitRegcode);
//
//        if (unitItem.UnitRegcode == nil) continue;
//        for (NSString *strCode in arrayCode) {
//            if ([strCode containsString:unitItem.UnitRegcode]) {
//                return unitItem;
//            }
//        }
//    }
//    return nil;
//}

-(SZFinalMaintenanceUnitItem *)isExistenceWithQRCode:(SZQRCodeProcotolitem *)item{
    
    for (SZFinalMaintenanceUnitItem *unitItem in self.maintain) {
        
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
    
   return [SZModuleQueryTool queryOutsideUnitesWithUnitRegcodes:item];
    
}
@end
