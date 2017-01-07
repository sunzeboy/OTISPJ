//
//  SZPlainViewController.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZPlainViewController.h"

#import "SZFinalOutsidePlanMaintenanceItem.h"
#import "SZElevatorInfoTableViewCell.h"
#import "SZSelectWHViewController.h"
#import "SZModuleQueryTool.h"
#import "SZBottomWorkingHourView.h"
#import "SZNavigationController.h"
#import "MASConstraintMaker.h"
#import "View+MASAdditions.h"
#import "LBXScanViewStyle.h"
#import "SubLBXScanViewController.h"
#import "SZFinalMaintenanceUnitItem.h"
#import "SZMaintainDetailViewController.h"
#import "SZScanErrorViewController.h"
#import "SZOtisElevatorSelectViewController.h"

@interface SZPlainViewController ()<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) NSArray *elevatorInfo;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic , strong)  SZBottomWorkingHourView *workingHourView;

@property (nonatomic , strong) UISearchBar *bar;

@property (nonatomic , assign) BOOL isHidden;

@property (nonatomic, strong) NSMutableArray *sousuoArray;
@end

@implementation SZPlainViewController

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
        _bar.placeholder = [NSString stringWithFormat:@"%@/%@",SZLocal(@"dialog.title.Site name"),SZLocal(@"dialog.title.Address name")];
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

-(SZBottomWorkingHourView *) workingHourView{
    
    if(_workingHourView ==nil){
        _workingHourView =[SZBottomWorkingHourView loadSZBottomWorkingHourView];
        _workingHourView.frame = CGRectMake(0,SCREEN_HEIGHT-OTIS_BottomOperationH, SCREEN_WIDTH, OTIS_BottomOperationH);
        [self.view addSubview:_workingHourView];
    }
    return _workingHourView;
}
-(void) setSubTitle {
    UIView *subTitleView = [UIView new];
    subTitleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:subTitleView];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithHexString:@"D2d2d2"];
    [subTitleView addSubview:lineView];
    
    UILabel *subTitleLabel = [UILabel new];
    subTitleLabel.text = SZLocal(@"title.SZOtisElevatorViewController");
    subTitleLabel.textColor = [UIColor colorWithHexString:@"124183"];
    [subTitleView addSubview:subTitleLabel];
    
    [subTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(CXTitilesViewY)); //with with
        make.left.equalTo(self.view.mas_left); //without with
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(CXTitilesViewH));
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(subTitleView.mas_bottom); //with with
        make.left.equalTo(subTitleView.mas_left); //without with
        make.right.equalTo(subTitleView.mas_right);
        make.height.equalTo(@1);
    }];
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@42); //without with
        make.right.equalTo(subTitleView.mas_right);
        make.height.equalTo(@20);
        make.centerY.equalTo(subTitleView.mas_centerY);
    }];
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
    self.view.backgroundColor=[UIColor whiteColor];
    [self setSubTitle];
    [self setUpTableView];
    [self workingHourView];
    self.tableView.rowHeight = 81;
    WEAKSELF
    self.workingHourView.findBtnClickBlock = ^(UIButton * scanBtn) {
        [weakSelf search];
    };
    self.workingHourView.scanBtnClickBlock = ^(UIButton * scanBtn) {
        [weakSelf ZhiFuBaoStyle];
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
    
    if (nav.laborTypeID == 9||nav.laborTypeID == 10) {
        SZSelectWHViewController *controller = [[SZSelectWHViewController alloc] init];
        controller.item = self.sousuoArray[indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        SZOtisElevatorSelectViewController *controller = [[SZOtisElevatorSelectViewController alloc] init];
        controller.item = self.sousuoArray[indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
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
        //self.bar.placeholder = @"电梯编号／工地名";
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
            //controller.tips = [NSString stringWithFormat:@"二维码扫描成功，但不属于%@维保电梯！",weakSelf.selectedButton.titleLabel.text];
            controller.tips  = SZLocal(@"error.Two dimensional code scanning success, but can not recognize the elevator!");
            controller.tips2 = SZLocal(@"error.OTISSelectElevator");
            //SZLog(@"%@ ",weakSelf.selectedButton.titleLabel.text);
            [weakSelf.navigationController pushViewController:controller animated:YES];
            
        }
    };
    vc.style = style;
    //vc.isOpenInterestRect = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(SZFinalMaintenanceUnitItem *)isExistenceWithQRCode:(SZQRCodeProcotolitem *)item{
    
    
    return [SZModuleQueryTool queryGongshiUnitesWithUnitRegcodes:item];
    
}

//-(SZFinalMaintenanceUnitItem *)isExistenceWithQRCode:(NSArray *)arrayCode{
//    return [SZModuleQueryTool queryOutsideUnitesWithUnitRegcodes:arrayCode];
//}
@end
