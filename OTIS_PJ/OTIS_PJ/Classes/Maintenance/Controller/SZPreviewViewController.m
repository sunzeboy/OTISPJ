//
//  SZPreviewViewController.m
//  OTIS_PJ
//
//  Created by sunze on 16/5/30.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZPreviewViewController.h"

#import "SZMaintenanceOperationTableViewCell.h"
#import "SZModuleQueryTool.h"
#import "SZMaintenanceCheckItem.h"

@interface SZPreviewViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic , strong) NSMutableDictionary *arrayCompetedCheckItem;

@property (strong,nonatomic) UITableView *tableView;


@end

@implementation SZPreviewViewController

- (BOOL)shouldAutorotate{
    
    return NO;
}
// 懒加载
- (NSMutableArray *)maintenanceOperation {
    if (_maintenanceOperation == nil) {
        _maintenanceOperation = [NSMutableArray arrayWithArray:[SZModuleQueryTool quaryMaintenanceItemWithDetialItem:self.item andTimeType:OTISMaintenanceItemTimeTypeHalfMonth]];
        [_maintenanceOperation addObjectsFromArray:[SZModuleQueryTool quaryOtherMaintenanceItemWithDetialItem:self.item andTimeType:OTISMaintenanceItemTimeTypeQuarterly]];
        [_maintenanceOperation addObjectsFromArray:[SZModuleQueryTool quaryOtherMaintenanceItemWithDetialItem:self.item andTimeType:OTISMaintenanceItemTimeTypeHalfYear]];
        [_maintenanceOperation addObjectsFromArray:[SZModuleQueryTool quaryOtherMaintenanceItemWithDetialItem:self.item andShowYear:YES]];

        for (SZMaintenanceCheckItem *itemAll in _maintenanceOperation) {
            
//            for (SZMaintenanceCheckItem *itemSelect in self.arrayCompetedCheckItem) {
//                if ([itemAll.ItemCode isEqualToString:itemSelect.ItemCode]) {
//                    itemAll.state = itemSelect.state;
//                    break;
//                }
//            }
            SZMaintenanceCheckItem *itemSelect = self.arrayCompetedCheckItem[itemAll.ItemCode];
            if (itemSelect) {
                itemAll.state = itemSelect.state;
            }
        }
        
        
        
        
    }
    return _maintenanceOperation;
}

//1 懒加载
- (NSMutableDictionary *)arrayCompetedCheckItem
{
    if (_arrayCompetedCheckItem ==nil) {
        _arrayCompetedCheckItem = [SZModuleQueryTool quaryCompletedMaintenanceItemWithDetialItem:self.item];
    }
    return _arrayCompetedCheckItem;
}

// 设置副标题
- (void) setSubTitleView {
    UIView *subTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, CXTitilesViewY, SCREEN_WIDTH, 80)];
    subTitleView.backgroundColor = [UIColor colorWithRed:3.0f/255.0f green:96.0f/255.0f blue:169.0f/255.0f alpha:1];
    // 工地名称
    UILabel *buildingNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 5, 85, 20)];
    buildingNameLabel.textColor = [UIColor whiteColor];
    buildingNameLabel.font =[UIFont fontWithName:@"Microsoft Yahei" size:16];
    buildingNameLabel.text = [NSString stringWithFormat:@"%@:",SZLocal(@"dialog.title.Site name")];
    UILabel *buildingNameText =[[UILabel alloc]initWithFrame:CGRectMake(88, 5, SCREEN_WIDTH - 95, 20)];
    buildingNameText.textColor = [UIColor whiteColor];
    buildingNameText.font =[UIFont fontWithName:@"Microsoft Yahei" size:16];
    buildingNameText.text = self.item.BuildingName;
    // 电梯编号
    UILabel *evelatorNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 30, 85, 20)];
    evelatorNumLabel.textColor = [UIColor whiteColor];
    evelatorNumLabel.font =[UIFont fontWithName:@"Microsoft Yahei" size:16];
    evelatorNumLabel.text = [NSString stringWithFormat:@"%@:",SZLocal(@"dialog.title.Elevator number")];
    UILabel *evelatorNumText =[[UILabel alloc]initWithFrame:CGRectMake(88, 30, 152, 20)];
    evelatorNumText.textColor = [UIColor whiteColor];
    evelatorNumText.font =[UIFont fontWithName:@"Microsoft Yahei" size:16];
    evelatorNumText.text = self.item.UnitNo;
    // 计划日期
    UILabel *plannedDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 55, 85, 20)];
    plannedDateLabel.textColor = [UIColor whiteColor];
    plannedDateLabel.font =[UIFont fontWithName:@"Microsoft YaHei" size:16];
    plannedDateLabel.text = [NSString stringWithFormat:@"%@:",SZLocal(@"title.planeDate")];
    UILabel *plannedDateText =[[UILabel alloc]initWithFrame:CGRectMake(88, 55, 152, 20)];
    plannedDateText.textColor = [UIColor whiteColor];
    plannedDateText.font =[UIFont fontWithName:@"Microsoft YaHei" size:16];
    plannedDateText.text = self.item.CheckDateStr;
    
    [subTitleView addSubview:buildingNameLabel];
    [subTitleView addSubview:buildingNameText];
    [subTitleView addSubview:evelatorNumLabel];
    [subTitleView addSubview:evelatorNumText];
    [subTitleView addSubview:plannedDateLabel];
    [subTitleView addSubview:plannedDateText];
    
    [self.view addSubview:subTitleView];
}

-(void)setUpTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CXTitilesViewY + CXTitilesSubSpaceY, SCREEN_WIDTH, SCREEN_HEIGHT - CXTitilesViewY - CXTitilesSubSpaceY) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource =self;
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
}

-(void)setAllSelect:(BOOL)allSelect{
    
    if (allSelect) {
        for (SZMaintenanceCheckItem *checkItem in self.maintenanceOperation) {
            checkItem.state = 1;
        }
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubTitleView];
    [self setUpTableView];
    self.title = SZLocal(@"title.SZPreviewViewController");
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

    self.tableView.rowHeight = 54;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SZMaintenanceCheckItem *item = self.maintenanceOperation[indexPath.row];
    return item.operationTableViewCellHeight;
}

//返回每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.maintenanceOperation.count;
}
//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1 创建可重用的自定义的cell
    SZMaintenanceOperationTableViewCell *cell = [SZMaintenanceOperationTableViewCell cellWithTableView:tableView];
    
    //2 设置cell内部的子控件
    SZMaintenanceCheckItem *gb = self.maintenanceOperation[indexPath.row];
    cell.maintenanceOperation = gb;
    cell.operationBtn.enabled = NO;
    //3 返回
    return cell;
}



@end
