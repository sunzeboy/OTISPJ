//
//  SZWorkAdjustmentController.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZWorkAdjustmentController.h"
#import "SZAddWorkingHoursController.h"
#import "SZBottomSaveOperationView.h"
#import "SZTable_Report.h"
#import "SZMaintainDetailViewController.h"
#import "CustomIOSAlertView.h"

@interface SZWorkAdjustmentController ()<UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UILabel *laborTypeBtn;

@property (weak, nonatomic) IBOutlet UITextView *inputTF;

@property (nonatomic , strong)  SZBottomSaveOperationView *operationView;
@property (nonatomic , strong)  SZLabor *labor;

@end

@implementation SZWorkAdjustmentController
- (BOOL)shouldAutorotate{
    
    return NO;
}

-(SZLabor *)labor{

    if (_labor == nil) {
        _labor = [[SZLabor alloc] init];
    }
    return _labor;
}

-(SZBottomSaveOperationView *)operationView{
    
    if(_operationView ==nil){
        _operationView =[SZBottomSaveOperationView loadSZBottomSaveOperationView];
        _operationView.frame = CGRectMake(0,SCREEN_HEIGHT-OTIS_BottomOperationH, SCREEN_WIDTH, OTIS_BottomOperationH);
        [_operationView.saveBtn setImage:[UIImage imageNamed:@"btn_confirm"] forState:0];
        [_operationView.saveBtn setTitle:SZLocal(@"btn.title.confirm") forState:0];
        [self.view addSubview:_operationView];
    }
    return _operationView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =SZLocal(@"dialog.title.Work adjustment");
    
    // 1. 创建一个点击事件，点击时触发labelClick方法
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick)];
    
    // 2. 将点击事件添加到label上
    [self.laborTypeBtn addGestureRecognizer:labelTapGestureRecognizer];
    self.laborTypeBtn.userInteractionEnabled = YES; // 可以理解为设置label可被点击
    
    [self.laborTypeBtn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    self.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    self.view.autoresizesSubviews = NO;
    [self.laborTypeBtn.layer setBorderWidth:1];//设置边界的宽度
    [self.inputTF.layer setBorderWidth:1];//设置边界的宽度

    self.laborTypeBtn.layer.borderColor = [UIColor blueColor].CGColor;
    self.inputTF.layer.borderColor = [UIColor blueColor].CGColor;

    SZAdjustment *adjustment =  [SZTable_Report quarywithDetialItem:self.item];
    if (adjustment.AdjustmentType&&adjustment.AdjustmentType.length>0) {
        
        NSArray *arrayLaborName = @[SZLocal(@"dialog.content.Recall"),
                                    SZLocal(@"dialog.content.Repair"),
                                    SZLocal(@"dialog.content.Trepair"),
                                    SZLocal(@"dialog.content.Compulsory rectification"),
                                    SZLocal(@"dialog.content.Annual inspection"),
                                    SZLocal(@"dialog.content.Paid vacation"),
                                    SZLocal(@"dialog.content.Compassionate leave"),
                                    SZLocal(@"dialog.content.Meeting"),
                                    SZLocal(@"dialog.content.press for money"),
                                    SZLocal(@"dialog.content.Overtime call"),
                                    SZLocal(@"dialog.content.Overtime repair"),
                                    SZLocal(@"dialog.content.Overtime T repair"),
                                    SZLocal(@"dialog.content.New ladder quality rectification"),
                                    SZLocal(@"dialog.content.sick leave"),
                                    SZLocal(@"dialog.content.Train"),
                                    SZLocal(@"dialog.content.Material feeding"),
                                    SZLocal(@"dialog.content.Be on duty"),
                                    SZLocal(@"dialog.content.Other production hours"),
                                    SZLocal(@"dialog.content.Other non productive hours")];
        NSArray *arrayLaborType = @[@"CB",
                                    @"R",
                                    @"T",
                                    @"MC",
                                    @"AE",
                                    @"HL",
                                    @"PL",
                                    @"MT",
                                    @"CP",
                                    @"OTCB",
                                    @"OTR",
                                    @"OT",
                                    @"NIS fix",
                                    @"SL",
                                    @"TR",
                                    @"AD",
                                    @"SB",
                                    @"OPH",
                                    @"ONPH"];
//        NSUInteger index = [arrayLaborType indexOfObject:adjustment.AdjustmentType];
        int index = 0;
        for (int i =0; i<arrayLaborType.count; i++) {
            if ([adjustment.AdjustmentType isEqualToString:arrayLaborType[i]]) {
                index = i;
            }
        }        SZLog(@"-----%d",index);
        self.inputTF.text = adjustment.AdjustmentComment;

        self.laborTypeBtn.text = SZLocal(arrayLaborName[index]) ;
        self.labor.LaborType = arrayLaborType[index];
    }
   

    WEAKSELF
    self.operationView.confirmActBlock = ^(UIButton *btn) {
        [weakSelf save];
    };
}

-(void)save {
    
    if (_inputTF.text.length>=20) {
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                 dialogTitle:SZLocal(@"dialog.title.tip")
                                                              dialogContents:SZLocal(@"dialog.content.More than 20 words can not be saved.")
                                                               dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
         alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
             [alertView close];
         };
        [alertView show];
        return;
    }
    
//    if (!self.labor.LaborType) {
//        self.labor = [[SZLabor alloc] init];
//        self.labor.LaborType = @"CB";
//    }
    [SZTable_Report storageWithAdjustmentType:self.labor.LaborType?:@"CB" adjustmentComment:self.inputTF.text andDetialItem:self.item];
    /**
     *  (如果没有进行过正常维保操作就保存一条操作记录，如果有进行过完整的维保操作，就不保存)
     */
    [USER_DEFAULT setObject:@(self.item.ScheduleID) forKey:[NSString stringWithFormat:@"%d",(int)self.item.ScheduleID]];
    
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:[SZMaintainDetailViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }

    
    
}



-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length>20) {
        
    }
    
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_inputTF resignFirstResponder];
}

- (void)labelClick{
    
    SZAddWorkingHoursController *vc = [[SZAddWorkingHoursController alloc] init];
    vc.zhongduan = YES;

//    WEAKSELF
    vc.selectedBlock = ^(SZLabor *labor,BOOL isLastObject){
        self.labor = labor;
        self.laborTypeBtn.text = labor.LaborName;
        [self.view setNeedsDisplay];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
