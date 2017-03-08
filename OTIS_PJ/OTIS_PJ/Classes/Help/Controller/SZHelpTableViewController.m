//
//  SZHelpTableViewController.m
//  OTIS_PJ
//
//  Created by jQ on 16/5/11.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZHelpTableViewController.h"
#import "SZHelpTableViewCell.h"
#import "SZToolViewController.h"
#import "SZPassWordChangeViewController.h"
#import "SZRegardingViewController.h"
#import "CustomIOSAlertView.h"
#import "SZSignOutView.h"
#import "AppDelegate+Version.h"
#import "AppDelegate.h"
#import "TablesAndFields.h"
#import "UIView+Extension.h"
#import "SZClearLocalDataTool.h"
#import "SZUploadManger.h"
#import "SZVersionListViewController.h"
#import "SZVersionWebViewController.h"
#import "SZCompanyNotificationVC.h"

@interface SZHelpTableViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic) UITableView *tableView;
@property(strong,nonatomic) NSMutableArray *array;
@property (nonatomic, strong) NSArray *sectionTitle;

@property (nonatomic, strong)  SZSignOutView *operationView;

@end

@implementation SZHelpTableViewController
- (BOOL)shouldAutorotate{
    
    return NO;
}
-(SZSignOutView *)operationView{
    
    if(_operationView ==nil){
        _operationView =[SZSignOutView loadSZSignOutView];
        _operationView.frame = CGRectMake(0,0, SCREEN_WIDTH, 60);
    }
    return _operationView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.title =SZLocal(@"title.helpMenu");
    [self setUpTableView];
}

-(void)setUpTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource =self;
    //tableView.backgroundColor = [UIColor colorWithRed:0.43529411759999997 green:0.4431372549 blue:0.47450980390000003 alpha:1];
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    //unexpected footer line hidden
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.tableView.tableFooterView = self.operationView;
    WEAKSELF
    self.operationView.signOutBlock = ^{
        [weakSelf logout];
    };
}


//设置数据（from plist）
- (NSArray *)titleArray {
    
    if (_titleArray == nil) {
        
        NSArray *array = [NSMutableArray arrayWithArray:[SZHelp helpList]];
        
        NSMutableArray *titles1 = [NSMutableArray array];
        NSMutableArray *titles2 = [NSMutableArray array];
        NSMutableArray *titles3 = [NSMutableArray array];
        NSMutableArray *titles4 = [NSMutableArray array];

        for (SZHelp *jhaItem in array) {
            
            if ([jhaItem.titleNo isEqualToString:@"1"]) {
                [titles1 addObject:jhaItem];
            }else if ([jhaItem.titleNo isEqualToString:@"2"]){
                [titles2 addObject:jhaItem];
            }else if ([jhaItem.titleNo isEqualToString:@"3"]){
                [titles3 addObject:jhaItem];
            }else if ([jhaItem.titleNo isEqualToString:@"4"]){
                [titles4 addObject:jhaItem];
            }
        }
    
        _titleArray = @[titles1,titles2,titles3,titles4];
    }
    return _titleArray;
}

//1 懒加载
- (NSArray *)sectionTitle
{
    if (_sectionTitle ==nil) {
        _sectionTitle = @[@"1",@"2",@"3",@"4"];
    }
    return _sectionTitle;
}

// 返回Header的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0;
}
// 返回Header的样式
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    bgView.backgroundColor = [UIColor colorWithRed:0.96078431372549022 green:0.96078431372549022 blue:0.96078431372549022 alpha:1];
    //red="0.96078431372549022" green="0.96078431372549022" blue="0.96078431372549022" alpha="1"
    return bgView;
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.sectionTitle count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.array.count;
    NSArray *keyForJob = self.titleArray[section] ;
    return [keyForJob count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    SZHelpTableViewCell *cell;
//    cell = [SZHelpTableViewCell cellWithTableView:tableView];
//    
    NSArray *array = self.titleArray[indexPath.section];
    SZHelp *gb = array[indexPath.row];
//    cell.szhelp = gb;
    //cell.szhelp = self.array[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ID"];
    }
    
    cell.textLabel.text = gb.iconName;
    cell.imageView.image = [UIImage imageNamed:gb.iconImage];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

//退出方法
- (void) logout{

     AppDelegate*delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate rootController];
}
//各选项迁移控制
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SZLog(@"indexpath:%ld,%ld",(long)indexPath.row,(long)indexPath.section);
    
    if (indexPath.row == 1 && indexPath.section == 1) {
        //清空数据
        SZLog(@"clear data!");
        
        [SZClearLocalDataTool clearLocalDataWithView:self.view];
    }else if (indexPath.row == 0 && indexPath.section == 1) {
        //修改密码
        SZPassWordChangeViewController *controller = [[SZPassWordChangeViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];

    }else if (indexPath.section == 0) {
        
        if (indexPath.row==0) {
            //工具
            SZToolViewController *controller = [[SZToolViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            SZCompanyNotificationVC* companyVC = [[SZCompanyNotificationVC alloc] init];
            [self.navigationController pushViewController:companyVC animated:YES];
        }
    }else if (indexPath.section == 2) {
        //版本说明
        SZVersionWebViewController *controller = [[SZVersionWebViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.section == 3){
        //关于
        SZRegardingViewController *controller = [[SZRegardingViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
