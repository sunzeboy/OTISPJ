//
//  CheckWorkHourViewController.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/20.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "CheckWorkHourViewController.h"
#import "SZWorkingHoursType.h"
#import "SZCheckLookTableViewCell.h"
#import "SZTitleHeadView.h"
#import "SZTable_LaborHours.h"
#import "SZCheckLookModel.h"
#import "SZTable_Schedules.h"
#import "SZCheckWHDetialViewController.h"
#import "UIView+Extension.h"
#import "SZInputWorkingHourNonProductiveViewController.h"

@interface CheckWorkHourViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , strong) NSArray *sectionTitles;

@property (nonatomic , strong) UIImageView *iView;

@end

@implementation CheckWorkHourViewController
- (BOOL)shouldAutorotate{
    
    return NO;
}
-(UIImageView *)iView{
    if (_iView == nil) {
        _iView = [[UIImageView alloc] initWithImage:ImageNamed(@"defult")];
        _iView.size = _iView.image.size;
        _iView.contentMode = UIViewContentModeScaleAspectFit;
        _iView.center = self.view.center;
        [self.view addSubview:_iView];
    }
    return _iView;
}
-(NSArray *)sectionRows{
    if (_sectionRows ==nil) {
        _sectionRows = [SZTable_LaborHours quaryAllDateLaborHours222];
    }
    return _sectionRows;
}


-(NSArray *)sectionTitles{
    if (_sectionTitles ==nil) {
        _sectionTitles = [SZTable_LaborHours quaryAllDateLaborHours];
       
    }
    return _sectionTitles;
}

-(void)viewWillAppear:(BOOL)animated{
    self.sectionRows = nil;
    self.sectionTitles = nil;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
    if (self.sectionRows.count == 0) {
        self.tableView = nil;
        [self iView];
    }
}

- (void)setupTableView
{
    // 设置内边距
    CGFloat top = CXTitilesViewY + CXTitilesViewH;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.contentInset = UIEdgeInsetsMake(top+30, 0, 64, 0);
    // 设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    SZTitleHeadView *titleView = [SZTitleHeadView loadSZTitleHeadView];
    titleView.frame = CGRectMake(0, top-5,SCREEN_WIDTH, 35);
    [self.view addSubview:titleView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   SZCheckLookModel *model = self.sectionRows[indexPath.section][indexPath.row];
    return model.cellHeight;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSString *date = self.sectionTitles[section];
//    NSString *strP = [NSString stringWithFormat:@"(生产:%.2fh;",[SZTable_LaborHours quaryTimesWithDate:date]];
//    NSString *strNoP = [NSString stringWithFormat:@"非生产:%.2fh)",[SZTable_LaborHours quaryNonProductiveTimesWithDate:date]];
//    return [NSString stringWithFormat:@"%@%@%@",date,strP,strNoP];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionTitles.count;
}
//返回每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.sectionRows.count) {
        return [self.sectionRows[section] count];
    }
    return 0;
}
//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1 创建可重用的自定义的cell
    SZCheckLookTableViewCell *cell = [SZCheckLookTableViewCell cellWithTableView:tableView];
    SZCheckLookModel * model = self.sectionRows[indexPath.section][indexPath.row];
    cell.model = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SZCheckLookModel *model = self.sectionRows[indexPath.section][indexPath.row];
    if (model.feishengchanxing) {
        SZLaborHoursItem *item = [model.laborHours lastObject];
        model.GenerateDate = item.GenerateDate;
        SZInputWorkingHourNonProductiveViewController *vc = [[SZInputWorkingHourNonProductiveViewController alloc] init];
        vc.LaborTypeID = model.LaborTypeID;
        vc.item = item;
        vc.model = model;
        vc.hasInput=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        SZCheckWHDetialViewController *vc = [[SZCheckWHDetialViewController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *date = self.sectionTitles[section];
    NSString *strP = [NSString stringWithFormat:@"(%@:%.2fh;",SZLocal(@"title.production"),[SZTable_LaborHours quaryTimesWithDate:date]];
    NSString *strNoP = [NSString stringWithFormat:@"%@:%.2fh)",SZLocal(@"title.nonproductive"),[SZTable_LaborHours quaryNonProductiveTimesWithDate:date]];
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    label.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    label.text=[NSString stringWithFormat:@"  %@%@%@",date,strP,strNoP];
    return label;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

@end
