//
//  SZMaintainDetailViewController.m
//  OTIS_PJ
//
//  Created by zy on 16/5/4.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZMaintainDetailViewController.h"
#import "SZJobHazardAnalysisViewController.h"
#import "SZCarTopViewController.h"
#import "SZPitViewController.h"
#import "SZModuleQueryTool.h"
#import "SZFinalMaintenanceUnitDetialItem.h"
#import "SZJobHazardAnalysisViewController.h"
#import "SZPreviewViewController.h"
#import <INTULocationManager/INTULocationManager.h>
#import "UIBarButtonItem+Extention.h"
#import "SZBottomSaveOperationView.h"
#import "SZInputWorkingHourViewController.h"
#import "NSDate+Extention.h"
#import "CustomIOSAlertView.h"
#import "SZTable_Report.h"
#import "SZTable_QRCode.h"

@interface SZMaintainDetailViewController ()<UITabBarDelegate>


@property (weak, nonatomic) IBOutlet UILabel *unitNo;

@property (weak, nonatomic) IBOutlet UILabel *baoyang;

@property (weak, nonatomic) IBOutlet UILabel *checkDate;
@property (weak, nonatomic) IBOutlet UILabel *jihuariqi;

@property (weak, nonatomic) IBOutlet UILabel *times;

@property (weak, nonatomic) IBOutlet UIImageView *cardType;

@property (weak, nonatomic) IBOutlet UILabel *unCompleteCount;

@property (weak, nonatomic) IBOutlet UILabel *modelType;

@property (weak, nonatomic) IBOutlet UILabel *route;

@property (weak, nonatomic) IBOutlet UILabel *buildingName;

@property (weak, nonatomic) IBOutlet UILabel *buildingAddress;

@property (weak, nonatomic) IBOutlet UILabel *Owner;

@property (weak, nonatomic) IBOutlet UILabel *Tel;

@property (weak, nonatomic) IBOutlet UILabel *unitRegcode;

@property (weak, nonatomic) IBOutlet UILabel *longitude;

@property (weak, nonatomic) IBOutlet UILabel *latitude;

@property (nonatomic , strong) SZFinalMaintenanceUnitDetialItem *item;

@property (nonatomic,strong) NSString *barcodeType;

@property (weak, nonatomic) IBOutlet UILabel *currentLocationLabel;

@property (weak, nonatomic) IBOutlet UIButton *weibao;
@property (weak, nonatomic) IBOutlet UIButton *gongshi;
@property (weak, nonatomic) IBOutlet UIButton *yulan;

@property (nonatomic , assign) BOOL isLight;
@property (weak, nonatomic) IBOutlet UILabel *unitName;

@end

@implementation SZMaintainDetailViewController

-(void)awakeFromNib{
    [super awakeFromNib];
    
}

- (BOOL)shouldAutorotate{
    
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentLocationLabel.font = [UIFont systemFontOfSize:11];
    [_Tel sizeToFit];
    [_longitude sizeToFit];
    [_latitude sizeToFit];
    self.checkDate.hidden = self.isWorkingHours;
    self.baoyang.hidden = self.isWorkingHours;
    self.jihuariqi.hidden = self.isWorkingHours;
    self.unCompleteCount.hidden = self.isWorkingHours;
    self.times.hidden = self.isWorkingHours;
    self.weibao.hidden = self.isWorkingHours;
    self.yulan.hidden = self.isWorkingHours;
    
    
    // 维保进入-判断工时按钮是否是亮的
    self.isLight = [SZModuleQueryTool isCompleatedAndUpload:self.item];
    
    if (self.isLight) {
        self.weibao.userInteractionEnabled  = NO;
        [self.weibao setImage:[UIImage imageNamed:@"btn_weibao_gray"] forState:0];
    }
    // 从工时进入方式
    if (self.isWorkingHours) {
        [self.gongshi setTitle:SZLocal(@"btn.title.confirm") forState:0];
        [self.gongshi setImage:[UIImage imageNamed:@"btn_confirm"] forState:0];
        [self.view setNeedsDisplay];
    }
    if (self.isFixMode) {
        self.jihuariqi.hidden =NO;
        self.unCompleteCount.hidden = NO;
        self.times.hidden = NO;
        self.checkDate.hidden = NO;

        self.baoyang.hidden = NO;
        self.weibao.hidden = self.isFixMode;
        self.yulan.hidden = self.isFixMode;

    }
}

-(void)viewWillAppear:(BOOL)animated{

    self.item.isFixMode = self.isFixMode;
    self.navigationController.toolbarHidden = YES;
    
    NSString*lat=[[NSUserDefaults standardUserDefaults] objectForKey:@"userLastLocationLat"];
    NSString*lon=[[NSUserDefaults standardUserDefaults] objectForKey:@"userLastLocationLon"];

    self.item.StartTime = [NSDate sinceDistantPastTime];

    self.currentLocationLabel.text=[NSString stringWithFormat:SZLocal(@"dialog.content.locationing")];
    self.weibao.enabled=NO;
    self.gongshi.enabled=NO;
    self.yulan.enabled=NO;
    if (self.isFixMode) {
        [self.gongshi setImage:[UIImage imageNamed:@"btn_confirm_gray"] forState:UIControlStateDisabled];
        [self.gongshi setTitle:@"维保" forState:UIControlStateDisabled];
    }
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    WEAKSELF;
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyRoom
                timeout:2.0
                delayUntilAuthorized:YES  // This parameter is optional, defaults to NO if omitted
                block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                     if (status == INTULocationStatusSuccess) {
                         // Request succeeded, meaning achievedAccuracy is at least the requested accuracy, and
                         // currentLocation contains the device's current location.

                         NSNumber *numlongitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
                         NSNumber *numlatitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];

                         weakSelf.latitude.text = [NSString stringWithFormat:@"%@:%@",SZLocal(@"dialog.content.longitude"),[numlatitude stringValue]];
                         weakSelf.longitude.text = [NSString stringWithFormat:@"%@:%@",SZLocal(@"dialog.content.latitude"),[numlongitude stringValue]];
                         
                         weakSelf.item.StartLocalX = [numlongitude stringValue];
                         weakSelf.item.StartLocalY = [numlatitude stringValue];
                         self.currentLocationLabel.text=SZLocal(@"dialog.content.Success of the current position coordinates");
                         [[NSUserDefaults standardUserDefaults] setObject:weakSelf.item.StartLocalX forKey:@"userLastLocationLat"];
                         [[NSUserDefaults standardUserDefaults] setObject:weakSelf.item.StartLocalY forKey:@"userLastLocationLon"];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         self.weibao.enabled=YES;
                         self.gongshi.enabled=YES;
                         self.yulan.enabled=YES;
                     }
                     else if (status == INTULocationStatusTimedOut) {
//                         self.currentLocationLabel.text=SZLocal(@"dialog.content.Gets the GPS position over 10s, using the last acquired location");
                         self.currentLocationLabel.text=SZLocal(@"dialog.content.Success of the current position coordinates");
                         if (lat!=nil&&lon!=nil) {
                             weakSelf.latitude.text = [NSString stringWithFormat:@"%@:%@",SZLocal(@"dialog.content.latitude"),lat];
                             weakSelf.longitude.text = [NSString stringWithFormat:@"%@:%@",SZLocal(@"dialog.content.longitude"),lon];
                             self.weibao.enabled=YES;
                             self.gongshi.enabled=YES;
                             self.yulan.enabled=YES;
                             weakSelf.item.StartLocalX = lon;
                             weakSelf.item.StartLocalY = lat;
                         }else{
                             self.currentLocationLabel.text=[NSString stringWithFormat:SZLocal(@"dialog.content.Failed to obtain location")];
                             weakSelf.latitude.text=[NSString stringWithFormat:@"%@:0",SZLocal(@"dialog.content.latitude")];
                             weakSelf.longitude.text=[NSString stringWithFormat:@"%@:0",SZLocal(@"dialog.content.longitude")];
                             self.weibao.enabled=YES;
                             self.gongshi.enabled=YES;
                             self.yulan.enabled=YES;
                         }
                     } else if (status == INTULocationStatusServicesDenied) {
                         if (lat!=nil&&lon!=nil) {
                             self.currentLocationLabel.text=[NSString stringWithFormat:SZLocal(@"dialog.content.Failed to obtain position, using the last time to obtain the location.")];
                             weakSelf.latitude.text = [NSString stringWithFormat:@"%@:%@",SZLocal(@"dialog.content.latitude"),lat];
                             weakSelf.longitude.text = [NSString stringWithFormat:@"%@:%@",SZLocal(@"dialog.content.longitude"),lon];
                             weakSelf.item.StartLocalX = lon ;
                             weakSelf.item.StartLocalY = lat ;
                             self.weibao.enabled=YES;
                             self.gongshi.enabled=YES;
                             self.yulan.enabled=YES;
                         }else{
                             self.currentLocationLabel.text=[NSString stringWithFormat:SZLocal(@"dialog.content.Please check whether the GPS is turned on.")];
                             weakSelf.latitude.text=[NSString stringWithFormat:@"%@:0",SZLocal(@"dialog.content.latitude")];
                             weakSelf.longitude.text=[NSString stringWithFormat:@"%@:0",SZLocal(@"dialog.content.longitude")];
                             self.weibao.enabled=YES;
                             self.gongshi.enabled=YES;
                             self.yulan.enabled=YES;
                         }
                     }
                     else {
                         self.currentLocationLabel.text=SZLocal(@"dialog.content.Gets the GPS position over 10s, using the last acquired location");
                         if (lat!=nil&&lon!=nil) {
                             weakSelf.latitude.text = [NSString stringWithFormat:@"%@:%@",SZLocal(@"dialog.content.latitude"),lat];
                             weakSelf.longitude.text = [NSString stringWithFormat:@"%@:%@",SZLocal(@"dialog.content.longitude"),lon];
                             weakSelf.item.StartLocalX = lon ;
                             weakSelf.item.StartLocalY = lat ;
                             self.weibao.enabled=YES;
                             self.gongshi.enabled=YES;
                             self.yulan.enabled=YES;
                         }else{
                             self.currentLocationLabel.text=[NSString stringWithFormat:SZLocal(@"dialog.content.Please check whether the GPS is turned on.")];
                             weakSelf.latitude.text=[NSString stringWithFormat:@"%@:0",SZLocal(@"dialog.content.latitude")];
                             weakSelf.longitude.text=[NSString stringWithFormat:@"%@:0",SZLocal(@"dialog.content.longitude")];
                             self.weibao.enabled=YES;
                             self.gongshi.enabled=YES;
                             self.yulan.enabled=YES;
                         }
                     }
                 }];

    NSInteger all = 0;
    NSInteger  competed=0;
    all= [SZModuleQueryTool queryAllMaintenanceWithUnitDetialItem:self.item];
    competed = [SZModuleQueryTool queryCompletedMaintenanceWithUnitDetialItem:self.item];

    NSMutableAttributedString *text0 = [[NSMutableAttributedString alloc] initWithString:SZLocal(@"title.Incomplete item")];
    NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat: @"%d", (int)(all-competed)]];
    [text1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, text1.length)];
    [text0 insertAttributedString:text1 atIndex:3];
    self.unCompleteCount.attributedText = text0;
}


-(SZFinalMaintenanceUnitDetialItem *)item{

    if (_item ==nil) {
        if (self.scheduleID) {
            _item = [SZModuleQueryTool queryDetialMaintenanceWithScheduleID:self.scheduleID];
            _item.ScheduleID = self.scheduleID;
            self.unitNostr = _item.UnitNo;
        }else{
            _item = [SZModuleQueryTool queryGongshiDetialMaintenanceWithUnitNo:self.unitNostr];
        }
        
        [self setUp];
    }
    return _item;
}


-(void)setUp{
    self.unitName.text = self.item.UnitName;
    self.item.isFixMode =self.isFixMode;
    self.unitNo.text = self.unitNostr;
    self.checkDate.text = self.item.CheckDateStr;
    self.times.text = self.item.TimesStr;
    if (self.item.CardType == -1) {
        self.cardType.image = [UIImage imageNamed:@"lht_default"];
    }else{
        self.cardType.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.item.CardTypeStr]];
    }

    self.modelType.text = self.item.ModelType;
    self.route.text = self.item.Route;
    self.buildingName.text = [NSString stringWithFormat:@"%@:%@",SZLocal(@"dialog.title.Site"),self.item.BuildingName];
    self.buildingAddress.text = [NSString stringWithFormat:@"%@:%@",SZLocal(@"dialog.title.Address"),self.item.BuildingAddr];
    self.Owner.text = [NSString stringWithFormat:@"%@:%@",SZLocal(@"dialog.title.Telephone person in charge"),self.item.Owner];
    if ([self.item.Tel isEqualToString:@""]||self.item.Tel==nil) {
        self.Tel.text =[NSString stringWithFormat:@"%@:%@",SZLocal(@"dialog.title.Phone"),SZLocal(@"No")];
    }else{
        self.Tel.text =[NSString stringWithFormat:@"%@:%@",SZLocal(@"dialog.title.Phone"),self.item.Tel];
    }
    
    if (_barcodeType) {
        [USER_DEFAULT setObject:_barcodeType forKey:self.item.UnitNo];
    }
    
    self.unitRegcode.text = _barcodeType;
    if (self.rCode) {
        self.unitRegcode.text = self.rCode;
        [USER_DEFAULT setObject:self.rCode forKey:self.item.UnitNo];
    }
    
    // 直接进入的情况，没有扫描二维码，此时去QRcode表中获取结果；因为此时一定是扫过的
    if(self.isDirectEntry){
        self.unitRegcode.text = [USER_DEFAULT objectForKey:self.item.UnitNo];
    }
    
    if ([self.unitRegcode.text isEqualToString:SZLocal(@"dialog.content.noBarcode")]) {
        self.item.Reason = 1;
    }else if ([self.unitRegcode.text isEqualToString:SZLocal(@"dialog.content.canNotIdentify")]){
        self.item.Reason = 5;
    }else{
        self.item.Reason = 0;
    }
    self.item.QRCode = self.unitRegcode.text;
    
   
    
}


-(void) tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag == 100) {//保养预览
        
    }else{
        SZJobHazardAnalysisViewController *machineRoomController = [[SZJobHazardAnalysisViewController alloc] init];
        machineRoomController.item = self.item;
        [self.navigationController pushViewController:machineRoomController animated:YES];
    }
}
- (IBAction)btnMaintainClick:(id)sender {
    SZJobHazardAnalysisViewController *controller = [[SZJobHazardAnalysisViewController alloc] init];
    controller.isCheckItem = YES;
    self.item.isFixMode = self.isFixMode;
    controller.item = self.item;
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)btnWorkingHoursClick:(id)sender {
    if (self.isFixMode) {
        SZJobHazardAnalysisViewController *controller = [[SZJobHazardAnalysisViewController alloc] init];
        controller.IsFixItem = YES;
        self.item.isFixMode = YES;
        controller.item = self.item;
        controller.isCheckItem = YES;
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    
    if (self.isWorkingHours) {
        if (self.isfentan) {
            self.item.Reason = 6;
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self confirmBarcodeIsRight];
        }
    }else{
        SZJobHazardAnalysisViewController *controller = [[SZJobHazardAnalysisViewController alloc] init];
        self.item.isFixMode = self.isFixMode;
        controller.isCheckItem = NO;
        controller.item = self.item;

        // 只有灰色，才进入这个流程，正常维保进入的时候，就走维保数据就对了
        // 从维保进入的话，没有设置这个变量，默认是0
        if (self.isLight) {
            controller.inputMode = 2;
        }else {
            controller.inputMode = 1;
        }
        
        [self.navigationController pushViewController:controller animated:YES];
    }
}
- (IBAction)btnPreviewClick:(id)sender {
    SZPreviewViewController *machineRoomController = [[SZPreviewViewController alloc] init];
    machineRoomController.item = self.item;
    [self.navigationController pushViewController:machineRoomController animated:YES];
}

- (instancetype)initWithBarcodeType:(NSString *)barcodeType{
    
    if(self = [super init]){
        _barcodeType = barcodeType;
    }
    return self;
}

-(void) confirmBarcodeIsRight {
    WEAKSELF
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                 dialogContents:SZLocal(@"dialog.content.confirmBarcodeIsRight")
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        if(buttonIndex == 0){
            
            SZInputWorkingHourViewController *vc = [[SZInputWorkingHourViewController alloc] init];
            vc.scheduleID = (int)weakSelf.item.ScheduleID?(int)weakSelf.item.ScheduleID:-1;
            vc.isWorkhour = YES;
            vc.item = weakSelf.item;
            vc.unitNo = weakSelf.item.UnitNo;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        [alertView close];
    };
    [alertView show];
    
}

@end
