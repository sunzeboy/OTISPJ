//
//  MDMaintainView.m
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/15.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import "MDMaintainView.h"
#import "MDBaseCell.h"
#import "MDMatainModel.h"
#import "CustomIOSAlertView.h"
static NSString* const cellID=@"MDMatainBaseCell";
@interface MDMaintainView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MDMaintainView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        [self setSubviews];
    }
    return self;
}

-(void)setSubviews{
    UITableView* table=[[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
    table.delegate=self;
    table.dataSource=self;
    table.separatorColor=MDLightColor;
    table.bounces=NO;
    [self addSubview:table];
    self.table=table;
    
    table.tableFooterView=[[UIView alloc] init];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(maintainView:)]) {
        return [self.delegate maintainView:self];
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MDMatainBaseCell* cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[MDMatainBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if ([self.delegate respondsToSelector:@selector(maintainView:index:)]) {
        MDMatainModel* model= [self.delegate maintainView:self index:indexPath.row];
        cell.model=model;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(maintainView:indexHeight:)]) {
        return [self.delegate maintainView:self indexHeight:indexPath.row];
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.table.frame=self.frame;
}
@end
