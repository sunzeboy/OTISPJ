//
//  SZCustomerSignQuarterlyViewController.m
//  OTIS_PJ
//
//  Created by jQ on 16/5/5.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZCustomerSignQuarterlyViewController.h"
#import "SZCustomerSignElevatorItem.h"
#import "SZCustomerSignElevatorCell.h"

@interface SZCustomerSignQuarterlyViewController ()
@property(nonatomic,strong) NSArray *elevatorItem;
@end

@implementation SZCustomerSignQuarterlyViewController
//懒加载
- (NSArray *)elevatorItem
{
    if (_elevatorItem == nil){
        _elevatorItem =[SZCustomerSignElevatorItem elevatorItemList];
    }
    return _elevatorItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //cell高度自动调整
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.navigationController setToolbarHidden:NO animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//返回每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.elevatorItem.count;
}

//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1 创建可重用的自定义的cell
    SZCustomerSignElevatorCell *cell = [SZCustomerSignElevatorCell cellWithTableView:tableView];
    
    //2 设置cell内部的子控件
    SZCustomerSignElevatorItem *cil = self.elevatorItem[indexPath.row];
    cell.szCustomerSignElevatorItem =cil;
    
    //
        SZLog(@"quarterly row.count:%ld , row.index: %ld",(unsigned long)self.rowArray.count,self.rowIndex);
    //
    //3 返回
    return cell;
}

@end
