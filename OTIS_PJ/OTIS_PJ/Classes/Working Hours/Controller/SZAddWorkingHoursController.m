//
//  SZAddWorkingHoursController.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/16.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZAddWorkingHoursController.h"

#import "SZTable_LaborType.h"

#import "SZNavigationController.h"

@interface SZAddWorkingHoursController ()

@property (nonatomic, strong) NSArray *types;

@end

@implementation SZAddWorkingHoursController
- (BOOL)shouldAutorotate{
    
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = SZLocal(@"title.WorkingHoursViewController.addType");
    self.tableView.rowHeight = 50;
    [self setExtraCellLineHidden:self.tableView];
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

}
//1 懒加载
- (NSArray *)types
{
    if (_types ==nil) {
        SZNavigationController *nav = (SZNavigationController*)self.navigationController;
        if (self.zhongduan) {//中断工作调整原因
            _types = [SZTable_LaborType quaryaddZhongDuan];

        }else{
            if (nav.laborProperty == 4) {//非本公司工时
                _types = [SZTable_LaborType quaryAddWHTypeWithArray:self.selectedTypes];
                
            }else{
                _types = [SZTable_LaborType quaryaddWHTypeWithArray:self.selectedTypes];
            }

        
        }
        
    }
    return _types;
}

//返回每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.types.count;
}
//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SZLabor *gb = self.types[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ID"];
    }
    
    cell.textLabel.text = gb.LaborName;
    if (gb.LaborTypeID>20) {
        cell.imageView.image = [UIImage imageNamed:@"lht_default"];
    }else{
        cell.imageView.image = [UIImage imageNamed:gb.LaborType];
        
    }
    
    if (gb.LaborTypeID == 0) {
        UIImage *image = [UIImage imageNamed:gb.LaborType];
        if (image) {
            cell.imageView.image = [UIImage imageNamed:gb.LaborType];
        }else{
            cell.imageView.image = [UIImage imageNamed:@"lht_default"];
        }
    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

        SZLabor *gb = self.types[indexPath.row];
        
        if (self.selectedBlock) {
            if (self.types.count==1) {
                self.selectedBlock(gb,YES);
            }else{
                self.selectedBlock(gb,NO);
            }
        }

            [self.navigationController popViewControllerAnimated:YES];

   
    
}


-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
}
-(void)dealloc{
    SZLog(@"sile...");
    
}

@end
