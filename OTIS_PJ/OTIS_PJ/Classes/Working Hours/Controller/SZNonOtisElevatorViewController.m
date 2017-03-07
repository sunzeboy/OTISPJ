//
//  SZNonOtisElevatorViewController.m
//  OTIS_PJ
//  非在保电梯
//  Created by zhangyang on 16/5/10.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZNonOtisElevatorViewController.h"
#import "SZInputWorkingHourViewController.h"
#import "SZNavigationController.h"
#import "CustomIOSAlertView.h"

#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*]^|£€{ }\\[()_'•+=-;`~<>?/.,:¥\""
@interface SZNonOtisElevatorViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UITextField *kehuxinxi;
@property (weak, nonatomic) IBOutlet UITextField *hetongbianhao;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)okAct:(UIButton *)sender;

@end

@implementation SZNonOtisElevatorViewController
- (BOOL)shouldAutorotate{
    
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.view.superview.backgroundColor = [UIColor blueColor];
    [self initToolBar];
    self.navigationController.toolbarHidden = YES;
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.view.frame = frame;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)textChange{

    self.confirmBtn.enabled=(_kehuxinxi.text.length!=0&&_hetongbianhao.text.length!=0)? YES:NO;
    if (_kehuxinxi.text.length>=20) {
        _kehuxinxi.text=[_kehuxinxi.text substringToIndex:20];
    }
    
    if (_hetongbianhao.text.length>=8) {
        _hetongbianhao.text=[_hetongbianhao.text substringToIndex:8];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 */-(void)initToolBar{
     
     //self.navigationController.toolbarHidden = NO;
     
     UIBarButtonItem *flexble = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
     
     UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"查找框内图标"] landscapeImagePhone:[UIImage imageNamed:@"查找框内图标"] style:UIBarButtonItemStylePlain target:self action:@selector(search)];
     
     UIBarButtonItem *unitRegcode = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"扫一扫"] landscapeImagePhone:[UIImage imageNamed:@"扫一扫"] style:UIBarButtonItemStylePlain target:self action:@selector(unitRegcode)];
     
     self.toolbarItems = [NSArray arrayWithObjects:unitRegcode,search, flexble,flexble,nil];
 }

-(void)search{

}

-(void)unitRegcode{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *) textField {
    if (textField == _kehuxinxi) {
        return [ _hetongbianhao becomeFirstResponder];
    } else {
        return [_hetongbianhao resignFirstResponder];
    }
}
- (IBAction)okAct:(UIButton *)sender {

    // 判断客户信息是否为空
    if ([self.kehuxinxi.text isEqualToString:@""]) {
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.fillWorkingHour")
                                                                                     dialogContents:SZLocal(@"dialog.content.notFilledUserInfo")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            [alertView close];
        };
        [alertView show];
        return;
    }
    // 客户信息长度超过10个汉字，请重新输入！
    if (self.kehuxinxi.text.length > 10) {
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.fillWorkingHour")
                                                                                     dialogContents:SZLocal(@"dialog.content.userInfoMoreThan10")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            [alertView close];
        };
        [alertView show];
        return;
    }
    // 判断合同编号是否为空
    if ([self.hetongbianhao.text isEqualToString:@""]) {
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.fillWorkingHour")
                                                                                     dialogContents:SZLocal(@"dialog.content.notFilledContractNo")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            [alertView close];
        };
        [alertView show];
        return;
    }
    
    SZNavigationController *nav = (SZNavigationController*)self.navigationController;
    nav.laborProperty = 4;
    nav.popVc = [self.navigationController.viewControllers objectAtIndex:1];
    SZInputWorkingHourViewController *vc = [[SZInputWorkingHourViewController alloc] init];
    vc.contant_NO = self.hetongbianhao.text;
    vc.CustomerName = self.kehuxinxi.text;
    vc.inWarranty = NO;
    vc.feizaibao = YES;
//    vc.scheduleID = (int)self.item.ScheduleID;
    //            vc.item = self.item;
    [self.navigationController pushViewController:vc animated:YES];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    SZLog(@"%@",string);

    if (textField==_hetongbianhao) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }else{
        return YES;
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
