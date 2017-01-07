//
//  SZSuperUserViewController.m
//  OTIS_PJ
//
//  Created by sunze on 16/8/17.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZSuperUserViewController.h"
#import "XHDropBoxView.h"

@interface SZSuperUserViewController ()<XHDropBoxDelegate>
@property (strong,nonatomic) XHDropBoxView *xhbox;

@property (strong,nonatomic) UILabel *detialLabel;

@end

@implementation SZSuperUserViewController
- (BOOL)shouldAutorotate{
    
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    self.xhbox = [[XHDropBoxView alloc]init];
    /*第一个参数设置：frame.origin.x 第二个参数：frame.origin.y  第三个参数：textfield宽度 第四个参数：textfield高度  第五个参数：button宽度
     第六个参数：tableview的高度 第七个参数：设置是否能够编辑 yes能编辑  no不能编辑
     默认button高度和textfiled高度一样
     默认tableview宽度为textfield和button的宽度只和*/
    [self.xhbox setControlsViewOriginx:2 ViewOriginy:200 TextWidth:SCREEN_WIDTH-30 TextAndButtonHigth:40 ButtonWidth:40 TableHigth:100 Editortype:YES];
    self.xhbox.textfiled.placeholder = @"请输入或选择服务器地址";
    self.xhbox.delegate =self;
    self.xhbox.tag = 1000;

    NSArray *arr = @[@"http://ochcsprdweb.cloudapp.net:22281/",@"http://ochcsprdweb.cloudapp.net/MobileTest/",@"http://192.168.30.84:22282/"];
    NSArray *arr2 = @[@"云服务",@"云测试-技师勿设",@"畅星测试-技师勿设"];
    NSInteger index = [arr indexOfObject:SZOuterNetwork];
    
    self.xhbox.textfiled.text = arr2[index];
    
    
    
    self.xhbox.arr = arr2;
    [self.view addSubview:self.xhbox];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"0079FF"]];
    [btn setTitle:@"确定" forState:0];
    [btn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(15, 350, SCREEN_WIDTH/2-30, 40);
    btn.layer.cornerRadius = 5;
    
    [self.view addSubview:btn];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setBackgroundColor:[UIColor darkGrayColor]];
    [btn2 setTitle:@"取消" forState:0];
    [btn2 addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    btn2.frame = CGRectMake(CGRectGetMaxX(btn.frame)+20, 350, SCREEN_WIDTH/2-30, 40);
    btn2.layer.cornerRadius = 5;
    
    [self.view addSubview:btn2];
    
    self.detialLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, CGRectGetMidY(self.xhbox.frame)-45, 100, 30)];
    self.detialLabel.textColor = [UIColor lightGrayColor];
    self.detialLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:self.detialLabel];
}

-(void)selectAtIndex:(int)index WithXHDrooBox:(XHDropBoxView *)dropbox
{
    NSLog(@"row==%d",index);
//    NSArray *arr = @[@"http://ochcsprdweb.cloudapp.net:22281/",@"http://ochcsprdweb.cloudapp.net/MobileTest/",@"http://192.168.30.84:22282/"];云服务、云测试-技师勿设、畅星测试-技师勿设
    NSArray *arr2 = @[@"云服务",@"云测试-技师勿设",@"畅星测试-技师勿设"];
    switch (index) {
        case 0:

            SZOuterNetwork = @"http://ochcsprdweb.cloudapp.net:22281/";
            SZNetwork = @"http://ochcsprdweb.cloudapp.net:22281/";

            break;
        case 1:

            SZOuterNetwork = @"http://ochcsprdweb.cloudapp.net/MobileTest/";
            SZNetwork = @"http://ochcsprdweb.cloudapp.net/MobileTest/";


            break;
        case 2:

            SZOuterNetwork = @"http://192.168.30.84:22282/";
            SZNetwork = @"http://192.168.30.84:22282/";

            break;
            
        default:
            break;
    }


    self.detialLabel.text = arr2[index];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    XHDropBoxView *box = (XHDropBoxView *)[self.view viewWithTag:1000];
    [box closeTableview];
    [self.view endEditing:YES];
}

-(void)confirm{
     [USER_DEFAULT setObject:SZOuterNetwork forKey:@"SZOuterNetwork"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dismiss{
    
    SZOuterNetwork = [USER_DEFAULT objectForKey:@"SZOuterNetwork"];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
