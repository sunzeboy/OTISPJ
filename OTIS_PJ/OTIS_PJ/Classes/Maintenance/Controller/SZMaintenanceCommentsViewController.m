//
//  SZMaintenanceCommentsViewController.m
//  OTIS_PJ
//
//  Created by zy on 16/5/6.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZMaintenanceCommentsViewController.h"
#import "SZTable_Report.h"
#import "CustomIOSAlertView.h"
@interface SZMaintenanceCommentsViewController ()<UITextViewDelegate>



@end

@implementation SZMaintenanceCommentsViewController
- (BOOL)shouldAutorotate{
    
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setframe];
}


-(void)back{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                 dialogContents:SZLocal(@"dialog.content.changepasswordtip")
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


- (void) setframe {
    
    SZMaintenanceRemarks *remark = [SZTable_Report quaryRemarkWithScheduleID:self.scheadleId];
    
    // Checkbox图片
    UIImage* checkOffImage = [UIImage imageNamed:@"check_off.png"];
    UIImage* checkOnImage = [UIImage imageNamed:@"check_on.png"];

    //需要更换
    UILabel *needReplaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, 100, 20)];
    needReplaceLabel.text =SZLocal(@"title.Need to be replaced");
    
    self.needReplaceBtn = [[UIButton alloc] initWithFrame:CGRectMake(110, 120, 20, 20)];
    [self.needReplaceBtn addTarget:self action:@selector(replace:) forControlEvents:UIControlEventTouchUpInside];
    [self.needReplaceBtn setImage:checkOffImage forState:UIControlStateNormal];
    [self.needReplaceBtn setImage:checkOnImage forState:UIControlStateSelected];
    self.needReplaceBtn.selected = remark.isReplace;
    
    // 需要改造
    UILabel *needReformLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 150, 120, 100, 20)];
    needReformLabel.text =SZLocal(@"title.Need to transform");
    
    self.needReformeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 120, 20, 20)];
    [self.needReformeBtn addTarget:self action:@selector(repair:) forControlEvents:UIControlEventTouchUpInside];
    [self.needReformeBtn setImage:checkOffImage forState:UIControlStateNormal];
    [self.needReformeBtn setImage:checkOnImage forState:UIControlStateSelected];
    self.needReformeBtn.selected = remark.isRepair;

    // comment
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, SCREEN_WIDTH - 10, 20)];
    commentLabel.text = [NSString stringWithFormat:@"%@:",SZLocal(@"title.Problems found in the work and the need to deal with customers")];
    // comment内容
    self.commentText = [[UITextView alloc] initWithFrame:CGRectMake(10, 160 ,SCREEN_WIDTH - 20 , 180)];
    self.commentText.backgroundColor = [UIColor lightGrayColor];
    self.commentText.font =[UIFont fontWithName:@"Microsoft YaHei" size:15];
    self.commentText.delegate = self;
    self.commentText.text = remark.Question;
    self.commentText.returnKeyType = UIReturnKeyDone;
    
    [self.view addSubview:needReplaceLabel];
    [self.view addSubview:self.needReplaceBtn];
    [self.view addSubview:needReformLabel];
    [self.view addSubview:self.needReformeBtn];
    [self.view addSubview:commentLabel];
    [self.view addSubview:self.commentText];
}


-(void)replace:(UIButton *)btn{
    btn.selected = !btn.selected;
}
-(void)repair:(UIButton *)btn{
    btn.selected = !btn.selected;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 30, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.view layoutIfNeeded];
    }];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 30, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.view layoutIfNeeded];
    }];
    return [self.commentText resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.commentText resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}


@end
