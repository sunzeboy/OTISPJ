//
//  SZSynchronizationView.m
//  OTIS_PJ
//
//  Created by sunze on 16/7/4.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZSynchronizationView.h"
#import "AppDelegate.h"
#import "UIView+Extension.h"

@interface SZSynchronizationView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;

@end

@implementation SZSynchronizationView

- (NSMutableArray *)dateArray
{
    if (_dateArray ==nil) {
        _dateArray = [NSMutableArray array];
        
    }
    return _dateArray;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.tintColor = [UIColor blueColor];
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, frame.size.width, frame.size.height)];
        self.tableView.rowHeight = 30;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 50)];
        
        self.tableView.tableHeaderView = headView;
        [self addSubview:self.tableView];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
    }
    return self;
}

//返回每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dateArray.count;
}
//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *gb = self.dateArray[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ID"];
        
    }
    
    cell.textLabel.text = gb;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)SynchronizData{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView reloadData];

}




@end
