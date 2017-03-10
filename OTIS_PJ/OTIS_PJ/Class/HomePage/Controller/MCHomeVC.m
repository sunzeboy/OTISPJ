//
//  MCHomeVC.m
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/9.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import "MCHomeVC.h"
#import "Masonry.h"
#import "MDBaseCell.h"
#import "MDBaseButton.h"
#import "MDMaintainVC.h"
#import "MDSetingVC.h"
#import "MDAboutVC.h"
#import "MBProgressHUD.h"
#import "MDCoverView.h"
#import "CustomIOSAlertView.h"
#import "MaintenanceViewController.h"
#import "SZUploadManger.h"
#import "SZHttpTool.h"

@interface MCHomeVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,weak) UICollectionView* topCollectionView;
@property(nonatomic,weak) UICollectionView* boomCollectionView;

@property(nonatomic,strong) NSArray* titleArray;
@property(nonatomic,strong) NSArray* imageArray;

@end

static NSString* const MDBaseCellID=@"MDBaseCellID";
static NSString* const MDHomeBoomCellID=@"MDHomeBoomCellID";


@implementation MCHomeVC

-(NSArray*)titleArray{
    if (!_titleArray) {
        _titleArray=[NSArray arrayWithObjects:@"维保",@"同步数据",@"设置",@"关于", nil];
    }
    return _titleArray;
}

-(NSArray*)imageArray{
    if (!_imageArray) {
        _imageArray=[NSArray arrayWithObjects:@"首页_05",@"首页_07",@"首页_11",@"首页_12", nil];
    }
    return _imageArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = nil;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"OTIS MD";
    self.automaticallyAdjustsScrollViewInsets=NO;
//    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self setSubviews];
    //自动同步
    [SZUploadManger startUploadAndDownloadWithView:self.view];
    
    NSString* isAutomatickey=[[NSUserDefaults standardUserDefaults] objectForKey:IsAutomatickey];
    if (isAutomatickey==nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:IsAutomatickey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


-(void)setSubviews{
    
    UICollectionViewFlowLayout* topCollectionViewFlowLayout=[[UICollectionViewFlowLayout alloc] init];
    topCollectionViewFlowLayout.itemSize=CGSizeMake(MDScreenW, MDScreenH/4.0);
    topCollectionViewFlowLayout.minimumInteritemSpacing=0;
    topCollectionViewFlowLayout.minimumLineSpacing=0;
    topCollectionViewFlowLayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView* topCollectionView=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:topCollectionViewFlowLayout];
    topCollectionView.delegate=self;
    topCollectionView.dataSource=self;
    topCollectionView.bounces=NO;
    topCollectionView.pagingEnabled=YES;
    topCollectionView.showsHorizontalScrollIndicator=NO;
    topCollectionView.backgroundColor=[UIColor clearColor];
    [topCollectionView registerClass:[MDBaseCell class] forCellWithReuseIdentifier:MDBaseCellID];
    [self.view addSubview:topCollectionView];
    self.topCollectionView=topCollectionView;
    
    [topCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(64);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.mas_equalTo(MDScreenH/4.0+1);
    }];
    
    UICollectionViewFlowLayout* boomCollectionViewFlowLayout=[[UICollectionViewFlowLayout alloc] init];
    boomCollectionViewFlowLayout.itemSize=CGSizeMake(120, 120);
    boomCollectionViewFlowLayout.minimumInteritemSpacing=10;
    boomCollectionViewFlowLayout.minimumLineSpacing=60;
    boomCollectionViewFlowLayout.sectionInset=UIEdgeInsetsMake(30, 30, 10, 30);
    boomCollectionViewFlowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
    
    UICollectionView* boomCollectionView=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:boomCollectionViewFlowLayout];
    boomCollectionView.delegate=self;
    boomCollectionView.dataSource=self;
    boomCollectionView.backgroundColor=[UIColor clearColor];
    [boomCollectionView registerClass:[MDHomeBoomCell class] forCellWithReuseIdentifier:MDHomeBoomCellID];
    [self.view addSubview:boomCollectionView];
    self.boomCollectionView=boomCollectionView;
    
    [boomCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topCollectionView.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView==self.topCollectionView) {
        return 1;
    }
    return 4;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView==self.topCollectionView) {
        MDBaseCell* cell=[collectionView dequeueReusableCellWithReuseIdentifier:MDBaseCellID forIndexPath:indexPath];
        cell.backImageView.image=[UIImage imageNamed:@"homePage1"];
        return cell;
    }else{
        MDHomeBoomCell* cell=[collectionView dequeueReusableCellWithReuseIdentifier:MDHomeBoomCellID forIndexPath:indexPath];
        [cell.button setTitle:self.titleArray[indexPath.row] forState:UIControlStateNormal];
        [cell.button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home%ld",indexPath.row+1]] forState:UIControlStateDisabled];
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView==self.boomCollectionView) {
        switch (indexPath.row) {
            case 0:{
//                MDMaintainVC* maintainVC=[[MDMaintainVC alloc] initWithTitleArray:@[@"今天",@"未完成"] boomViewButtonArray:@[@"扫一扫"]];
//                [self.navigationController pushViewController:maintainVC animated:YES];
                MaintenanceViewController *vc = [[MaintenanceViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];

            }
                break;
            case 1:
            {                
                [self tongbushuju];
            }
                break;
            case 2:
            {
                MDSetingVC* setVC=[[MDSetingVC alloc]init];
                [self.navigationController pushViewController:setVC animated:YES];
            }
                break;
            case 3:{
                MDAboutVC* aboutVC=[[MDAboutVC alloc] init];
                [self.navigationController pushViewController:aboutVC animated:YES];
                
//                NSDictionary* dic = @{@"head":@{@"employeeID":@103338,@"password":@"a.123",@"ver":@"1.0"},@"body":@{@"scheduleID":@11,@"unitNo":@"HT222NH",@"createTime":[self getNowDate],@"eventLog":@"ddd"}};
//                
//                NSLog(@"==%@",dic.mj_JSONString);
//                
//                [SZHttpTool noPasswordpost:@"http://192.168.30.65/LBS_Mobile/Terminal/mdSaveEventLog" parameters:dic success:^(id obj) {
//                    
//                } failure:^(NSError *error) {
//                    
//                }];
            }
                break;
            default:
                break;
        }
    }
}

-(NSString*)getNowDate{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    return [formatter stringFromDate:[NSDate date]];
}

-(void)tongbushuju{
    WEAKSELF
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                 dialogContents:SZLocal(@"dialog.content.confirmDataSync")
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        if(buttonIndex == 0){
            [SZUploadManger startUploadAndDownloadWithView:weakSelf.view];
            
            [alertView close];
        }else if(buttonIndex == 1){
            [alertView close];
        }
    };
    [alertView show];
    
    
}

-(void)setBackButton{}
@end
