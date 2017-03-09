//
//  SZMaintenanceHalfMonthViewController.m
//  OTIS_PJ
//
//  Created by zy on 16/5/6.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZMaintenanceHalfMonthViewController.h"
#import "SZMaintenanceOperation.h"
#import "SZMaintenanceOperationTableViewCell.h"
#import "SZModuleQueryTool.h"
#import "SZMaintenanceCheckItem.h"
#import "TablesAndFields.h"
#import "NSObject+MDObjectTool.h"
#import "MDSVTModel.h"
@interface SZMaintenanceHalfMonthViewController ()<UITableViewDataSource>

@property (nonatomic , strong) NSMutableDictionary *arrayCompetedCheckItem;


/**
 MD 属性
 */

//MD需要测试的dirve的三个维保项
@property(nonatomic,strong) NSArray* driveProjectArray;

//MD需要测试的controller的三个维保项
@property(nonatomic,strong) NSArray* controllerProjectArray;

//Drive 包含这个数组中的元素时打❌
@property(nonatomic,strong) NSArray* driveErrorCodeArray;

//GECB=controller  包含这个数组中的元素时 打❌
@property(nonatomic,strong) NSArray* controllerErrorCodeArray;

@end

@implementation SZMaintenanceHalfMonthViewController


/**
 处理MD自动项方法
 */

-(NSArray*)driveProjectArray{
    
    if (!_driveProjectArray) {
        _driveProjectArray = [NSArray arrayWithObjects:@"A-1_6",@"A-2_5",@"A-3_4", nil];
    }
    return _driveProjectArray;
}


-(NSArray*)controllerProjectArray{
    
    if (!_controllerProjectArray) {
        _controllerProjectArray = [NSArray arrayWithObjects:@"A-1_18 ",@"A-1_19",@"A-1_25", nil];
    }
    return _controllerProjectArray;
}


-(NSArray*)driveErrorCodeArray{

    if (!_driveErrorCodeArray) {
        _driveErrorCodeArray = [NSArray arrayWithObjects:@[@"524",@"504",@"529",@"530",@"502",@"507",@"508",@"509",@"510",@"514"],@[@"32",@"33",@"34",@"37",@"38",@"728",@"526"],@[@"400",@"401",@"408",@"409",@"418",@"419"], nil];
    }
    return _driveErrorCodeArray;
}

-(NSArray*)controllerErrorCodeArray{
    if (!_controllerErrorCodeArray) {
        _controllerErrorCodeArray = [NSArray arrayWithObjects:@[@"0211",@"0212"],@[@"0301",@"0304",@"307",@"0102", @"0103",@"0312",@"0313"],@[@"0102",@"0237",@"0238",@"0302",@"0306"], nil];
    }
    return _controllerErrorCodeArray;
}

-(void)setControllerMdsvtModel{
    
    if ([self.svtModel.controllerModel.IsEventLogComplete isEqualToString:@"true"]) {
        
    }else{
        
    }
}

-(NSString*)setDriveMdsvtModel:(NSInteger)index{
    
    NSArray* tempArray = self.driveErrorCodeArray[index];
    
    if ([self.svtModel.Drive.IsEventLogComplete isEqualToString:@"true"]) {
        
        for (MDSVTEventModel* model in self.svtModel.Drive.SavedDriveEvents) {
            if ([tempArray containsObject:model.EventNumber]) {
                return @"1";
            }
        }
        
        for (MDSVTEventModel* model in self.svtModel.Drive.DriveEvents) {
            if ([tempArray containsObject:model.EventNumber]) {
                return @"1";
            }
        }
        return @"0";
    }else{
        for (MDSVTEventModel* model in self.svtModel.Drive.SavedDriveEvents) {
            if ([tempArray containsObject:model.EventNumber]) {
                return @"1";
            }
        }
        for (MDSVTEventModel* model in self.svtModel.Drive.DriveEvents) {
            if ([tempArray containsObject:model.EventNumber]) {
                return @"1";
            }
        }
        return @"-1";
    }
}


// 懒加载
- (NSMutableArray *)maintenanceOperation {
    
    if (_maintenanceOperation == nil) {
        
        _maintenanceOperation = [NSMutableArray array];

        if (self.isFixMode) {
            
            NSMutableArray *arrayAll = [NSMutableArray arrayWithArray:[SZModuleQueryTool quaryMaintenanceItemWithDetialItem:self.item2 andTimeType:OTISMaintenanceItemTimeTypeHalfMonth]];

            NSMutableDictionary *dicFix = [SZModuleQueryTool quaryMaintenanceItemFixWithDetialItem:self.item2];
            
            for (SZMaintenanceCheckItem *itemFix in arrayAll) {
                if (dicFix[itemFix.ItemCode]) {
                    SZMaintenanceCheckItem *item = itemFix;
                    item.state = [dicFix[itemFix.ItemCode] intValue];
                    item.state2 = item.state;
                    [_maintenanceOperation addObject:item];
                    
                    NSInteger  index = [_maintenanceOperation indexOfObject:item];
                    if (index>2) {
                        item.isHiden=YES;
                    }
                    if (index<2){
                        item.automType = 0;
                    }else{
                        item.automType = 1;
                    }
                    if (![self IsAutomaticOpen]) {
                        item.isHiden=YES;
                    }
                }
            }
            
        }else if(self.isSign){//签字的时候
            
            NSMutableArray *arrayAll =
                    [NSMutableArray arrayWithArray:[SZModuleQueryTool quaryMaintenanceItemWithDetialItem:self.item2 andTimeType:OTISMaintenanceItemTimeTypeHalfMonth]];
            
            NSMutableDictionary *dicCompetedItem = self.arrayCompetedCheckItem;
            
            for (SZMaintenanceCheckItem *itemFix in arrayAll) {
                if (dicCompetedItem[itemFix.ItemCode]) {
                    SZMaintenanceCheckItem *item = itemFix;
                    SZMaintenanceCheckItem *item2 = dicCompetedItem[itemFix.ItemCode];
                    item.state = item2.state;
                    item.state2 = item.state;
                    [_maintenanceOperation addObject:item];
                    NSInteger  index = [_maintenanceOperation indexOfObject:item];
                    if (index>2) {
                        item.isHiden=YES;
                    }
                    if (index<2){
                        item.automType = 0;
                    }else{
                        item.automType = 1;
                    }
                    
                    if (![self IsAutomaticOpen]) {
                        item.isHiden=YES;
                    }
                   
                }
            }
        }else{
            
            if (!self.item) {
                self.item = self.item2;
            }
            if (_maintenanceOperation.count) {
                return _maintenanceOperation;
            }
            NSMutableArray *arrayTemp = [NSMutableArray arrayWithArray:[SZModuleQueryTool quaryMaintenanceItemWithDetialItem:self.item andTimeType:OTISMaintenanceItemTimeTypeHalfMonth]];

            for (SZMaintenanceCheckItem *itemAll in arrayTemp) {
                
                SZMaintenanceCheckItem *item = self.arrayCompetedCheckItem[itemAll.ItemCode];
                if (item && item.isUpload == YES) {
//                    NSLog(@"-----------++=%ld",(long)itemAll.isHiden);
                    continue;
                    
                }else {
                    if(item){
                        itemAll.state = item.state;
                        itemAll.state2 = item.state;
                    }
                    [_maintenanceOperation addObject:itemAll];
                    
                    NSInteger  index = [_maintenanceOperation indexOfObject:itemAll];
                    if (index>2) {
                        itemAll.isHiden=YES;
                    }
                    if (index<2){
                        itemAll.automType = 0;
                    }else{
                        itemAll.automType = 1;
                    }
                    
                    if ([self.driveProjectArray containsObject:itemAll.ItemCode]) {
                        
                        NSInteger index = [self.driveProjectArray indexOfObject:itemAll.ItemCode];
                        NSLog(@"--------------------%@",[self setDriveMdsvtModel:index]);
                    }
                    
                    if (![self IsAutomaticOpen]) {
                        itemAll.isHiden=YES;
                    }
                    
                   
                    
                }
            }
        }
    }
    if (_maintenanceOperation.count == 0) {
        self.dataArray = nil;
    } else {
        self.dataArray = [NSMutableArray array];
        self.hasData = YES;
    }

    return _maintenanceOperation;
}

-(BOOL)ischanged{
    if (self.maintenanceOperation.count == 0) {
        return NO;
    }
   
    BOOL ret = NO;
   
    for (SZMaintenanceCheckItem *itemAll in self.maintenanceOperation) {
        if (itemAll.ischanged) {
            return YES;
        }
    }
    return ret;
}


-(void)setItem:(SZFinalMaintenanceUnitDetialItem *)item{

    _item = item;
    self.item2 = _item;
    self.maintenanceOperation = nil;
    self.arrayCompetedCheckItem = nil;

    [self.tableView reloadData];
}


//1 懒加载
- (NSMutableDictionary *)arrayCompetedCheckItem
{
    if (_arrayCompetedCheckItem ==nil) {
        
        _arrayCompetedCheckItem = [SZModuleQueryTool quaryCompletedMaintenanceItemWithDetialItem:self.item];
    }
    return _arrayCompetedCheckItem;
}


-(void)setAllSelect:(BOOL)allSelect{
    [super setAllSelect:allSelect];
    
    if (self.isFixMode) {
        if (allSelect) {
            for (SZMaintenanceCheckItem *checkItem in self.maintenanceOperation) {
                
                checkItem.state = 2;
            }
        }else{
            for (SZMaintenanceCheckItem *checkItem in self.maintenanceOperation) {
                
                checkItem.state = 1;
            }
        }
        
        
    }else{
        if (allSelect) {
            for (SZMaintenanceCheckItem *checkItem in self.maintenanceOperation) {
                
                checkItem.state = 99;
            }
        }else{
            for (SZMaintenanceCheckItem *checkItem in self.maintenanceOperation) {
                
                checkItem.state = 0;
            }
        }

    
    }
    [self.tableView reloadData];

}

-(BOOL)allSelect{
    if (self.isFixMode) {
        for (SZMaintenanceCheckItem *item in self.maintenanceOperation) {
            if (item.state == 1) {
                return NO;
            }
        }

    }else{
        for (SZMaintenanceCheckItem *item in self.maintenanceOperation) {
            if (item.state == 99) {
                return NO;
            }
        }

    
    }
      return YES;
}
-(BOOL)weixuan{
    
    if (self.isFixMode) {
        for (SZMaintenanceCheckItem *item in self.maintenanceOperation) {
            if (item.state == 1) {
                return NO;
            }
        }
        
    }else{
        for (SZMaintenanceCheckItem *item in self.maintenanceOperation) {
            if (item.state != 99) {
                return NO;
            }
        }
    }
    return NO;
}

-(int)unCompleteCount{
    int count = 0;
    for (SZMaintenanceCheckItem *item in self.maintenanceOperation) {
        if (item.state == 99) {
            count ++;
        }
    }
    return count;

}


-(void)setIsFixMode:(BOOL)isFixMode{
    _isFixMode = isFixMode;
    if (isFixMode) {
        self.maintenanceOperation = nil;
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(CXTitilesViewY + CXTitilesViewH, 0, 150, 0);
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
    
    NSLog(@"=========%ld",(long)gb.isHiden);
    
    
    if (self.item) {
        gb.SchedulesId = self.item.ScheduleID;
    }else{
        gb.SchedulesId = self.item2.ScheduleID;
    }
    
    if (gb.isHiden) {
        cell.automButton.hidden=YES;
    }else{
        cell.automButton.hidden=NO;
    }
    
    switch (gb.automType) {
        case 0:
        {
            [cell.automButton setImage:[UIImage imageNamed:@"OTIS_0"] forState:UIControlStateDisabled];
        }
            break;
        case 1:
        {
            [cell.automButton setImage:[UIImage imageNamed:@"OTIS_1"] forState:UIControlStateDisabled];
        }
            break;
        case 2:
        {

        }
            break;
        case 3:
        {
            
        }
            break;
            
        default:
            break;
    }
    cell.maintenanceOperation = gb;
    cell.isFixMode = self.isFixMode;
    if (self.ispreView) {
        cell.operationBtn.enabled = NO;
    }
    //3 返回
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.ispreView) {
        
    }else{
        SZMaintenanceOperationTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell operationAct:cell.operationBtn];
    }
}

@end
