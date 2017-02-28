//
//  MDCoverView.m
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/16.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import "MDCoverView.h"

@interface MDCoverView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MDCoverView

-(NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        [self setSubviews];
    }
    return self;
}

-(void)setSubviews{
    UITableView* table=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain];
    table.delegate=self;
    table.dataSource=self;
    table.bounces=NO;
//    table.rowHeight=120;
    table.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self addSubview:table];
    table.tableFooterView=[[UIView alloc] init];
    self.table=table;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* const cellID=@"CoverViewCell";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.numberOfLines=0;
    [cell.textLabel sizeToFit];
    cell.textLabel.text=self.dataArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==1) {
        return 120;
    }
    return 40;
}

@end
