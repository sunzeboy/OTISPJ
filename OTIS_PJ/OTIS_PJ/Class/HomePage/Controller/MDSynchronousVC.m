//
//  MDSynchronousVC.m
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/10.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import "MDSynchronousVC.h"
#import "Masonry.h"
#import "MDBaseButton.h"
#import "MDMainOperationVC.h"
#import "MDTool.h"
#import "MDMaintainVC.h"
#import "CustomIOSAlertView.h"
#import "MDCoverView.h"
#import "MBProgressHUD.h"
#import "SZFinalMaintenanceUnitDetialItem.h"
#import "SZMaintenanceOperationViewController.h"
#import "MDSVTModel.h"
#import "AFNetworking.h"

//Otis-
static NSString* wifiNameFix = @"Otis-";

@interface MDSynchronousVC ()
@property (nonatomic,copy) NSString* wifiName;
@property(assign) CGFloat titleHeight;
@property(nonatomic,strong) SZFinalMaintenanceUnitItem* liftModel;
@property(nonatomic,weak) UITextView* textView;


@property(nonatomic,weak) UILabel* titleLabel;
@property(nonatomic,weak) UILabel* wifiLabel;
@property(nonatomic,strong) NSTimer* timer;
@property(nonatomic,strong) MDSVTModel* svtModel;

@end

@implementation MDSynchronousVC

-(void)dealloc{
    self.liftModel = nil;
    self.wifiName = nil;
}


-(NSTimer*)timer{
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerfunc) userInfo:nil repeats:YES];
    }
    return _timer;
}

-(void)timerfunc{
    NSDictionary* wifiDic =[MDTool SSIDInfo];
    if (wifiDic==nil) return;
    self.wifiName=wifiDic[@"SSID"];
    if (![self.wifiName hasPrefix:wifiNameFix]) {
        self.titleHeight=30;
    }else{
        self.titleHeight=0;
        self.wifiLabel.text = [NSString stringWithFormat:@"当前所连接wifi名称：%@",self.wifiName];
        [self clearTimer];
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(MDScreenW, self.titleHeight));
        }];
    }
}

-(instancetype)initWithLiftModel:(SZFinalMaintenanceUnitItem*)model{
    if (self=[super init]) {
        self.liftModel = model;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self.timer fire];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self clearTimer];
}

-(void)clearTimer{
    [self.timer invalidate];
    self.timer=nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"从SVT获取数据";
    [self setNetwork];
    NSDictionary* wifiDic =[MDTool SSIDInfo];
    self.wifiName=wifiDic[@"SSID"];
    if (self.wifiName==nil||[self.wifiName isEqualToString:@""]||![self.wifiName hasPrefix:wifiNameFix]) {
        self.titleHeight=30;
    }else{
        self.titleHeight=0;
    }
    [self setSubviews];
    
//    [self testModel];
    WEAKSELF
    self.appBackBlock = ^{
      
        MDCoverView* coverView=[[MDCoverView alloc] initWithFrame:weakSelf.view.bounds];
        coverView.alpha=0.9;
        [weakSelf.view addSubview:coverView];

        NSString* tempStr = @"";
        
        if ([weakSelf.appString isEqualToString:@""]||weakSelf.appString==nil) {
            tempStr = @"SVT数据获取失败";
            [coverView.dataArray addObject:tempStr];
        }else{
            NSLog(@"-----------%@",weakSelf.appString);
            tempStr = @"SVT数据获取成功:";
            [coverView.dataArray addObject:tempStr];
//            NSRange range =[weakSelf.appString rangeOfString:@"MDApp://callType=SVTApp&eventLog="];
//            weakSelf.appString = [weakSelf.appString substringFromIndex:range.length+range.location];
            [coverView.dataArray addObject:weakSelf.appString];
            weakSelf.textView.text=weakSelf.appString;
//            NSData *jsonData = [weakSelf.appString dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary* dic =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//            NSLog(@"******%@**",dic[@"SVT"][@"Controller"]);
//            MDSVTModel* model =[MDSVTModel mj_objectWithKeyValues:dic[@"SVT"]];
            
//            NSLog(@"%@",model);
        }
        
        [coverView.table reloadData];
        CustomIOSAlertView* alertView1=[[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:nil dialogTitle:@"温馨提示" dialogContents:tempStr dialogButtons:[NSMutableArray arrayWithObjects:@"确定", nil]];
        alertView1.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView1, int buttonIndex){
            [coverView removeFromSuperview];
            [alertView1 close];
        };
        [alertView1 show];
    };
}


-(void)testModel{
    
    NSDictionary* dic = @{@"SVT":@{@"controllerModel":@{@"SoftwareBaselineVersion": @"G16GAE_K18C",@"IsEventLogComplete":@"False",@"ErrorData":@{
        @"Step": @"GECB+macro+step22",
        @"ErrorCode": @"1001",
        },},@"Drive":@{@"SoftwareBaselineVersion": @"G16GAE_K18C",@"IsEventLogComplete":@"True",@"SCN": @"31400",@"DriveEvents":@[@{ @"EventNumber": @"912",
                                                                                                       @"EventName": @"+No+FloorInfo",
                                                                                                       @"ElapsedTime": @"0000:00:00:01.81"}, @{
                                                                                                           @"EventNumber": @"517",
                                                                                                           @"EventName": @"+DDP+Error+++",
                                                                                                           @"ElapsedTime": @"0000:00:00:01.17"
                                                                                                           },  @{
                                                                                                               @"EventNumber": @"000",
                                                                                                               @"EventName": @"+Power+On++++",
                                                                                                               @"ElapsedTime": @"0000:00:00:00.62"
                                                                                                           }],@"SavedDriveEvents":@[@{
                                                                                                                                         @"EventNumber": @"912",
                                                                                                                                         @"EventName": @"+No+FloorInfo",
                                                                                                                                         @"ElapsedTime": @"0000:00:00:01.81"
                                                                                                                                         },@{
                                                                                                                                             @"EventNumber": @"517",
                                                                                                                                             @"EventName": @"+DDP+Error+++",
                                                                                                                                             @"ElapsedTime": @"0000:00:00:01.17"
                                                                                                                                             }, @{
                                                                                                                                                 @"EventNumber": @"517",
                                                                                                                                                 @"EventName": @"+DDP+Error+++",
                                                                                                                                                 @"ElapsedTime": @"0000:00:00:52.18"
                                                                                                                                             },]}}};
    
    MDSVTModel* model =[MDSVTModel mj_objectWithKeyValues:dic[@"SVT"]];
    self.svtModel = model;
}


-(void)setNetwork{

    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
                case AFNetworkReachabilityStatusNotReachable:{
                    NSLog(@"无网络");
                    break;
                }
                case AFNetworkReachabilityStatusReachableViaWiFi:{
                    NSLog(@"WiFi网络");
                    break;
                }
                case AFNetworkReachabilityStatusReachableViaWWAN:{
                    NSLog(@"3G网络");
                    break;
                }
            default:
                break;
        }
    }];
}

-(void)setSubviews{
    
    UILabel* titleLabel=[[UILabel alloc] init];
    titleLabel.font=[UIFont systemFontOfSize:14.0];
    titleLabel.text=@"请连接到指定wifi网络";
    titleLabel.textColor=MDColor(37, 63, 96, 1.0);
    [self.view addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel* UnitNoLabel=[[UILabel alloc] init];
    UnitNoLabel.text=[NSString stringWithFormat:@"电梯编号                 ：%@",self.liftModel.UnitNo];
    UnitNoLabel.textColor=MDColor(37, 63, 96, 1.0);
    [self.view addSubview:UnitNoLabel];
    
    UIView*lineView1=[[UIView alloc] init];
    lineView1.backgroundColor=MDDescriptionColor;
    [self.view addSubview:lineView1];
    
    UILabel* wifiLabel=[[UILabel alloc] init];
    wifiLabel.textColor=MDColor(37, 63, 96, 1.0);
    if (self.wifiName!=nil) {
        wifiLabel.text=[NSString stringWithFormat:@"当前所连接wifi名称：%@",self.wifiName];
    }else{
        wifiLabel.text=[NSString stringWithFormat:@"当前所连接wifi名称：请连接到指定wifi网络"];
    }
    [self.view addSubview:wifiLabel];
    self.wifiLabel = wifiLabel;
    
    UIView*lineView2=[[UIView alloc] init];
    lineView2.backgroundColor=MDDescriptionColor;
    [self.view addSubview:lineView2];
    
    UILabel* resultLabel=[[UILabel alloc] init];
    resultLabel.textColor=MDColor(37, 63, 96, 1.0);
    resultLabel.text=@"从SVT获取数据的结果 :";
    [self.view addSubview:resultLabel];
    
    UITextView* resultDetailLabel=[[UITextView alloc] init];
    resultDetailLabel.text=@"从SVT获取数据的结果 :";
    resultDetailLabel.layer.borderWidth=1.0;
    resultDetailLabel.font=[UIFont systemFontOfSize:16.0];
    resultDetailLabel.layer.borderColor=[UIColor lightGrayColor].CGColor;
    resultDetailLabel.editable=NO;
    [self.view addSubview:resultDetailLabel];
    self.textView=resultDetailLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(64);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(MDScreenW, self.titleHeight));
    }];
    
    [UnitNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(5);
        make.left.equalTo(titleLabel.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(MDScreenW, 30));
    }];
    
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(UnitNoLabel.mas_bottom).with.offset(5);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(MDScreenW, 0.5));
    }];
    
    [wifiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView1.mas_bottom).with.offset(5);
        make.left.equalTo(titleLabel.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(MDScreenW, 30));
    }];
    
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wifiLabel.mas_bottom).with.offset(5);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(MDScreenW, 0.5));
    }];
    
    [resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView2.mas_bottom).with.offset(5);
        make.left.equalTo(titleLabel.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(MDScreenW, 30));
    }];
    
    [resultDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(resultLabel.mas_bottom).with.offset(5);
        make.left.equalTo(titleLabel.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(MDScreenW-40, 200));
    }];
    
    
    UIView* boomView=[[UIView alloc] init];
    boomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:boomView];
    
    UIView* lineView=[[UIView alloc] init];
    lineView.backgroundColor=MDDescriptionColor;
    [boomView addSubview:lineView];
    
    [boomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.mas_equalTo(60);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(boomView.mas_left).with.offset(0);
        make.right.equalTo(boomView.mas_right).with.offset(0);
        make.top.equalTo(boomView.mas_top).with.offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    MDMaintainButton* svtButton=[[MDMaintainButton alloc] init];
    svtButton.titleLabel.font=[UIFont systemFontOfSize:13.0];
    svtButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
    svtButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    [svtButton setImage:[UIImage imageNamed:@"btn_confirm"] forState:UIControlStateNormal];
    [svtButton setTitle:@"开始" forState:UIControlStateNormal];
    [svtButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [svtButton addTarget: self action:@selector(svtButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [boomView addSubview:svtButton];
    
    MDMaintainButton* nextButton=[[MDMaintainButton alloc] init];
    nextButton.titleLabel.font=[UIFont systemFontOfSize:13.0];
    nextButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
    nextButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    [nextButton setImage:[UIImage imageNamed:@"btn_next_blue"] forState:UIControlStateNormal];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [nextButton addTarget: self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [boomView addSubview:nextButton];
    
    [svtButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(boomView.mas_left).with.offset(0);
        make.top.equalTo(boomView.mas_top).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(MDScreenW/2.0, 50));
    }];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(boomView.mas_right).with.offset(0);
        make.top.equalTo(boomView.mas_top).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(MDScreenW/2.0, 50));
    }];
}

-(void)navPopClick:(UIButton*)button{
    
    for (UIViewController* vc in self.navigationController.childViewControllers) {
        if ([vc isMemberOfClass:[MDMaintainVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

-(void)svtButtonClick{
    
    BOOL isCanUse;
    NSString* alertTitle;
    NSString* confirmStr;
    if (self.wifiName==nil||[self.wifiName isEqualToString:@""]||![self.wifiName hasPrefix:wifiNameFix]) {
        alertTitle = @"请在指定Wifi下操作";
        confirmStr = @"设置";
        isCanUse = NO;
    }else{
        alertTitle = @"您确认从SVT获取数据吗？";
        confirmStr = @"确定";
        isCanUse = YES;
    }
    
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:@"温馨提示"
                                                                                 dialogContents:alertTitle
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:confirmStr,@"取消", nil]];
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        if (buttonIndex==0) {
             [alertView close];
            if (isCanUse) {
                NSURL *appBUrl = [NSURL URLWithString:[NSString stringWithFormat:@"SVTApp://callType=MDApp&elevCode=%@",self.liftModel.UnitNo]];
                NSLog(@"----%@",[NSString stringWithFormat:@"SVTApp://callType=MDApp&elevCode=%@",self.liftModel.UnitNo]);
                // 2.判断手机中是否安装了对应程序
                if ([[UIApplication sharedApplication] canOpenURL:appBUrl]) {
                    // 3. 打开应用程序App-B
                    [[UIApplication sharedApplication] openURL:appBUrl];
                } else {
                    CustomIOSAlertView* alertView2=[[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:nil dialogTitle:@"温馨提示" dialogContents:@"没有安装指定App" dialogButtons:[NSMutableArray arrayWithObjects:@"确定", nil]];
                    alertView2.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView2, int buttonIndex){
                        [alertView2 close];
                    };
                    [alertView2 show];
                }
            }else{
                 [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }else{
            [alertView close];
        }
    };
    [alertView show];
}

-(void)nextButtonClick{
    SZMaintenanceOperationViewController *vc = [[SZMaintenanceOperationViewController alloc] init];
    vc.isJHAComplete = YES;
    vc.item = (SZFinalMaintenanceUnitDetialItem*)self.liftModel;
    vc.svtModel = self.svtModel;
    vc.isFixMode = self.liftModel.isFixMode;
    [self.navigationController pushViewController:vc animated:YES];

    
}
@end
