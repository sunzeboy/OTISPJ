//
//  SZCustomerSignViewController.m
//  OTIS_PJ
//
//  Created by jQ on 16/5/6.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZCustomerSignViewController.h"
#import "SZSign.h"
#import "SZFinalMaintenanceUnitItem.h"
#import "SZSignDetailBottomOperationView.h"
#import "SZTable_Signature.h"
#import "SZTable_Schedules.h"
#import "SignViewController.h"
#import "CustomIOSAlertView.h"
#import "NSDate+Extention.h"
#import "UIImage+Extention.h"
#import "MBProgressHUD.h"
#import "MaintenanceViewController.h"

@interface SZCustomerSignViewController ()
@property (strong,nonatomic)SZCustomerSignView *detailView;
@property (strong,nonatomic)SZCustomerSignDetail *signDetail;
@property(nonatomic,strong) NSArray * rowArray;

@property (nonatomic , copy) NSString  *fileName;

@property (nonatomic , strong)  SZSignDetailBottomOperationView *operationView;

@property (nonatomic , assign) NSInteger pingjia1;
@property (nonatomic , assign) NSInteger pingjia2;

@property (nonatomic , copy) NSString  *signatureName;

@end

@implementation SZCustomerSignViewController

-(BOOL)shouldAutorotate{
    return NO;
}
//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

// 支持屏幕旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return NO;
}
// 画面一开始加载时就是竖向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}



-(NSString *)signatureName{
    if (_signatureName == nil) {
        _signatureName = [NSString stringWithFormat:@"Signature%@%@.jpg",self.item.UnitNo,[NSDate currentTimeNOMaohao]];
    }
    return _signatureName;
}

-(void)createDirectory{
    
    [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/signature", kCurrentCache] withIntermediateDirectories:NO attributes:nil error:nil];
}


-(NSString *)fileName{
    if (_fileName == nil) {
        _fileName = [NSString stringWithFormat:@"sign%@_%ld",[OTISConfig EmployeeID],self.item.ScheduleID];
    }
    return _fileName;
}

-(SZSignDetailBottomOperationView *)operationView{
    
    if(_operationView ==nil){
        _operationView =[SZSignDetailBottomOperationView loadSZSignDetailBottomOperationView];
        
        _operationView.frame = CGRectMake(0,SCREEN_HEIGHT-OTIS_BottomOperationH, SCREEN_WIDTH, OTIS_BottomOperationH);
        [self.view addSubview:_operationView];
    }
    return _operationView;
    
}
- (instancetype)initWithNSArray:(NSArray *)array{
    if(self = [super init]){
        _rowArray = array;
    }
//    SZLog(@"count:%lu",(unsigned long)self.rowArray.count);
    return self;
}
//设置数据（from plist）
-(SZCustomerSignDetail *)signDetail
{
    if(_signDetail ==nil){
        self.signDetail =[SZCustomerSignDetail signDetail];
    }
    return _signDetail;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createDirectory];
    [self setNavItem];
    [self setUpDetailView];
    self.title = SZLocal(@"title.signViewController");
    [self setSubTitleWithName];
    [self createDirectory];

    
}


-(void)setNavItem{
    UIButton* backBtn=[[UIButton alloc] init];
    backBtn.bounds=CGRectMake(0, 0, 50, 30);
    backBtn.imageEdgeInsets=UIEdgeInsetsMake(0, -10, 0, 0);
    backBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitle:SZLocal(@"btn.title.back") forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

-(void)back{

    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                 dialogContents:SZLocal(@"dialog.content.Whether to return to the elevator information screen, fill in the signature information will not be saved?")
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        if(buttonIndex == 0){
            [self.navigationController popViewControllerAnimated:YES];
            [alertView close];
        }else if(buttonIndex == 1){
            [alertView close];
        }
    };
    [self.view endEditing:YES];
    [alertView show];
}


-(void)setUpDetailView
{
    _detailView = [SZCustomerSignView loadSZCustomerSignView];
    //数据设置给View
    _detailView.signDetail = self.signDetail;
    _detailView.backgroundColor = [UIColor whiteColor];
    _detailView.frame =CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT);
    //设置代理
    _detailView.delegate =self;

    [self.view addSubview:_detailView];
    WEAKSELF
    _detailView.evaluateTypeBlock = ^(NSInteger evaluateType,int type){
        if (type == 1) {
            weakSelf.pingjia1 = evaluateType;
        }else{
            weakSelf.pingjia2 = evaluateType;
        }
    };
    
    _detailView.confirmActBlock = ^(UIButton *btn){
        if ([btn.titleLabel.text isEqualToString:SZLocal(@"btn.title.save")]) {
            [weakSelf saveBtnClick];
        }else{
            [weakSelf toSignatureBoard];
        }
    };
}

// 设置副标题
- (void) setSubTitleWithName{
    UIView *subTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 80)];
    subTitleView.backgroundColor = [UIColor colorWithRed:3.0f/255.0f green:96.0f/255.0f blue:169.0f/255.0f alpha:1.0f];
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 16, SCREEN_WIDTH, 20)];
    UILabel *subTitleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 46, SCREEN_WIDTH, 20)];
    
    SZFinalMaintenanceUnitItem *szModel = self.rowArray[0];
    NSString * laber1;
    NSString * laber2 = [NSString stringWithFormat:@"%@:",SZLocal(@"dialog.title.Site name")];
    laber1 = [laber2 stringByAppendingString:szModel.BuildingName];

    subTitleLabel.text =laber1;
    subTitleLabel.textColor = [UIColor whiteColor];
    subTitleLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:14];


    NSString * laber3;
    NSString * laber4=[NSString stringWithFormat:@"%@:",SZLocal(@"dialog.title.Lift units")];
    laber3 = [laber4 stringByAppendingString:[NSString stringWithFormat: @"%lu", (unsigned long)self.rowArray.count]];
    subTitleLabel1.text =[laber3 stringByAppendingString:[NSString stringWithFormat:@" %@",SZLocal(@"dialog.title.Platform")]];
    subTitleLabel1.textColor = [UIColor whiteColor];
    subTitleLabel1.font = [UIFont fontWithName:@"MicrosoftYaHei" size:14];

    //
    [subTitleView addSubview:subTitleLabel];
    [subTitleView addSubview:subTitleLabel1];
    [self.view addSubview:subTitleView];
}

//保存按钮
- (void)saveBtnClick{
    if([self saveCheckItems]){
        
        
        [SZTable_Signature storageWithAttitude:(int)self.pingjia1 quality:(int)self.pingjia2 signComment:
         self.signComment isAbsent:self.detailView.customerAbsence.selected customer:self.detailView.customerName.text signature:self.signatureName isEmail:self.detailView.sendEmail.selected emailAddr:self.detailView.emailAddress.text isImageUploaded:NO andScheduleIDs:(NSArray *)self.signArray];
      
        //返回未签字列表
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[MaintenanceViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    
        
    }
}

//保存关联check
- (BOOL)saveCheckItems{
    BOOL flg = true;
    
    if(self.detailView.customerAbsence.selected){
        return true;
    }else{
        
        if(!(self.detailView.saSatisfied.selected || self.detailView.saVerySatisfied.selected || self.detailView.saUnsatisfied.selected)){
            [self alertShow: SZLocal(@"dialog.content.attitudeInput")];
            flg = false;
            return flg;
        }else if(!(self.detailView.mqVerySatisfied.selected || self.detailView.mqSatisfied.selected || self.detailView.mqUnsatisfied.selected)){
            [self alertShow: SZLocal(@"dialog.content.maintenanceQualityInput")];
            flg = false;
            return flg;
        }else if(self.detailView.customerName.text.length ==0){
            [self alertShow: SZLocal(@"dialog.content.customerNameInput")];
            flg = false;
            return flg;
        }else if(self.detailView.sendEmail.selected){
            if(![self isValidateEmail:self.detailView.emailAddress.text]){
                [self alertShow: SZLocal(@"dialog.content.emailAddressCorrect")];
                flg = false;
                return flg;
            }
        }
        if(self.signDetail.signatureImage == nil){
            [self alertShow: SZLocal(@"dialog.content.customerSign")];
            flg = false;
            return flg;
        }
    }
    return flg;
}

-(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(void)alertShow:(NSString *)connents{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                 dialogContents:connents
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        [alertView close];
    };
    [alertView show];
}

//保存图片
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
//    UIImage *imageScale = [UIImage scaleImage:tempImage withNewSize:CGSizeMake(358, 170)];
    NSData* imageData = UIImageJPEGRepresentation(tempImage, 1);

    //图片数据保存到 document
    BOOL ret=[imageData writeToFile:[kSignature stringByAppendingPathComponent:imageName] atomically:NO];
    if (ret) {
//        SZLog(@"GOOD!");
    }else{
        SZLog(@"保存图片失败!");
    }
}

//代理方法1
- (void) toSignatureBoard{
    if(!_detailView.customerAbsence.selected){
        SZSignatureBoardViewController *controller = [[SZSignatureBoardViewController alloc]init];
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

//代理方法2
-(void) sendSignatureImage:(UIImage *)image{
    self.signDetail.signatureImage = image;
    _detailView.signDetail = self.signDetail;
    [self saveImage:image WithName:self.signatureName];

//    [self alertShow2:SZLocal(@"dialog.content.signatureSaved")];
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = SZLocal(@"dialog.content.signatureSaved");
    [hud hide:YES afterDelay:1];
    [self.view setNeedsDisplay];
}



@end
