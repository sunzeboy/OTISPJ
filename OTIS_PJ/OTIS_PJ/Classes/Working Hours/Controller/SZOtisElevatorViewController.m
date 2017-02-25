//
//  SZOtisElevatorViewController.m
//  OTIS_PJ
//  在保电梯
//  Created by zy on 16/5/9.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZOtisElevatorViewController.h"
#import "SZFinalOutsidePlanMaintenanceItem.h"
#import "SZElevatorInfoTableViewCell.h"
#import "SZOtisElevatorSelectViewController.h"
#import "SZModuleQueryTool.h"
#import "SZBottomWorkingHourView.h"
#import "SZNavigationController.h"
#import "LBXScan/LBXScanView.h"
#import "LBXScan/LBXScanViewController.h"
#import "SubLBXScanViewController.h"
#import "SZMaintainDetailViewController.h"
#import "SZScanErrorViewController.h"
#import "SZFinalMaintenanceUnitItem.h"
#import "SZBottomMainView.h"

@interface SZOtisElevatorViewController ()<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) NSArray *elevatorInfo;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic , strong)  SZBottomMainView *workingHourView;

@property (nonatomic , strong) UISearchBar *bar;

@property (nonatomic , assign) BOOL isHidden;

@property (nonatomic, strong) NSMutableArray *sousuoArray;

@end

@implementation SZOtisElevatorViewController
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
        _bar.placeholder =[NSString stringWithFormat:@"%@/%@",SZLocal(@"dialog.title.Site name"),SZLocal(@"dialog.title.Address name")];

        _bar.delegate = self;
    }
    return _bar;
}

//1 懒加载
- (NSArray *)elevatorInfo
{
    if (_elevatorInfo ==nil) {
        _elevatorInfo = [SZModuleQueryTool queryTheGongShiGongdiList];
    }
    return _elevatorInfo;
}

-(SZBottomMainView *) workingHourView{
    
    if(_workingHourView ==nil){
        _workingHourView =[SZBottomMainView loadSZBottomMainView];
        _workingHourView.frame = CGRectMake(0,SCREEN_HEIGHT-OTIS_BottomOperationH-5, SCREEN_WIDTH, OTIS_BottomOperationH);
        [self.view addSubview:_workingHourView];
    }
    return _workingHourView;
}

-(void)setUpTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CXTitilesViewY + CXTitilesViewH, SCREEN_WIDTH, SCREEN_HEIGHT - CXTitilesViewY -CXTitilesViewH - OTIS_BottomOperationH) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource =self;
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.sousuoArray = [NSMutableArray arrayWithArray:self.elevatorInfo];

    [self setUpTableView];
    [self workingHourView];
    self.tableView.rowHeight = 81;
    
    WEAKSELF
    self.workingHourView.scanBtnClickBlock = ^(UIButton * scanBtn) {
        [weakSelf ZhiFuBaoStyle];
    };
    self.workingHourView.findBtnClickBlock = ^(UIButton * scanBtn) {
        [weakSelf search];
    };
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
    SZElevatorInfoTableViewCell *cell = [SZElevatorInfoTableViewCell cellWithTableView:tableView];
    
    //2 设置cell内部的子控件
    SZFinalOutsidePlanMaintenanceItem *item = self.sousuoArray[indexPath.row];

    cell.maintain= item;
    //3 返回
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SZNavigationController *nav = (SZNavigationController*)self.navigationController;
    nav.laborProperty = 1;
    SZOtisElevatorSelectViewController *controller = [[SZOtisElevatorSelectViewController alloc] init];
    controller.item = self.sousuoArray[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - UISearchBarDelegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self.sousuoArray removeAllObjects];
    SZLog(@"%@",searchText);
    if ([searchText isEqualToString: @""]) self.sousuoArray = [NSMutableArray arrayWithArray:self.elevatorInfo];
    for (SZFinalOutsidePlanMaintenanceItem *unitItem in self.elevatorInfo) {
        if ([unitItem.BuildingName containsString:searchText]||[unitItem.BuildingAddr containsString:searchText]) {
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
        self.bar.placeholder = [NSString stringWithFormat:@"%@/%@",SZLocal(@"dialog.title.Site name"),SZLocal(@"dialog.title.Address name")];
        CGPoint offect = self.tableView.contentOffset;
        offect.y = - self.tableView.contentInset.top;
        [self.tableView setContentOffset:offect animated:YES];
    }
    
}

#pragma mark --模仿支付宝
- (void)ZhiFuBaoStyle
{
    
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 60;
    style.xScanRetangleOffset = 30;
    
    if ([UIScreen mainScreen].bounds.size.height <= 480)
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
        if ((unitItem.UnitNo && unitItem.UnitNo.length)||(unitItem.ScheduleID)) {//如果找到了二维码
            SZMaintainDetailViewController *controller = [[SZMaintainDetailViewController alloc] init];
            controller.title = self.superTitle;
            controller.unitNostr = unitItem.UnitNo;
            controller.rCode = item.rCode;
            controller.isWorkingHours = YES;
            [weakSelf.navigationController pushViewController:controller animated:YES];
            
        }else{//如果没找到二维码
            //[weakSelf alertDialogShow];
            SZScanErrorViewController *controller = [[SZScanErrorViewController alloc] init];
            controller.title = self.superTitle;
            controller.code = item.rCode;
            //controller.tips = [NSString stringWithFormat:@"二维码扫描成功，但不属于%@维保电梯！",weakSelf.selectedButton.titleLabel.text];
            controller.tips = SZLocal(@"error.Two dimensional code scanning success, but can not recognize the elevator!");
            controller.tips2 = SZLocal(@"error.OTISSelectElevator");
            controller.planDateStr = @"";
            [controller.planDate setHidden:YES];
            //SZLog(@"%@ ",weakSelf.selectedButton.titleLabel.text);
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }
    };
    vc.style = style;
    //vc.isOpenInterestRect = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//-(SZFinalMaintenanceUnitItem *)isExistenceWithQRCode:(NSArray *)arrayCode{
//    return [SZModuleQueryTool queryOutsideUnitesWithUnitRegcodes:arrayCode];
//}

-(SZFinalMaintenanceUnitItem *)isExistenceWithQRCode:(SZQRCodeProcotolitem *)item{
    
    
    return [SZModuleQueryTool queryGongshiUnitesWithUnitRegcodes:item];
    
}



@end
