//
//  SZSelectViewController.m
//  OTIS_PJ
//
//  Created by sunze on 16/5/24.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZSelectViewController.h"
#import "SZModuleQueryTool.h"
#import "SZJobHazard.h"
#import "SZCheckBoxViewCell.h"
#import "Masonry.h"

@interface SZSelectViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *sectionTitle;
@property(nonatomic,weak)UITableView* tableview;
@end

@implementation SZSelectViewController

- (BOOL)shouldAutorotate{
    
    return NO;
}
- (NSArray *)titleArray {
    
    if (_titleArray == nil) {
        
        NSArray *array = [SZModuleQueryTool quarySectionTitleNameWithJhaTypeId:self.item.JhaTypeId];
        
        NSMutableArray *titles1 = [NSMutableArray array];
        NSMutableArray *titles2 = [NSMutableArray array];
        NSMutableArray *titles3 = [NSMutableArray array];
        
        for (SZJHATitleItem *jhaItem in array) {
            
            for (SZJHATitleItem *item in self.selectedtitleArray) {
                if (item.JhaCodeId == jhaItem.JhaCodeId) {
                    jhaItem.select = YES;
                    jhaItem.Other = item.Other;
                }
            }
            
            if ([jhaItem.title isEqualToString:SZLocal(@"dialog.content.The following risks may occur")]) {
                [titles1 addObject:jhaItem];
            }else if ([jhaItem.title isEqualToString:SZLocal(@"dialog.content.Possible FPA projects")]){
                [titles2 addObject:jhaItem];
                
            }else if ([jhaItem.title isEqualToString:SZLocal(@"dialog.content.Control method adopted")]){
                [titles3 addObject:jhaItem];
                
            }
        }
        
        _titleArray = @[titles1,titles2,titles3];
    }
    return _titleArray;
}


//1 懒加载
- (NSArray *)sectionTitle
{
    if (_sectionTitle ==nil) {
        _sectionTitle = @[SZLocal(@"dialog.content.The following risks may occur"),SZLocal(@"dialog.content.Possible FPA projects"),SZLocal(@"dialog.content.Control method adopted")];
    }
    return _sectionTitle;
}



-(NSArray *)selectedtitleArray{
    if (_selectedtitleArray ==nil) {
        _selectedtitleArray = [NSArray array];
    }
    return _selectedtitleArray;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabelView];
}

-(void)setTabelView{
    
    UITableView* tableview=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableview.delegate=self;
    tableview.dataSource=self;
    [self.view addSubview:tableview];
    self.tableview=tableview;
    UIEdgeInsets insets=UIEdgeInsetsMake(64+35, 0, 135, 0);
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(insets);
    }];
}

// 返回Header的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return [self.sectionTitle objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
//返回每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SZCheckBoxViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"SZCheckBoxViewCell"];
    if (!cell) {
        cell=[[SZCheckBoxViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SZCheckBoxViewCell"];
    }
    cell.cellCount= indexPath.section;
    cell.dataArray=self.titleArray;
    cell.editBlock=^{
        UIEdgeInsets insets=UIEdgeInsetsMake(0, 0, 350, 0);
        [tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(insets);
        }];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    };
    cell.endEditBlock=^{
        UIEdgeInsets insets=UIEdgeInsetsMake(64+35, 0, 150, 0);
        [tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(insets);
        }];
    };
    
    cell.updateTableviewBlock=^{
        [self.tableview reloadData];
    };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return 130;
            break;
        case 1:
            return 170;
            break;
        case 2:
            return 250;
            break;
        default:
            break;
    }
    return 100;
}



-(void)dealloc{
}

@end
