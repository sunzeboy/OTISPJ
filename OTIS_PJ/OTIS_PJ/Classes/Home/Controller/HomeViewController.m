//
//  HomeViewController.m
//  otis__PJ
//
//  Created by sunze on 16/4/20.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "HomeViewController.h"
#import "SZNavigationController.h"
#import "MaintenanceViewController.h"
#import "WorkingHoursViewController.h"
#import "SignViewController.h"
#import "SZAnnualInspectionViewController.h"
#import "SZHelpTableViewController.h"
#import "SZTable_JHA_TYPE.h"
#import "SZButton.h"
#import "SZUploadManger.h"
#import "CustomIOSAlertView.h"
#import "AppDelegate.h"
#import <AFNetworking.h>
#import "SZDownloadManger.h"
#import "SZHttpTool.h"
#import "MBProgressHUD.h"
#import "SZTipVIew.h"
#import <INTULocationManager/INTULocationManager.h>
#import "SZClearLocalDataTool.h"

@interface HomeViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *myHeadPortrait;

@property (weak, nonatomic) IBOutlet UILabel *empLabel;


@property (weak, nonatomic) IBOutlet SZButton *weibao;
@property (weak, nonatomic) IBOutlet SZButton *qianzi;
@property (weak, nonatomic) IBOutlet SZButton *gongshi;
@property (weak, nonatomic) IBOutlet SZButton *tongbu;
@property (weak, nonatomic) IBOutlet SZButton *nianjian;
@property (weak, nonatomic) IBOutlet SZButton *bangzhu;

@property (weak, nonatomic) IBOutlet UIImageView *beltLevelIView;

@property (nonatomic , copy) NSString  *fileName;


@end

@implementation HomeViewController

- (BOOL)shouldAutorotate{
    
    return NO;
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(void)createDirectory{
    
    [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/headImage", kCurrentCache] withIntermediateDirectories:NO attributes:nil error:nil];
}

-(NSString *)fileName{
    if (_fileName == nil) {
        _fileName = [NSString stringWithFormat:@"%@_HeadImage",[OTISConfig EmployeeID]];
    }
    return _fileName;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

    self.navigationController.toolbarHidden = YES;
    ((SZNavigationController *)self.navigationController).laborProperty = 0;
    
}


-(void)setUpSZButton{
    self.weibao.iconImage.image = [UIImage imageNamed:@"menu_weibao"];
    self.qianzi.iconImage.image = [UIImage imageNamed:@"menu_qianzi"];
    self.gongshi.iconImage.image = [UIImage imageNamed:@"menu_gongshi"];
    self.tongbu.iconImage.image = [UIImage imageNamed:@"menu_tongbu"];
    self.nianjian.iconImage.image = [UIImage imageNamed:@"menu_nianjian"];
    self.bangzhu.iconImage.image = [UIImage imageNamed:@"menu_bangzhu"];
    
    self.weibao.titleLabel.text = SZLocal(@"title.MaintenanceViewController");
    self.qianzi.titleLabel.text = SZLocal(@"title.SignatureBoardViewController");
    self.gongshi.titleLabel.text = SZLocal(@"title.gongshi");
    self.tongbu.titleLabel.text = SZLocal(@"title.tongbu");
    self.nianjian.titleLabel.text = SZLocal(@"title.nianjian");
    self.bangzhu.titleLabel.text = SZLocal(@"title.helpMenu");
    
    self.nianjian.badge.hidden = NO;
    
    WEAKSELF;
    self.weibao.btnClickBlock = ^(UIButton *btn){
        [weakSelf weibaoAct:btn];
    };
    self.qianzi.btnClickBlock = ^(UIButton *btn){
        [weakSelf qianziAct:btn];
    };
    self.gongshi.btnClickBlock = ^(UIButton *btn){
        [weakSelf gongshiAct:btn];
    };
    self.tongbu.btnClickBlock = ^(UIButton *btn){
        [weakSelf syDataAct:btn];
    };
    self.nianjian.btnClickBlock = ^(UIButton *btn){
        [weakSelf yearCheckAct:btn];
    };
    self.bangzhu.btnClickBlock = ^(UIButton *btn){
        [weakSelf helpAct:btn];
    };
    
    [self showHeadImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:SZNotificationUpdateBadgeViewCount object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noNetworkTip) name:SZNotificationNoNetwork object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadFaild) name:SZNotificationUploadFailed object:nil];
    
    [self locationChanged];


    [self createDirectory];
    [self setUpSZButton];
    self.empLabel.text = [OTISConfig username];
    UIImageView *iView = [[UIImageView alloc] initWithImage:ImageNamed(@"OETitle")];
    iView.frame = CGRectMake(0, 0, 40, 30);
    self.navigationItem.titleView = iView;

    AppDelegate *appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appD.nav = (SZNavigationController *)self.navigationController;

    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    NSNumber *num = [USER_DEFAULT objectForKey:OTIS_isNewfeatureVersion];
    if (num.intValue) {
        [SZClearLocalDataTool clearData];
    }
    
    if (self.isLocalLogin == NO) {
        [SZUploadManger startUploadAndDownloadFirstTimeWithView:self.view];
    }else{
        [SZUploadManger localloginWithView:self.view];

    }

    

}

-(void)updateUI{

    AppDelegate *appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.nianjian.badge.text = [NSString stringWithFormat:@"%d",(int)appD.annualInspectionCount];

}


-(void)noNetworkTip{

    [SZUploadManger fauilTipView:self.view];
}

-(void)uploadFaild{

    [SZUploadManger uploadFauilTipView:self.view];
}

#pragma mark - target Action
- (void)weibaoAct:(UIButton *)sender {
    MaintenanceViewController *vc = [[MaintenanceViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)qianziAct:(UIButton *)sender {
    SignViewController *vc =[[SignViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gongshiAct:(UIButton *)sender {
    WorkingHoursViewController *vc = [[WorkingHoursViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)syDataAct:(UIButton *)sender {
    [self reachability];
}
- (void)yearCheckAct:(UIButton *)sender {
    SZAnnualInspectionViewController *vc = [[SZAnnualInspectionViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)helpAct:(UIButton *)sender {
    SZHelpTableViewController *vc = [[SZHelpTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)setHeadPortrait:(UIButton *)sender {
    
    /**
     *  弹出提示框
     */
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:SZLocal(@"btn.title.SelectFromAlbum") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //初始化UIImagePickerController
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
        //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:SZLocal(@"title.Photograph") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        /**
         其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式
         */
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:SZLocal(@"btn.title.cencel") style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];

    [self saveImage:newPhoto WithName:self.fileName];
    [_myHeadPortrait setBackgroundImage:newPhoto forState:0];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showHeadImage{
    UIImage *headImage = [UIImage imageWithContentsOfFile:[kHeadImage stringByAppendingPathComponent:self.fileName]];
    if (headImage) {
        [_myHeadPortrait setBackgroundImage:headImage forState:0];
    }
    
    NSString *beltLevelStr = [USER_DEFAULT objectForKey:OTIS_BeltLevel];
    switch (beltLevelStr.intValue) {
        case 1:
            self.beltLevelIView.image = [UIImage imageNamed:@"blackBelt"];
            break;
        case 2:
            self.beltLevelIView.image = [UIImage imageNamed:@"blueBelt"];
            break;
        case 3:
            self.beltLevelIView.image = [UIImage imageNamed:@"greenBelt"];
            break;
        case 4:
            self.beltLevelIView.image = [UIImage imageNamed:@"redBelt"];
            break;
        case 5:
            self.beltLevelIView.image = [UIImage imageNamed:@"whiteBelt"];
            break;
            
        default:
            break;
    }
    
}

//保存图片
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(tempImage, 0.4);
    
    //图片数据保存到 document
    BOOL ret=[imageData writeToFile:[kHeadImage stringByAppendingPathComponent:imageName] atomically:NO];
    if (ret) {
        
    }else{
        SZLog(@"保存图片失败!");
    }
}

- (void)reachability
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:SZNotificationUploadFailed object:self userInfo:nil];

    [self tongbushuju];

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

-(void)note{

    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                 dialogContents:SZLocal(@"dialog.content.confirmmeiwang")
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        if(buttonIndex == 0){
            [alertView close];
        }else if(buttonIndex == 1){
            [alertView close];
        }
    };
    [alertView show];

}

-(void)locationChanged{
    
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr subscribeToLocationUpdatesWithDesiredAccuracy:INTULocationAccuracyRoom
                                                    block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                                        if (status == INTULocationStatusSuccess) {
                                                            NSString *strLa = [NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:currentLocation.coordinate.latitude]];
                                                            NSString *strLo = [NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:currentLocation.coordinate.longitude]];
//                                                            SZLog(@"我在这呢！！！%@ %@",strLa,strLo);

                                                            [[NSUserDefaults standardUserDefaults] setObject:strLa forKey:@"userLastLocationLat"];
                                                            [[NSUserDefaults standardUserDefaults] setObject:strLo forKey:@"userLastLocationLon"];
                                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                                            
                                                        }
                                                        else {
                                                            
                                                            
                                                        }
                                                    }];
    
    
}


@end
