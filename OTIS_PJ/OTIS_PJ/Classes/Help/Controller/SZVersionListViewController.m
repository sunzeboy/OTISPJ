//
//  SZVersionListViewController.m
//  OTIS_PJ
//
//  Created by sunze on 16/9/6.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZVersionListViewController.h"

@interface SZVersionListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) NSDictionary *dataArray;


@end

@implementation SZVersionListViewController
- (BOOL)shouldAutorotate{
    
    return NO;
}

-(NSDictionary *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSDictionary dictionaryWithObjectsAndKeys:@"V1.0.35",@"1.服务器指向奥的斯云应用服务器。 \n2.专供上海8名服务技师做维保使用。 \n3.解决了维保中每年一次的问题 \n4.奥的斯鹰 IOS版本供上海小范围使用。如有问题，请联系奥的斯HelpDesk或者开发工程师！",@"V1.0.36",@" \n1.奥的斯鹰 IOS版本上架App Store。如有问题，请联系奥的斯HelpDesk或者开发工程师！" ,@"V1.0.37",@" \n1.兼容iOS10.0",
                      nil];
    }
    return _dataArray;
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self setExtraCellLineHidden:_tableView];
    }
    return _tableView;

}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self.view addSubview:self.tableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellID"];
    }
    NSString *version = self.dataArray.allValues[indexPath.row];
    NSString *dec = self.dataArray.allKeys[indexPath.row];
    cell.textLabel.text = version;
    cell.detailTextLabel.text = dec;
    cell.detailTextLabel.numberOfLines = 0;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 130;
    }else if (indexPath.row == 1){
        return 80;
    }
    return 50;
}


@end
