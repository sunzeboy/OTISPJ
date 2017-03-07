//
//  ProductiveViewController.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/20.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "ProductiveViewController.h"
#import "SZWorkingHoursType.h"
#import "SZPithilyTableViewCell.h"
#import "SZRecallRepairViewController.h"
#import "SZJobHazardAnalysisViewController.h"
#import "SZMaintenanceOperationViewController.h"
#import "SZWorkingHoursViewController.h"
#import "SZNavigationController.h"
#import "SZTable_LaborType.h"
#import "SZPlainViewController.h"


@interface ProductiveViewController ()

@property (nonatomic, strong) NSArray *workingHoursType;

@end

@implementation ProductiveViewController

//1 懒加载
- (NSArray *)workingHoursType
{
    if (_workingHoursType ==nil) {
//        _workingHoursType = [SZWorkingHoursType workingHoursTypesList:@"productive"];
        _workingHoursType = [SZTable_LaborType quaryProductive];

    }
    return _workingHoursType;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // self.view.backgroundColor = [UIColor yellowColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self setExtraCellLineHidden:self.tableView];

}

//返回每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.workingHoursType.count;
}
//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    SZLabor *gb = self.workingHoursType[indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ID"];
    }
    
    cell.textLabel.text = gb.LaborName;
    cell.imageView.image = [UIImage imageNamed:gb.LaborType];
    if (cell.imageView.image == nil) {
        cell.imageView.image = [UIImage imageNamed:@"lht_default"];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SZLabor *gb = self.workingHoursType[indexPath.row];
    SZNavigationController *nav = (SZNavigationController*)self.navigationController;
    nav.laborTypeID = gb.LaborTypeID;
  
//    nav.laborProperty = 1;
    // 工时填写
    if (gb.LaborTypeID == 3||gb.LaborTypeID == 4||gb.LaborTypeID == 8||gb.LaborTypeID>99) {
        SZRecallRepairViewController *controller = [[SZRecallRepairViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        SZPlainViewController *otis = [[SZPlainViewController alloc] init];
        otis.title = [NSString stringWithFormat:@"%@－%@",SZLocal(@"title.WorkingHoursViewController"),gb.LaborName];
        [self.navigationController pushViewController:otis animated:YES];
    }
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
}

@end
