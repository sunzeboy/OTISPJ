//
//  SZAnnualInspectionViewController.m
//  OTIS_PJ
//  年检列表
//  Created by jQ on 16/5/9.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZAnnualInspectionViewController.h"
#import "SZAnnualInspectionTableViewCell.h"
#import "SZAnnualInspectionReminderViewController.h"
#import "SZModuleQueryTool.h"
#import "SZFinalMaintenanceUnitItem.h"
#import "UIView+Extension.h"
#import "SZBottomWorkingHourView.h"
#import "NSDate+Extention.h"
#import "SZTable_YearlyCheckDownload.h"
#import "SZYearCheckItem.h"
#import "SZDuoxuanViewController.h"

@interface SZAnnualInspectionViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (strong,nonatomic) UITableView *tableView;


@property (nonatomic, strong) NSMutableArray *sousuoArray;

@property (nonatomic , strong)  SZBottomWorkingHourView *workingHourView;

@property (nonatomic , strong) UISearchBar *bar;

@property (nonatomic , assign) BOOL isHidden;

@end

@implementation SZAnnualInspectionViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sousuoArray = [NSMutableArray arrayWithArray:self.array];

    self.view.backgroundColor =[UIColor whiteColor];
    self.title = SZLocal(@"title.annualInspection");
    [self setUpTableView];
    [self workingHourView];
    
    WEAKSELF
    self.workingHourView.findBtnClickBlock = ^(UIButton * scanBtn) {
        [weakSelf search];
    };
    self.workingHourView.scanBtnClickBlock = ^(UIButton * scanBtn) {
        [weakSelf okAct];
    };
}


-(void)okAct{

    BOOL ret = NO;
    SZDuoxuanViewController *vc = [[SZDuoxuanViewController alloc] init];
    for (SZFinalMaintenanceUnitItem *item in self.sousuoArray) {
        if (item.selected) {
            ret = YES;
            [vc.arraySelected addObject:item];
        }
    }
    
    WEAKSELF
    vc.confirmActBlock = ^{
        self.array = nil;
        self.sousuoArray = [NSMutableArray arrayWithArray:self.array];
        [weakSelf.tableView reloadData];
    };
    if (ret) {
        [self.navigationController pushViewController:vc animated:YES];
    }

}

-(SZBottomWorkingHourView *)workingHourView{
    
    if(_workingHourView ==nil){
        _workingHourView =[SZBottomWorkingHourView loadSZBottomWorkingHourView];
        _workingHourView.frame = CGRectMake(0,SCREEN_HEIGHT-OTIS_BottomOperationH, SCREEN_WIDTH, OTIS_BottomOperationH);
        [_workingHourView.scanBtn setImage:[UIImage imageNamed:@"btn_confirm"] forState:0];
        [_workingHourView.scanBtn setTitle:SZLocal(@"btn.title.confirm") forState:0];
        [self.view addSubview:_workingHourView];
    }
    return _workingHourView;
}

-(void)setUpTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - OTIS_BottomOperationH) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource =self;
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
}


-(UISearchBar *)bar{
    if (!_bar) {
        _bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _bar.placeholder =[NSString stringWithFormat:@"%@/%@",SZLocal(@"dialog.title.Site name"),SZLocal(@"dialog.title.Elevator number")];
        _bar.delegate = self;
    }
    return _bar;
}

//设置数据（from plist）
-(NSMutableArray *)array
{
    if(_array ==nil){
        

        _array = [NSMutableArray array];
      
        /**
         *  年检所有的数据
         */
       NSMutableArray *arrayTemp =[NSMutableArray arrayWithArray:[SZModuleQueryTool queryYearCheckItem]];
        
       NSMutableArray *arrayDown = [NSMutableArray arrayWithArray:[SZTable_YearlyCheckDownload queryYearCheckItem]];

        NSMutableArray *arrayChaoqi = [NSMutableArray array];
        
        for (SZFinalMaintenanceUnitItem *unitItem in arrayTemp) {
             BOOL ret = YES;//是否可以添加进数组
            for (SZYearCheckItem *item in arrayDown) {
                
                if ([unitItem.UnitNo isEqualToString:item.UnitNo] && item.isDone) {
                    ret = NO;
                    break;
                }else{
                    continue;
                }
            }
            unitItem.isChaoqi = YES;

            if (ret) {

                unitItem.PDate_Save = [NSDate sinceDistantPastToDate:[NSDate dateFromString:unitItem.showDateStr]];
                
                [_array addObject:unitItem];
            }
            if (unitItem.inNextTwoMonths) {
                SZFinalMaintenanceUnitItem *item2 = [[SZFinalMaintenanceUnitItem alloc] init];
                item2.UnitNo = unitItem.UnitNo;
                item2.isChaoqi = NO;
                item2.CardType = unitItem.CardType;
                item2.CheckDate = unitItem.CheckDate;
                item2.YCheckDate = unitItem.YCheckDate;
                item2.BuildingName = unitItem.BuildingName;
                item2.Route = unitItem.Route;
                item2.PDate_Save = [NSDate sinceDistantPastToDate:[NSDate dateFromString:unitItem.inNextTwoMonths]];

                [arrayChaoqi addObject:item2];
            }
        }

        
        [_array addObjectsFromArray:arrayChaoqi];
        

        dispatch_async(dispatch_get_main_queue(), ^{
            if(_array.count == 0){
                [self iView];
            }
        });
        // && unitItem.YCheckDate == item.YCheckDate
        NSMutableDictionary *dicTemp = [SZTable_YearlyCheckDownload queryDoneYearCheckItem];
        NSMutableArray *arrayTemp2 = [NSMutableArray arrayWithArray:_array];
        NSMutableArray *arrayTemp3 = [NSMutableArray array];

        for (SZFinalMaintenanceUnitItem *item in arrayTemp2) {
            NSString *checkdateStr = [NSString stringWithFormat:@"%ld",(long)item.PDate_Save];
            NSString *strKey =[NSString stringWithFormat:@"%@%@",item.UnitNo,checkdateStr];
            SZFinalMaintenanceUnitItem *unitItem = dicTemp[strKey];
            if(unitItem){
                if( unitItem.IS_UPLOADING == 0 && unitItem.PDate_Save == item.PDate_Save){
                    
                    item.isAnnualled = YES;
                   
                    [arrayTemp3 addObject:item];
//                    add 已经完成年检标志=1；并且添加显示这条记录
                }else {
//                    不增加显示记录；什么也不做
                }
            }else{
//                add 需要年检的记录
                [arrayTemp3 addObject:item];

            }

        }
        
//        _array = [NSMutableArray array];
//        for (SZFinalMaintenanceUnitItem *item in arrayTemp3) {
//             BOOL ret = YES;
//            for (SZYearCheckItem *item2 in arrayDown) {
//                if (item2.PDate == item.PDate_Save) {
//                    ret = NO;
//                    break;
//                }
//                
//            }
//            
//            if (ret) {
//                [_array addObject:item];
//            }
//        }
        _array = [NSMutableArray array];

        NSMutableDictionary *dicData = [SZTable_YearlyCheckDownload queryYearCheckItemData];

        for (SZFinalMaintenanceUnitItem *unitItem in arrayTemp3) {
            NSString *strKey = [NSString stringWithFormat:@"%@%ld",unitItem.UnitNo,unitItem.PDate_Save];
            if (dicData[strKey]) {
                continue;
            }
            [_array addObject:unitItem];
        }
        
        
        
        
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"PDate_Save" ascending:YES];
        NSSortDescriptor *sortDescriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"isAnnualled" ascending:NO];

        //这个数组保存的是排序好的对象
        [_array sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        [_array sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor2]];

        


    }
    return _array;
}





#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sousuoArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    SZAnnualInspectionTableViewCell *cell;
    cell = [SZAnnualInspectionTableViewCell cellWithTableView:tableView];
    cell.szannual = self.sousuoArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 81;
}

//move to detail
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SZFinalMaintenanceUnitItem *item = self.sousuoArray[indexPath.row];
    SZAnnualInspectionReminderViewController *controller = [[SZAnnualInspectionReminderViewController alloc] init];
    controller.UnitNo = item.UnitNo;
    controller.isChaoqi = item.isChaoqi;
    WEAKSELF
    controller.confirmActBlock = ^{
        self.array = nil;
        self.sousuoArray = [NSMutableArray arrayWithArray:self.array];
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

//无数据
-(void)iView{
    UIImageView *iView = [[UIImageView alloc] initWithImage:ImageNamed(@"defult")];
    iView.size = iView.image.size;
    iView.contentMode = UIViewContentModeScaleAspectFit;
    iView.center = self.view.center;
    [self.view addSubview:iView];
}

#pragma mark - UISearchBarDelegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self.sousuoArray removeAllObjects];
//    SZLog(@"%@",searchText);
    NSString *studentUp  = [searchText uppercaseString];
    if ([searchText isEqualToString: @""]) self.sousuoArray = [NSMutableArray arrayWithArray:self.array];
    for (SZFinalMaintenanceUnitItem *unitItem in self.array) {
        if ([unitItem.BuildingName containsString:searchText]||[unitItem.UnitNo containsString:searchText]||[unitItem.UnitNo containsString:studentUp]) {
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
        //_isHidden = isHidden;
    if (!isHidden) {
        self.tableView.tableHeaderView = nil;
    }else{
        self.bar.text = @"";
        self.tableView.tableHeaderView = self.bar;
        self.bar.placeholder = [NSString stringWithFormat:@"%@/%@",SZLocal(@"dialog.title.Site name"),SZLocal(@"dialog.title.Elevator number")];

        CGPoint offect = self.tableView.contentOffset;
        offect.y = - self.tableView.contentInset.top;
        [self.tableView setContentOffset:offect animated:YES];
    }
    
}

@end
