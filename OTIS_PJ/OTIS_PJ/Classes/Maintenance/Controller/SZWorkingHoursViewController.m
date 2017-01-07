//
//  SZWorkingHoursViewController.m
//  OTIS_PJ
//
//  Created by zy on 16/5/6.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZWorkingHoursViewController.h"
#import "SZWorkingHours.h"
#import "SZNormalWorkHoursTableViewCell.h"
#import "SZPuiWorkHoursTableViewCell.h"

@interface SZWorkingHoursViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) UITableView *tableView;

@property(strong,nonatomic) NSMutableArray *array;

@end

@implementation SZWorkingHoursViewController
- (BOOL)shouldAutorotate{
    
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    [self setUpTableView];

}
-(void)setUpTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource =self;
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//设置数据（from plist）
-(NSMutableArray *)array
{
    if(_array ==nil){
        _array =[NSMutableArray arrayWithArray:[SZWorkingHours workingHoursList]];
    }
    return _array;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SZNormalWorkHoursTableViewCell *cell;
    cell = [SZNormalWorkHoursTableViewCell cellWithTableView:tableView];
    cell.szworkinghours = self.array[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}
@end
