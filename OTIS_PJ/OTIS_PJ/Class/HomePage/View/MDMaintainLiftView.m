//
//  MDMaintainLiftView.m
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/15.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import "MDMaintainLiftView.h"
#import "MDBaseCell.h"
#import "MDLiftModel.h"
static NSString* const cellID=@"MDMaintainTodayCell";

@interface MDMaintainLiftView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MDMaintainLiftView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        [self setSubviews];
    }
    return self;
}

-(void)setSubviews{
    UITableView* table=[[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
    table.dataSource=self;
    table.separatorColor=MDLightColor;
    table.bounces=NO;
    table.rowHeight=80;
    [self addSubview:table];
    self.table=table;
    table.tableFooterView=[[UIView alloc] init];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(maintainLiftView:)]) {
        return [self.delegate maintainLiftView:self];
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MDMaintainTodayCell* cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[MDMaintainTodayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if ([self.delegate respondsToSelector:@selector(maintainLiftView:index:)]) {
        MDLiftModel* model=[self.delegate maintainLiftView:self index:indexPath.row];
        cell.model=model;
    }
    return cell;
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.table.frame=self.frame;
}
@end
