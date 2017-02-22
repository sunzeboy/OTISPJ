//
//  MDUnrealizedVC.m
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/9.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import "MDUnrealizedVC.h"
#import "Masonry.h"
#import "MDBaseButton.h"
#import "MDBaseCell.h"
#import "MDSynchronousVC.h"
#import "MDLiftModel.h"
#import "MDMaintainLiftView.h"
@interface MDUnrealizedVC ()<UITableViewDelegate,MDMaintainLiftViewDelegate>

@property(nonatomic,strong) NSMutableArray<MDLiftModel*>* dataArray;

@property(nonatomic,weak) MDMaintainLiftView* liftView;

@end

static NSString* const TodayTableViewCellID=@"TodayTableViewCellID";

@implementation MDUnrealizedVC

-(NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor redColor];
    [self setTempData];
    MDMaintainLiftView* liftView=[[MDMaintainLiftView alloc] initWithFrame:self.view.bounds];
    liftView.table.delegate=self;
    liftView.delegate=self;
    [self.view addSubview:liftView];
    self.liftView=liftView;
}

-(void)setTempData{
    
    MDLiftModel* model1=[[MDLiftModel alloc] init];
    model1.liftNo=@"79NP3491";
    model1.dateStr=@"2017-02-10";
    model1.mounth=@"2月下半月";
    model1.address=@"福建省泉州市泉山路普明电信大楼";
    model1.number=@"2619-B-05-2/1";
    [self.dataArray addObject:model1];
    
    MDLiftModel* model2=[[MDLiftModel alloc] init];
    model2.liftNo=@"79NP3479";
    model2.dateStr=@"2017-02-15";
    model2.mounth=@"2月下半月";
    model2.address=@"福建省泉州市泉山路普明电信大楼";
    model2.number=@"2619-B-05-2/1";
    [self.dataArray addObject:model2];
    
    MDLiftModel* model3=[[MDLiftModel alloc] init];
    model3.liftNo=@"79NP3480";
    model3.dateStr=@"2017-02-15";
    model3.mounth=@"2月下半月";
    model3.address=@"福建省泉州市泉山路普明电信大楼";
    model3.number=@"2619-B-05-2/1";
    [self.dataArray addObject:model3];
    
    MDLiftModel* model4=[[MDLiftModel alloc] init];
    model4.liftNo=@"79NP3497";
    model4.dateStr=@"2017-02-15";
    model4.mounth=@"2月下半月";
    model4.address=@"福建省泉州市泉山路普明电信大楼";
    model4.number=@"2619-B-05-2/1";
    [self.dataArray addObject:model4];
    
    MDLiftModel* model5=[[MDLiftModel alloc] init];
    model5.liftNo=@"79NP3498";
    model5.dateStr=@"2017-02-15";
    model5.mounth=@"2月下半月";
    model5.address=@"福建省泉州市泉山路普明电信大楼";
    model5.number=@"2619-B-05-2/1";
    [self.dataArray addObject:model5];
    
    MDLiftModel* model6=[[MDLiftModel alloc] init];
    model6.liftNo=@"79NP3499";
    model6.dateStr=@"2017-02-15";
    model6.mounth=@"2月下半月";
    model6.address=@"中原百货集团股份有限公司";
    model6.number=@"2619-B-05-2/1";
    [self.dataArray addObject:model6];
    
    MDLiftModel* model7=[[MDLiftModel alloc] init];
    model7.liftNo=@"79NP3500";
    model7.dateStr=@"2017-02-15";
    model7.mounth=@"2月下半月";
    model7.address=@"中原百货集团股份有限公司";
    model7.number=@"2619-B-05-2/1";
    [self.dataArray addObject:model7];
    [self.liftView.table reloadData];
}

-(NSInteger)maintainLiftView:(MDMaintainLiftView *)maintainView{
    return self.dataArray.count;
}

-(MDLiftModel*)maintainLiftView:(MDMaintainLiftView *)maintainView index:(NSInteger)row{
    
    return self.dataArray[row];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MDLiftModel* model = self.dataArray[indexPath.row];
    MDSynchronousVC* synchronousVC=[[MDSynchronousVC alloc] initWithLiftModel:model];
    [self.navigationController pushViewController:synchronousVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    self.liftView.frame=self.view.bounds;
}
@end
