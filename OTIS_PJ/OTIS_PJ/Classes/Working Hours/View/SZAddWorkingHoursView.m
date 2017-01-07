//
//  SZAddWorkingHoursView.m
//  OTIS_PJ
//
//  Created by sunze on 16/7/5.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZAddWorkingHoursView.h"
#import "SZNavigationController.h"
#import "UIView+Extension.h"
#import "SZTable_LaborType.h"

@interface SZAddWorkingHoursView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *types;

@end
@implementation SZAddWorkingHoursView

//1 懒加载
- (NSArray *)types
{
    if (_types ==nil) {
        SZNavigationController *nav = (SZNavigationController*)(((UIViewController *)[self viewController]).navigationController);
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

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.tableView.rowHeight = 60;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        [self addSubview:self.tableView];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
    }
    return self;
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
        cell.imageView.image = [UIImage imageNamed:@"CB"];
    }else{
        cell.imageView.image = [UIImage imageNamed:gb.LaborType];
        
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        SZLabor *gb = self.types[indexPath.row];
        
        if (self.selectedBlock) {
            self.selectedBlock(gb);
        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.navigationController popViewControllerAnimated:YES];
//            
//        });
    });
    
    
}

-(void)SynchronizData{
    [self.tableView reloadData];
    
}

@end
