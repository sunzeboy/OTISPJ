//
//  MDHalfMounthVC.m
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/15.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import "MDHalfMounthVC.h"
#import "MDMaintainView.h"
#import "MDMatainModel.h"
#import "MDMainTainVM.h"
#import "NSObject+MDObjectTool.h"
@interface MDHalfMounthVC ()<MDMaintainViewDelegate>
@property(nonatomic,weak) MDMaintainView* mainView;

@end


@implementation MDHalfMounthVC

-(instancetype)init{
    if (self=[super init]) {
        [self setTempModelData];
    }
    return self;
}

-(NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    MDMainTainVM* mainVM=[[MDMainTainVM alloc] init];
    
    MDMaintainView* mainView=[[MDMaintainView alloc] initWithFrame:self.view.bounds];
    mainView.delegate=self;
    [self.view addSubview:mainView];
    self.mainView=mainView;
    
    [mainVM setTableRowHeight:self.dataArray];
    [self.mainView.table reloadData];
}

-(void)setTempModelData{
    MDMatainModel* model1=[[MDMatainModel alloc] init];
    model1.title=@"A-3_1";
    model1.subTitle=@"机房，滑轮环境";
    model1.content=@"检查轿内装饰是否损坏，检查小门是否锁闭";
    model1.leftTag=1;
    [self.dataArray addObject:model1];
    
    MDMatainModel* model2=[[MDMatainModel alloc] init];
    model2.title=@"A-3_2";
    model2.leftTag=1;
    model2.subTitle=@"轿内装潢和操纵盘小门";
    model2.content=@"检查轿内装饰是否损坏，检查小门是否锁闭";
    [self.dataArray addObject:model2];
    
    MDMatainModel* model3=[[MDMatainModel alloc] init];
    model3.title=@"A-3_3";
    model3.leftTag=2;
    model3.subTitle=@"导靴上油杯";
    model3.content=@"吸油毛垫齐全，油量适宜，油杯无泄漏";
    [self.dataArray addObject:model3];
    
    MDMatainModel* model4=[[MDMatainModel alloc] init];
    model4.title=@"A-3_4";
    model4.leftTag=1;
    model4.isHiden=YES;
    model4.subTitle=@"对重块及压板";
    model4.content=@"对重块无松动，压板紧固";
    [self.dataArray addObject:model4];
    
    MDMatainModel* model5=[[MDMatainModel alloc] init];
    model5.title=@"A-3_5";
    model5.leftTag=1;
    model5.isHiden=YES;
    model5.subTitle=@"井道照明";
    model5.content=@"齐全，正常";
    [self.dataArray addObject:model5];
    
    MDMatainModel* model6=[[MDMatainModel alloc] init];
    model6.title=@"A-3_6";
    model6.isHiden=YES;
    model6.subTitle=@"轿厢照明，风扇，应急照明";
    model6.content=@"工作正常，没进行一次在正常照明电源断开时，应急照明电源能至少供1W灯泡用电一小时";
    model6.leftTag=1;
    [self.dataArray addObject:model6];
}

-(NSInteger)maintainView:(MDMaintainView *)maintainView{
    return self.dataArray.count;
}

-(MDMatainModel*)maintainView:(MDMaintainView *)maintainView index:(NSInteger)row{
    return self.dataArray[row];
}

-(CGFloat)maintainView:(MDMaintainView *)maintainView indexHeight:(NSInteger)row{
    return self.dataArray[row].rowHeight;
}


-(void)setIsRefresh:(BOOL)isRefresh{
    _isRefresh=isRefresh;
    [self.mainView.table reloadData];
}

-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    self.mainView.frame=self.view.bounds;
}

@end
