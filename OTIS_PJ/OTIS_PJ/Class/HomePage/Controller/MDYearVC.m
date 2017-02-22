//
//  MDHalfYearVC.m
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/15.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import "MDYearVC.h"
#import "MDMaintainView.h"
#import "MDMatainModel.h"
#import "MDMainTainVM.h"
#import "NSObject+MDObjectTool.h"
@interface MDYearVC ()<MDMaintainViewDelegate>
@property(nonatomic,weak) MDMaintainView* mainView;

@end

@implementation MDYearVC
-(NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}

-(instancetype)init{
    if (self=[super init]) {
        [self setTempModelData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    MDMainTainVM* mainVM=[[MDMainTainVM alloc] init];
    
    MDMaintainView* mainView=[[MDMaintainView alloc] initWithFrame:self.view.bounds];
    mainView.delegate=self;
    [self.view addSubview:mainView];
    self.mainView=mainView;
    
    [mainVM setTableRowHeight:self.dataArray];
    [self.mainView.table reloadData];
}

-(void)setTempModelData{
//    MDMatainModel* model1=[[MDMatainModel alloc] init];
//    model1.title=@"A-3_1";
//    model1.subTitle=@"机房，滑轮环境";
//    model1.content=@"检查轿内装饰是否损坏，检查小门是否锁闭";
//    [self.dataArray addObject:model1];
//    
//    MDMatainModel* model2=[[MDMatainModel alloc] init];
//    model2.title=@"A-3_2";
//    model2.subTitle=@"轿内装潢和操纵盘小门";
//    model2.content=@"检查轿内装饰是否损坏，检查小门是否锁闭";
//    [self.dataArray addObject:model2];
//    
//    MDMatainModel* model3=[[MDMatainModel alloc] init];
//    model3.title=@"A-3_3";
//    model3.subTitle=@"导靴上油杯";
//    model3.content=@"吸油毛垫齐全，油量适宜，油杯无泄漏";
//    [self.dataArray addObject:model3];
//    
//    MDMatainModel* model4=[[MDMatainModel alloc] init];
//    model4.title=@"A-3_4";
//    model4.subTitle=@"对重块及压板";
//    model4.content=@"对重块无松动，压板紧固";
//    [self.dataArray addObject:model4];
//    
//    MDMatainModel* model5=[[MDMatainModel alloc] init];
//    model5.title=@"A-3_5";
//    model5.subTitle=@"井道照明";
//    model5.content=@"齐全，正常";
//    [self.dataArray addObject:model5];
    
    MDMatainModel* model6=[[MDMatainModel alloc] init];
    model6.title=@"A-3_6";
    model6.subTitle=@"轿厢照明，风扇，应急照明";
    model6.content=@"工作正常，没进行一次在正常照明电源断开时，应急照明电源能至少供1W灯泡用电一小时";
    model6.leftTag=1;
    [self.dataArray addObject:model6];
    
    MDMatainModel* model7=[[MDMatainModel alloc] init];
    model7.title=@"A-3_7";
    model7.leftTag=1;
    model7.subTitle=@"轿厢检修开关，急停开关";
    model7.content=@"工作正常";
    [self.dataArray addObject:model7];
//    
//    MDMatainModel* model8=[[MDMatainModel alloc] init];
//    model8.title=@"A-3_8";
//    model8.leftTag=2;
//    model8.subTitle=@"轿门安全装置（安全触板，光幕等）";
//    model8.content=@"功能有效";
//    [self.dataArray addObject:model8];
//    
//    MDMatainModel* model9=[[MDMatainModel alloc] init];
//    model9.title=@"A-3_9";
//    model9.leftTag=0;
//    model9.subTitle=@"轿门门锁电气触点看看看看看看看看看看看";
//    model9.content=@"清洁，触点接触良好，接线可靠";
//    [self.dataArray addObject:model9];
//    
//    MDMatainModel* model10=[[MDMatainModel alloc] init];
//    model10.title=@"A-3_10";
//    model10.subTitle=@"轿门在开启和关闭时";
//    model10.content=@"检查轿内装饰是否损坏，检查小门是否锁闭";
//    model10.leftTag=3;
//    [self.dataArray addObject:model10];
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
