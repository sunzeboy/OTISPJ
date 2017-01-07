//
//  NonProductiveViewController.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/20.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "NonProductiveViewController.h"
#import "SZWorkingHoursType.h"
#import "SZPithilyTableViewCell.h"
#import "SZTable_LaborType.h"
#import "SZNavigationController.h"
#import "SZInputWorkingHourNonProductiveViewController.h"

@interface NonProductiveViewController ()<UITableViewDataSource>

@property (nonatomic, strong) NSArray *workingHoursType;

@end

@implementation NonProductiveViewController

//1 懒加载
- (NSArray *)workingHoursType
{
    if (_workingHoursType ==nil) {
        _workingHoursType = [SZTable_LaborType quaryNonProductive];
    }
    return _workingHoursType;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SZLabor *gb = self.workingHoursType[indexPath.row];
    SZNavigationController *nav = (SZNavigationController*)self.navigationController;
    nav.laborTypeID = gb.LaborTypeID;
    
    SZInputWorkingHourNonProductiveViewController *vc = [[SZInputWorkingHourNonProductiveViewController alloc] init];
    vc.LaborTypeID = gb.LaborTypeID;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
