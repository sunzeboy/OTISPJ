//
//  SZMaintenanceHalfYearViewController.m
//  OTIS_PJ
//
//  Created by zy on 16/5/6.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZMaintenanceHalfYearViewController.h"
#import "SZMaintenanceOperation.h"
#import "SZMaintenanceOperationTableViewCell.h"
#import "SZModuleQueryTool.h"
#import "SZMaintenanceCheckItem.h"
@interface SZMaintenanceHalfYearViewController ()<UITableViewDataSource>

@property (nonatomic , strong) NSMutableDictionary *arrayCompetedCheckItem;

@end

@implementation SZMaintenanceHalfYearViewController
// 懒加载
- (NSMutableArray *)maintenanceOperation {
    
    if (_maintenanceOperation == nil) {
        
        _maintenanceOperation = [NSMutableArray array];

        if (self.isFixMode) {
            
            
            NSMutableArray *arrayAll = [NSMutableArray arrayWithArray:[SZModuleQueryTool quaryOtherMaintenanceItemWithDetialItem:self.item2 andTimeType:OTISMaintenanceItemTimeTypeHalfYear]];
            
            NSMutableDictionary *dicFix = [SZModuleQueryTool quaryMaintenanceItemFixWithDetialItem:self.item2];
            
            for (SZMaintenanceCheckItem *itemFix in arrayAll) {
                if (dicFix[itemFix.ItemCode]) {
                    SZMaintenanceCheckItem *item = itemFix;
                    item.state = [dicFix[itemFix.ItemCode] intValue];
                    item.state2 = item.state;
                    [_maintenanceOperation addObject:item];
                }
                
            }
        
            
        }else if(self.isSign){//签字
            
            NSMutableArray *arrayAll = [NSMutableArray arrayWithArray:[SZModuleQueryTool quaryOtherMaintenanceItemWithDetialItem:self.item2 andTimeType:OTISMaintenanceItemTimeTypeHalfYear]];
            
            NSMutableDictionary *dicFix = self.arrayCompetedCheckItem;
            
            for (SZMaintenanceCheckItem *itemFix in arrayAll) {
                if (dicFix[itemFix.ItemCode]) {
                    SZMaintenanceCheckItem *item = itemFix;
                    SZMaintenanceCheckItem *item2 = dicFix[itemFix.ItemCode];
                    item.state = item2.state;
                    item.state2 = item.state;
                    [_maintenanceOperation addObject:item];
                }
                
            }
            
            
            
        }else{
            if (!self.item) {
                self.item = self.item2;
            }
            
            if (_maintenanceOperation.count) {
                return _maintenanceOperation;
            }
            NSMutableArray *arrayTemp = [NSMutableArray arrayWithArray:[SZModuleQueryTool quaryOtherMaintenanceItemWithDetialItem:self.item andTimeType:OTISMaintenanceItemTimeTypeHalfYear]];
            
            for (SZMaintenanceCheckItem *itemAll in arrayTemp) {
                
                SZMaintenanceCheckItem *item = self.arrayCompetedCheckItem[itemAll.ItemCode];
                if (item &&  item.isUpload == YES) {
                    continue;
                    
                }else {
                    if(item){
                        itemAll.state = item.state;
                        itemAll.state2 = item.state;
                    }
                    [_maintenanceOperation addObject:itemAll];
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



-(void)setIsFixMode:(BOOL)isFixMode{
    _isFixMode = isFixMode;
    if (isFixMode) {
        self.maintenanceOperation = nil;
        [self.tableView reloadData];
    }
}

//1 懒加载
- (NSMutableDictionary *)arrayCompetedCheckItem
{
    if (_arrayCompetedCheckItem ==nil) {
        if (!self.item) {
            self.item = self.item2;
        }
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(CXTitilesViewY + CXTitilesViewH, 0, 150, 0);

    if (self.maintenanceOperation.count == 0) {
        self.dataArray = nil;
    } else {
        self.hasData = YES;
    }
    
}
-(void)setItem:(SZFinalMaintenanceUnitDetialItem *)item{
    
    _item = item;
    self.item2 = _item;
    self.maintenanceOperation = nil;
    self.arrayCompetedCheckItem = nil;
    [self.tableView reloadData];
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
    if (self.item) {
        gb.SchedulesId = self.item.ScheduleID;
    }else{
        gb.SchedulesId = self.item2.ScheduleID;
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
