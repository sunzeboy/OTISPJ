//
//  UnplannedViewController.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/20.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "UnplannedViewController.h"
#import "SZMaintain.h"
#import "SZElevatorInfoTableViewCell.h"
#import "SZTable_Building.h"
#import "SZFinalOutsidePlanMaintenanceItem.h"
#import "SZUnplannedElevatorCountViewController.h"
#import "SZModuleQueryTool.h"
#import "SZTable_QRCode.h"

@interface UnplannedViewController ()<UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *sousuoArray;

@end

@implementation UnplannedViewController

//1 懒加载
- (NSArray *)maintain
{
    if (_maintain ==nil) {
//      _maintain = [SZTable_Building outsidePlanMaintenance];
        _maintain = [SZModuleQueryTool queryOutsidePlanMaintenance];
    }
    return _maintain;
}


- (NSMutableArray *)sousuoArray
{
    if (_sousuoArray ==nil) {
        _sousuoArray = [NSMutableArray array];
    }
    return _sousuoArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 81;
    self.sousuoArray = [NSMutableArray arrayWithArray:self.maintain];
    
    if (self.sousuoArray.count == 0) {
        self.dataArray = nil;
    }
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
    SZFinalOutsidePlanMaintenanceItem *gb = self.sousuoArray[indexPath.row];
    cell.maintain = gb;
    //3 返回
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SZFinalOutsidePlanMaintenanceItem *item = self.sousuoArray[indexPath.row];
    SZUnplannedElevatorCountViewController *vc = [[SZUnplannedElevatorCountViewController alloc] init];
    vc.selectTitle = self.title;
    vc.isWorkingHours = self.isWorkingHours;
    vc.item = item;
    vc.unPlanBlock=^{
        [self.delegate ZhiFuBaoStyle];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


//-(SZFinalMaintenanceUnitItem *)isExistenceWithQRCode:(NSArray *)arrayCode{
//    
//   return [SZModuleQueryTool queryOutsideUnitesWithUnitRegcodes:arrayCode];
//}

-(SZFinalMaintenanceUnitItem *)isExistenceWithQRCode:(SZQRCodeProcotolitem *)item{
    return [SZModuleQueryTool queryOutsideUnitesWithUnitRegcodes:item];
}

-(void)setIsHidden:(BOOL)isHidden{
    //    _isHidden = isHidden;
    if (!isHidden) {
        self.tableView.tableHeaderView = nil;
        self.sousuoArray = [NSMutableArray arrayWithArray:self.maintain];
        [self.tableView reloadData];
    }else{
        self.bar.text = @"";
        self.tableView.tableHeaderView = self.bar;
        self.bar.placeholder = [NSString stringWithFormat:@"%@/%@",SZLocal(@"dialog.title.Site name"),SZLocal(@"dialog.title.Address name")];
        CGPoint offect = self.tableView.contentOffset;
        offect.y = - self.tableView.contentInset.top;
        [self.tableView setContentOffset:offect animated:YES];
    }
}

-(BOOL)isHidden{
    return self.tableView.tableHeaderView != nil;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self.sousuoArray removeAllObjects];
    SZLog(@"%@",searchText);
    if ([searchText isEqualToString: @""]) self.sousuoArray = [NSMutableArray arrayWithArray:self.maintain];
    for (SZFinalOutsidePlanMaintenanceItem *unitItem in self.maintain) {
        if ([unitItem.BuildingName containsString:searchText]||[unitItem.BuildingAddr containsString:searchText]) {
            [self.sousuoArray addObject:unitItem];
        }
    }
    [self.tableView reloadData];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
@end
