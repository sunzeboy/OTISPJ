//
//  NotCompletedViewController.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/21.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "NotCompletedViewController.h"
#import "SZTableViewCell.h"
#import "SZTable_Schedules.h"
#import "SZFinalMaintenanceUnitItem.h"
#import "SZModuleQueryTool.h"
#import "SZMaintainDetailViewController.h"
#import "CustomIOSAlertView.h"
#import "SZTable_QRCode.h"
#import "MDSynchronousVC.h"
@interface NotCompletedViewController ()<UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *sousuoArray;

@end

@implementation NotCompletedViewController


//1 懒加载
- (NSArray *)maintain
{
    if (_maintain ==nil) {
        _maintain = [SZModuleQueryTool queryNotCompletedMaintenance];

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

    if (self.maintain.count == 0) {
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
    SZTableViewCell *cell = [SZTableViewCell cellWithTableView:tableView];
    
    //2 设置cell内部的子控件
    SZFinalMaintenanceUnitItem *gb = self.sousuoArray[indexPath.row];
    cell.maintain = gb;
    //3 返回
    return cell;
}



- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SZFinalMaintenanceUnitDetialItem *item = self.sousuoArray[indexPath.row];
//    MDSynchronousVC *vc = [[MDSynchronousVC alloc] initWithLiftModel:item];
//    [self.navigationController pushViewController:vc animated:YES];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    __block NSInteger iCell = 0;
    __block NSString *cellContent = @"";
    [self.view endEditing:YES];
    CustomIOSAlertView *alertView = nil;
    // 判断是否扫描过二维码如果有
    
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
    
    WEAKSELF
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        if (iCell == 0 && buttonIndex == 0) {
            [alertView close];
            [self.delegate ZhiFuBaoStyle];
        } else if (iCell > 0) {
            if (buttonIndex == 0) {
//                SZFinalMaintenanceUnitItem *item = self.sousuoArray[indexPath.row];
//                SZMaintainDetailViewController *controller = [[SZMaintainDetailViewController alloc] initWithBarcodeType:cellContent];
//                controller.scheduleID = item.ScheduleID;
//                controller.title = weakSelf.title;
//                [self.navigationController pushViewController:controller animated:YES];
                MDSynchronousVC *vc = [[MDSynchronousVC alloc] initWithLiftModel:item];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                [weakSelf.navigationController pushViewController:vc animated:YES];
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



-(SZFinalMaintenanceUnitItem *)isExistenceWithQRCode:(SZQRCodeProcotolitem *)item{
//    SZFinalMaintenanceUnitItem *unitItem in self.maintain
//    NSUInteger i = self.maintain.count-1;;i--
    //从后向前遍历，保证是最近计划日期的匹配
    for (int i = (int)(self.maintain.count)-1;i>-1;i--) {
        SZFinalMaintenanceUnitItem *unitItem = self.maintain[i];
        if (item.strArray&&item.strArray.count) {
            
            if (unitItem.UnitRegcode == nil) continue;
            for (NSString *strCode in item.strArray) {
                if ([strCode containsString:unitItem.UnitRegcode]) {
                    return unitItem;
                }
            }
            
            
        }else{
            
            if (item.REG_CODE.length>0 && [item.REG_CODE isEqualToString:unitItem.UnitRegcode]) {
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

-(void)setIsHidden:(BOOL)isHidden{
    //    _isHidden = isHidden;
    if (!isHidden) {
        self.tableView.tableHeaderView = nil;
        self.sousuoArray = [NSMutableArray arrayWithArray:self.maintain];
        [self.tableView reloadData];
    }else{
        self.bar.text = @"";
        self.tableView.tableHeaderView = self.bar;
        CGPoint offect = self.tableView.contentOffset;
        offect.y = - self.tableView.contentInset.top;
        [self.tableView setContentOffset:offect animated:YES];
    }
    
}

-(BOOL)isHidden{
    return self.tableView.tableHeaderView != nil;
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
////    if (scrollView.contentOffset.y>20) {
//    self.tableView.tableHeaderView = nil;
////    }
//
//}


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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
@end
