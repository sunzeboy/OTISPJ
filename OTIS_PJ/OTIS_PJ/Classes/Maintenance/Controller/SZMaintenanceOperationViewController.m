//
//  SZMaintenanceOperationViewController.m
//  OTIS_PJ
//
//  Created by zy on 16/5/6.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZMaintenanceOperationViewController.h"
#import "SZMaintenanceHalfMonthViewController.h"
#import "SZMaintenanceQuarterViewController.h"
#import "SZMaintenanceHalfYearViewController.h"
#import "SZMaintenanceYearViewController.h"
#import "SZMaintenanceCommentsViewController.h"
#import "SZModuleQueryTool.h"
#import "NSMutableArray+Extention.h"
#import "SZMaintenanceCheckItem.h"
#import "SZTable_Report.h"
#import "SZAlbumViewController.h"
#import "SZInputWorkingHourViewController.h"
#import "UIBarButtonItem+Extention.h"
#import "SZTable_Schedules.h"
#import "CustomIOSAlertView.h"
#import "SZBottomMaintainView.h"
#import "SZSignCommentsViewController.h"
#import "MBProgressHUD.h"
#import "SZMaintainDetailViewController.h"
#import "SZBottomWorkingHourView.h"
#import "TablesAndFields.h"

#import "MDBoomView.h"
#import "Masonry.h"
#import "MDBaseButton.h"
#import "FDAlertView.h"
#import "MDCustomAlertView.h"
#import "CustomTextView.h"
#import "MaintenanceViewController.h"

@interface DetailViewController : UIViewController {
    UIImageView *_imageView;
}
@property (nonatomic, strong) UIImage *detailImage;

@end

@implementation DetailViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
#endif
    
    [self.navigationItem setTitle:@"Detail"];
    
    _imageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:_imageView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_imageView setImage:_detailImage];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    _detailImage = nil;
    [_imageView setImage:nil];
}

@end

@interface SZMaintenanceOperationViewController ()

@property(nonatomic,strong) MDMaintainButton* boomViewAllSelectBtn;
// 底部按钮栏
@property (nonatomic , strong) SZBottomMaintainView *maintainView;
@property (nonatomic , strong)  SZBottomWorkingHourView *workingHourView;
// 滚动条名称的数组
@property (nonatomic , strong) NSArray *arrayTitle;
// 是否保存照片的flg
@property (nonatomic , assign) BOOL hasSaved;


/*******MD**/

@property(nonatomic,strong) NSMutableArray* allDataArray;

@property(nonatomic,strong) NSMutableArray* saveDataArray;

@property(nonatomic,assign) int searchIndex;


@end

@implementation SZMaintenanceOperationViewController


//-(SZBottomMaintainView *)maintainView{
//    
//    if(_maintainView ==nil){
//        _maintainView =[SZBottomMaintainView loadSZBottomOperationView];
//        _maintainView.frame = CGRectMake(0,SCREEN_HEIGHT-OTIS_BottomOperationH, SCREEN_WIDTH, OTIS_BottomOperationH);
//        [self.view addSubview:_maintainView];
//    }
//    return _maintainView;
//    
//}

-(SZBottomWorkingHourView *) workingHourView{
    
    if(_workingHourView ==nil){
        _workingHourView =[SZBottomWorkingHourView loadSZBottomWorkingHourView];
        _workingHourView.frame = CGRectMake(0,SCREEN_HEIGHT-OTIS_BottomOperationH, SCREEN_WIDTH, OTIS_BottomOperationH);
        [_workingHourView.findBtn setImage:[UIImage imageNamed:@"btn_confirm"] forState:0];
        [_workingHourView.scanBtn setImage:[UIImage imageNamed:@"btn_allSelect_blue"] forState:0];
        [_workingHourView.findBtn setTitle:SZLocal(@"btn.title.confirm") forState:0];
        [_workingHourView.scanBtn setTitle:SZLocal(@"btn.title.allSelect") forState:0];
        [self.view addSubview:_workingHourView];
    }
    return _workingHourView;
}

-(NSArray *)arrayTitle {
    if (_arrayTitle == nil) {
        _arrayTitle = @[SZLocal(@"title.SZMaintenanceOperation.halfMonth"),SZLocal(@"title.SZMaintenanceOperation.quarter"),SZLocal(@"title.SZMaintenanceOperation.halfYear"),SZLocal(@"title.SZMaintenanceOperation.year"),SZLocal(@"title.SZMaintenanceOperation.comments")];
    }
    return _arrayTitle;
}

-(void)viewWillDisappear:(BOOL)animated{
    if (!self.hasSaved) {//没有保存就删掉照片
        
    }

}

- (void)viewDidLoad {
    self.isNeedSpace = YES;
    [super viewDidLoad];
    self.title = SZLocal(@"title.SZMaintenanceOperationViewController");
    [self setNavItem];
    [self setSubTitleView];
    [self setBoomView];

    WEAKSELF
    
    if (self.isFixMode) {
        
        self.workingHourView.findBtnClickBlock = ^(UIButton *btn) {
            [weakSelf save];
        };
        // 相机按钮
        self.workingHourView.scanBtnClickBlock = ^(UIButton *btn) {
            [weakSelf selectAll];
        };

        
    }else{
        // 中断按钮
        self.maintainView.suspendActBlock = ^(UIButton *btn) {
            SZMaintenanceCommentsViewController *comments = [weakSelf.childViewControllers objectAtIndex:4];
            if (comments.commentText.text.length>100) {
                CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@"person"
                                                                                                dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                             dialogContents:SZLocal(@"error.Note more than 100 words can not be saved")
                                                                                              dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
                alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
                    [alertView close];
                };
                [alertView show];
                return;
            }
            [weakSelf stop];
        };
        // 相机按钮
        self.maintainView.cameraActBlock = ^(UIButton *btn) {
            [weakSelf takeAPhoto];
        };
        // 保存按钮
        self.maintainView.confirmActBlock = ^(UIButton *btn) {
            if (weakSelf.isFixMode) {
                [weakSelf save];
            }else{
                
                SZMaintenanceCommentsViewController *comments = [weakSelf.childViewControllers objectAtIndex:4];
                if (comments.commentText.text.length>100) {
                    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@"person"
                                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                                 dialogContents:SZLocal(@"error.Note more than 100 words can not be saved")
                                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
                    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
                        [alertView close];
                    };
                    [alertView show];
                    return;
                }
                
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                    [weakSelf save];
                });
                
                
            }
            
        };
        // 全选按钮
        self.maintainView.allSelectActBlock = ^(UIButton *btn) {
            [weakSelf selectAll];
        };
        SZLog(@"---%d",self.boomViewAllSelectBtn.selected);
    
    }

    [self judgeSelectBtnTitleWithBtn];
}

-(void)setBoomView{
    WEAKSELF
    MDBoomView* boomView=[[MDBoomView alloc] initWithBoomTitleArray:@[@"保存",@"全选"] imageArray:@[@"btn_save_blue",@"btn_allSelect_blue"]];
    boomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:boomView];
    self.boomViewAllSelectBtn = [boomView.boomViewButtonArray lastObject];
//    [self.boomViewAllSelectBtn setTitle:@"反全选" forState:UIControlStateSelected];
    
    NSLog(@"************%d",self.boomViewAllSelectBtn.selected);
    
    [boomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.mas_equalTo(60);
    }];
    
    boomView.buttonClickBlock=^(NSInteger index){
        
        
        switch (index) {
            case 10:
            {
                [weakSelf save];
            }
                break;
            case 11:
            {
                [weakSelf selectAll];
            }
                break;
            default:
                break;
        }
    };
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    [super scrollViewDidEndDecelerating:scrollView];
//    
//    
//    
//    
//    
//    
//    
//}

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
    
    [self.navigationController popViewControllerAnimated:YES];
    
//    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
//                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
//                                                                                 dialogContents:SZLocal(@"dialog.content.Maintenance content is not saved, whether to quit?")
//                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
//    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
//        [alertView close];
//        if(buttonIndex == 0){
//
//            [self.navigationController popViewControllerAnimated:YES];
//          
//        }else if(buttonIndex == 1){
//            [alertView close];
//        }
//    };
//    [self.view endEditing:YES];
//    [alertView show];
}

// 设置副标题
- (void) setSubTitleView {
    UIView *subTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 80)];
    subTitleView.backgroundColor = [UIColor colorWithRed:3.0f/255.0f green:96.0f/255.0f blue:169.0f/255.0f alpha:1];
    // 电梯编号
    UILabel *evelatorNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 16, 80, 20)];
    evelatorNumLabel.textColor = [UIColor whiteColor];
    evelatorNumLabel.text = [NSString stringWithFormat:@"%@:",SZLocal(@"dialog.title.Elevator number")];
    UILabel *evelatorNumText =[[UILabel alloc]initWithFrame:CGRectMake(100, 16, 120, 20)];
    evelatorNumText.textColor = [UIColor whiteColor];
    evelatorNumText.text = self.item.UnitNo;
    // 计划日期
    UILabel *plannedDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 44, 80, 20)];
    plannedDateLabel.textColor = [UIColor whiteColor];
    plannedDateLabel.text =[NSString stringWithFormat:@"%@:",SZLocal(@"title.planeDate")];
    UILabel *plannedDateText =[[UILabel alloc]initWithFrame:CGRectMake(100, 44, 120, 20)];
    plannedDateText.textColor = [UIColor whiteColor];
    plannedDateText.text = self.item.CheckDateStr;
    
    [subTitleView addSubview:evelatorNumLabel];
    [subTitleView addSubview:evelatorNumText];
    [subTitleView addSubview:plannedDateLabel];
    [subTitleView addSubview:plannedDateText];
     
    [self.view addSubview:subTitleView];
}


-(void)setupChildVces
{
    SZMaintenanceHalfMonthViewController *halfMonth = [[SZMaintenanceHalfMonthViewController alloc] init];
    halfMonth.item2 = self.item;
    halfMonth.svtModel = self.svtModel;
    halfMonth.title = SZLocal(@"title.SZMaintenanceOperation.halfMonth");
    halfMonth.isFixMode = self.isFixMode;
    [self addChildViewController:halfMonth];
    
    SZMaintenanceQuarterViewController *quarter = [[SZMaintenanceQuarterViewController alloc] init];
    quarter.item2 = self.item;
    quarter.svtModel = self.svtModel;
    quarter.title = SZLocal(@"title.SZMaintenanceOperation.quarter");
    quarter.isFixMode = self.isFixMode;
    [self addChildViewController:quarter];
    
    SZMaintenanceHalfYearViewController *halfYear = [[SZMaintenanceHalfYearViewController alloc] init];
    halfYear.item2 = self.item;
    halfYear.svtModel = self.svtModel;
    halfYear.title = SZLocal(@"title.SZMaintenanceOperation.halfYear");
    halfYear.isFixMode = self.isFixMode;
    [self addChildViewController:halfYear];
    
    SZMaintenanceYearViewController *year = [[SZMaintenanceYearViewController alloc] init];
    year.item2 = self.item;
    year.svtModel = self.svtModel;
    year.title = SZLocal(@"title.SZMaintenanceOperation.year");
    year.isFixMode = self.isFixMode;
    [self addChildViewController:year];
    
    if (self.isFixMode) {
        
    }else{
    
        if (self.isSign) {
            SZSignCommentsViewController *comments = [[SZSignCommentsViewController alloc] init];
            SZMaintenanceRemarks *remark = [SZTable_Report quaryRemarkWithScheduleID:(int)self.item.ScheduleID];
            //内容编辑
            comments.maintenanceComments = remark.Question;
            comments.needReform = remark.isRepair;
            comments.needReplace = remark.isReplace;
            comments.title = SZLocal(@"title.SZMaintenanceOperation.comments");
//            [self addChildViewController:comments];
        }else{
            SZMaintenanceCommentsViewController *comments = [[SZMaintenanceCommentsViewController alloc] init];
            comments.title = SZLocal(@"title.SZMaintenanceOperation.comments");
            comments.scheadleId = (int)self.item.ScheduleID;
//            [self addChildViewController:comments];
        }

    }
    
}




-(void)setSelectedButton:(UIButton *)selectedButton{
    SZLog(@"%@",selectedButton.titleLabel.text);

    [super setSelectedButton:selectedButton];
    SZTableViewController *vc = [self.childViewControllers objectAtIndex:[self.arrayTitle indexOfObject:self.selectedButton.titleLabel.text]];
    if ([vc isKindOfClass:[SZMaintenanceCommentsViewController class]]) {
        return;
    }
    //vc.allSelect=NO;
    BOOL isSelected=vc.allSelect;
    self.boomViewAllSelectBtn.selected = isSelected;
}

-(void)save{

    self.hasSaved = YES;
    SZMaintenanceHalfMonthViewController *halfMonth = [self.childViewControllers objectAtIndex:0];
    SZMaintenanceQuarterViewController *quarter  = [self.childViewControllers objectAtIndex:1];
    SZMaintenanceHalfYearViewController *halfYear = [self.childViewControllers objectAtIndex:2];
    SZMaintenanceYearViewController *year = [self.childViewControllers objectAtIndex:3];
    
    NSMutableArray *arrayData = [NSMutableArray  arrayWithArray:halfMonth.maintenanceOperation];
    [arrayData addObjectsFromArray:[NSMutableArray arrayWithArray:quarter.maintenanceOperation]];
    [arrayData addObjectsFromArray:[NSMutableArray arrayWithArray:halfYear.maintenanceOperation]];
    [arrayData addObjectsFromArray:[NSMutableArray arrayWithArray:year.maintenanceOperation]];
    
    
    [self judgeRightAndLeftIsSame:arrayData];
    
    return;
    int totalUncompleteCount = halfMonth.unCompleteCount+quarter.unCompleteCount+halfYear.unCompleteCount+year.unCompleteCount;

    
        if ([self allSelect]&&self.isJHAComplete == NO) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                                dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                             dialogContents:SZLocal(@"error.Security analysis is not all done, do not allow the selection of all maintenance items!")
                                                                                              dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
                alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
                    [alertView close];
                };
                [alertView show];
                
            });
            return;
        }
    
    // 是否是维修换件判断
    if (self.isFixMode) {
        
        /**
         *  是否有改变
         */
        if (halfMonth.ischanged||quarter.ischanged||halfYear.ischanged||year.ischanged) {
            [SZTable_Report updateCheckItemWithDetialItemForFix:arrayData andCheckItem:self.item isModify:YES];
        }
        
        [self.navigationController popToViewController:[self.navigationController.childViewControllers objectAtIndex:1] animated:YES];
        return;
    }
    
        SZMaintenanceCommentsViewController *comments = [self.childViewControllers objectAtIndex:4];
        /**
         *  得到选中的JHA项目数组
         */
        NSMutableArray *arraySelected = [NSMutableArray  selectedCheckItemsWithArray:halfMonth.maintenanceOperation];
        [arraySelected addObjectsFromArray:[NSMutableArray selectedCheckItemsWithArray:quarter.maintenanceOperation]];
        [arraySelected addObjectsFromArray:[NSMutableArray selectedCheckItemsWithArray:halfYear.maintenanceOperation]];
        [arraySelected addObjectsFromArray:[NSMutableArray selectedCheckItemsWithArray:year.maintenanceOperation]];

        BOOL ret1 = halfMonth.weixuan;
        BOOL ret2 = quarter.weixuan;
        BOOL ret3 = halfYear.weixuan;
        BOOL ret4 = year.weixuan;

        if ( ret1 && ret2  && ret3 && ret4) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                                dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                             dialogContents:SZLocal(@"dialog.content.report")
                                                                                              dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
                
                alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
                    [alertView close];
                };
                
                [alertView show];
                
            });
            
            
        }else{
            
            if ((halfMonth.allSelect && quarter.allSelect && halfYear.allSelect && year.allSelect)||totalUncompleteCount == 0) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                                    dialogTitle:SZLocal(@"title.MaintenanceViewController")
                                                                                                 dialogContents:SZLocal(@"error.Are you sure you have completed all maintenance?")
                                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
                    
                    //WEAKSELF
                    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
                        if(buttonIndex == 0){
                            /**
                             *  保存完成的保养项目
                             */
                            [SZModuleQueryTool storageCompletedMaintenanceItemWithArray:arraySelected andDetialItem:self.item];
                            [SZTable_Report storageCheckItemWithDetialItem:self.item andLastStatus:0 andRemark:[SZMaintenanceRemarks remarkWithQuestion:comments.commentText.text isrepiar:comments.needReformeBtn.selected isreplace:comments.needReplaceBtn.selected]];
                            
                            // 只要做了保养项目的保存，中断或者保存，都将工时进入的状态清除
                            [SZTable_Schedules updateAddLaborHoursState:0 andScheduleID:self.item.ScheduleID];
                            
                            // 更新计划表中的状态
                            [SZTable_Schedules updateIsComplete:2 andScheduleID:(int)self.item.ScheduleID];
                            
                            if (halfMonth.ischanged||quarter.ischanged||halfYear.ischanged||year.ischanged) {
                                [SZTable_Report updateCheckItemWithDetialItem2:arrayData andCheckItem:self.item isModify:YES];
                            }
                            
                            /**
                             *  (如果没有进行过正常维保操作就保存一条操作记录，如果有进行过完整的维保操作，就不保存)
                             */
                            [USER_DEFAULT setObject:@(self.item.ScheduleID) forKey:[NSString stringWithFormat:@"%d",(int)self.item.ScheduleID]];

                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                SZInputWorkingHourViewController *vc = [[SZInputWorkingHourViewController alloc] init];
                                vc.scheduleID = (int)self.item.ScheduleID;
                                //vc.isWorkhour=YES;
                                vc.item = self.item;
                                //            vc.item = self.item;
                                [self.navigationController pushViewController:vc animated:YES];
                            });
                            //检查一下如果是全做完的（除了每年一次），有99项的要删掉
                            [USER_DEFAULT setObject:@(self.item.ScheduleID) forKey:[NSString stringWithFormat:@"%d_每年一次",(int)self.item.ScheduleID]];
                            [alertView close];
                            
                        }else if(buttonIndex == 1){
                            [alertView close];
                        }
                    };
                    
                    [alertView show];
                    
                });
                
            }else{
                // 更新计划表中的状态
                [SZTable_Schedules updateIsComplete:1 andScheduleID:(int)self.item.ScheduleID];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                                    dialogTitle:SZLocal(@"title.MaintenanceViewController")
                                                                                                 dialogContents:[NSString stringWithFormat:@"%@%d%@",@"您还有",totalUncompleteCount,@"项没有完成，是否继续保存?"]
                                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
                    
                    //WEAKSELF
                    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
                        if(buttonIndex == 0){
                            /**
                             *  保存完成的保养项目
                             */
                            [SZModuleQueryTool storageCompletedMaintenanceItemWithArray:arraySelected andDetialItem:self.item];
                            [SZTable_Report storageCheckItemWithDetialItem:self.item andLastStatus:0 andRemark:[SZMaintenanceRemarks remarkWithQuestion:comments.commentText.text isrepiar:comments.needReformeBtn.selected isreplace:comments.needReplaceBtn.selected]];
                            
                            if (halfMonth.ischanged||quarter.ischanged||halfYear.ischanged||year.ischanged) {
                                [SZTable_Report updateCheckItemWithDetialItem2:arrayData andCheckItem:self.item isModify:YES];
                            }

                            [alertView close];
                        }else if(buttonIndex == 1){
                            [alertView close];
                        }
                    };
                    [alertView show];
                    
                });
            }
        }
}

//便利所有自控制器的数据源数组，对比自动与手动的不同之处，如有不同弹出提示框。
-(void)judgeRightAndLeftIsSame:(NSMutableArray*)array{
    
    NSInteger temp=0;
    for (int i =self.searchIndex; i<array.count; i++) {
        //设置self.searchIndex用于跳过已经处理的项目
        self.searchIndex=i+1;
        SZMaintenanceCheckItem *itemAll = array[i];
        
        //跳过没有数据的自动项
        if (itemAll.isHiden)  continue;
        //        if (model.isSave)  continue;
        
        //判断自动与手动是否有不同之处，不同时设置temp等于1，用于标记有项目不同
        if (itemAll.automType!=itemAll.state) {
            temp=1;
            break;
        }else{
            if ([self.saveDataArray containsObject:itemAll]) {
                [self.saveDataArray removeObject:itemAll];
                NSLog(@"-------------保存数组%lu",(unsigned long)self.saveDataArray.count);
            }
        }
    }
    
    if (temp==1) {
        SZMaintenanceCheckItem *itemAll = array[self.searchIndex-1];
        if ([self.saveDataArray containsObject:itemAll]) {
            [self judgeRightAndLeftIsSame:array];
            return;
        }
        FDAlertView *alert = [[FDAlertView alloc] init];
        MDCustomAlertView *contentView = [[MDCustomAlertView alloc] initWithFrame:CGRectMake(0, 0, MDScreenW-30,190)];
        
        NSString* automType;
        switch (itemAll.automType) {
            case 0:
                automType=@"正常项目";
                break;
            case 1:
                 automType=@"调整更换部件";
                break;
            case 2:
                 automType=@"清洁,润滑更换";
                break;
            case 3:
                 automType=@"无此项目";
                break;
            default:
                break;
        }
        
        NSString* stateStr;
        switch (itemAll.state) {
            case 0:
                stateStr=@"正常项目";
                break;
            case 1:
                stateStr=@"调整更换部件";
                break;
            case 2:
                stateStr=@"清洁,润滑更换";
                break;
            case 3:
                stateStr=@"无此项目";
                break;
            default:
                break;
        }
        
        if (stateStr==nil) {
            stateStr=@"技师未操作";
        }
        
        contentView.textView.placeholder=[NSString stringWithFormat:@"%@:%@ 自动:%@ 手动:%@",itemAll.ItemCode,itemAll.ItemName,automType,stateStr];
        alert.contentView = contentView;
        [alert show];
        
        contentView.jumpBlcok=^{
            //相等时表示已经便利完毕
            if (self.searchIndex==array.count) {
                [self.saveDataArray addObject:itemAll];
                [self goBack];
            }else{
                //                model.isSave=YES;
                //不相等则继续便利直到便利完成
                [self.saveDataArray addObject:itemAll];
                NSLog(@"+++++++++++++++++++保存数组%lu",(unsigned long)self.saveDataArray.count);
                [self judgeRightAndLeftIsSame:array];
            }
        };
        
        //点击取消时self.searchIndex-1，当下次重新点击开始保存时从上一个未处理项继续便利
        contentView.cancleBlcok=^{
            self.searchIndex-=1;
        };
        
    }else{
        //手动和自动项目完全相等时直接保存跳回上一个界面
        [self goBack];
    }
}

-(void)goBack{
    NSLog(@"==============保存数组%lu",(unsigned long)self.saveDataArray.count);
    
    for (UIViewController* vc in self.navigationController.childViewControllers) {
        if ([vc isMemberOfClass:[MaintenanceViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}
// 中断
-(void)stop{
    
    
    SZMaintenanceHalfMonthViewController *halfMonth = [self.childViewControllers objectAtIndex:0];
    SZMaintenanceQuarterViewController *quarter  = [self.childViewControllers objectAtIndex:1];
    SZMaintenanceHalfYearViewController *halfYear = [self.childViewControllers objectAtIndex:2];
    SZMaintenanceYearViewController *year = [self.childViewControllers objectAtIndex:3];
  
    int totalUncompleteCount = halfMonth.unCompleteCount+quarter.unCompleteCount+halfYear.unCompleteCount+year.unCompleteCount;

    SZMaintenanceCommentsViewController *comments = [self.childViewControllers objectAtIndex:4];

    
    if ((halfMonth.allSelect && quarter.allSelect && halfYear.allSelect && year.allSelect)||totalUncompleteCount == 0) {//保养已做完
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:SZLocal(@"error.You have completed all maintenance, do not need to interrupt maintenance.")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            [alertView close];
        };
        [alertView show];
    }else{
    
        // 只要做了保养项目的保存，中断或者保存，都将工时进入的状态清除
        [SZTable_Schedules updateAddLaborHoursState:0 andScheduleID:self.item.ScheduleID];
        
        NSMutableArray *arraySelected = [NSMutableArray  selectedCheckItemsWithArray:halfMonth.maintenanceOperation];
        [arraySelected addObjectsFromArray:[NSMutableArray selectedCheckItemsWithArray:quarter.maintenanceOperation]];
        [arraySelected addObjectsFromArray:[NSMutableArray selectedCheckItemsWithArray:halfYear.maintenanceOperation]];
        [arraySelected addObjectsFromArray:[NSMutableArray selectedCheckItemsWithArray:year.maintenanceOperation]];
        
        [SZModuleQueryTool storageCompletedMaintenanceItemWithArray:arraySelected andDetialItem:self.item];
        [SZTable_Report storageCheckItemWithDetialItem:self.item andLastStatus:1 andRemark:[SZMaintenanceRemarks remarkWithQuestion:comments.commentText.text isrepiar:comments.needReformeBtn.selected isreplace:comments.needReplaceBtn.selected]];
        SZInputWorkingHourViewController *vc = [[SZInputWorkingHourViewController alloc] init];
        vc.scheduleID = (int)self.item.ScheduleID;
        vc.item = self.item;
        vc.zhongduan = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(BOOL)allSelect{
    
    SZMaintenanceHalfMonthViewController *halfMonth = [self.childViewControllers objectAtIndex:0];
    SZMaintenanceQuarterViewController *quarter  = [self.childViewControllers objectAtIndex:1];
    SZMaintenanceHalfYearViewController *halfYear = [self.childViewControllers objectAtIndex:2];
    SZMaintenanceYearViewController *year = [self.childViewControllers objectAtIndex:3];
    
    if (self.isFixMode) {
        
        if (halfMonth.allSelect && quarter.allSelect && halfYear.allSelect && year.allSelect){
            return YES;
        }
        
    }else{
        int totalUncompleteCount = halfMonth.unCompleteCount+quarter.unCompleteCount+halfYear.unCompleteCount+year.unCompleteCount;
        return totalUncompleteCount == 0;
    }
    return NO;
}


-(void)selectAll{
    NSArray *arrayTitle = @[SZLocal(@"title.SZMaintenanceOperation.halfMonth"),SZLocal(@"title.SZMaintenanceOperation.quarter"),SZLocal(@"title.SZMaintenanceOperation.halfYear"),SZLocal(@"title.SZMaintenanceOperation.year"),SZLocal(@"title.SZMaintenanceOperation.comments")];
    SZTableViewController *vc = [self.childViewControllers objectAtIndex:[arrayTitle indexOfObject:self.selectedButton.titleLabel.text]];
    if ([vc isKindOfClass:[SZMaintenanceCommentsViewController class]]) {
        return;
    }
    self.boomViewAllSelectBtn.selected = !self.boomViewAllSelectBtn.selected;
    

    if (self.boomViewAllSelectBtn.selected) {
        if (self.isFixMode) {
            [self.workingHourView.scanBtn setTitle:SZLocal(@"btn.title.allSelect") forState:UIControlStateNormal];
            vc.allSelect = NO;
        }else{
            [self.boomViewAllSelectBtn setTitle:SZLocal(@"btn.title.allSelect") forState:UIControlStateNormal];
            vc.allSelect = self.boomViewAllSelectBtn.selected;
        }
        
    } else {

        if (self.isFixMode) {
            [self.workingHourView.scanBtn setTitle:SZLocal(@"btn.title.noSelect") forState:UIControlStateNormal];
            vc.allSelect = YES;
        }else{
            
            [self.boomViewAllSelectBtn setTitle:SZLocal(@"btn.title.noSelect") forState:UIControlStateNormal];
            vc.allSelect = self.boomViewAllSelectBtn.selected;
            
        }
    }
    [self tipisJHACompleteWithVC:vc];
}

-(void)tipisJHACompleteWithVC:(SZTableViewController *)vc{

        if (self.isJHAComplete) {

        }else{
            if ([self allSelect]) {
                if (vc) {
                    vc.allSelect = !self.boomViewAllSelectBtn.selected;
                }
                
                CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                                dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                             dialogContents:SZLocal(@"error.Security analysis is not all done, do not allow the selection of all maintenance items!")
                                                                                              dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
                alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
                    [alertView close];
                };
                [alertView show];
            }else{
            
                
            }
        }


}


-(void)takeAPhoto{
    SZAlbumViewController *vc = [[SZAlbumViewController alloc] init];
    vc.item = self.item;
    vc.title = SZLocal(@"title.Photograph");
    [self.navigationController pushViewController:vc animated:YES];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


-(void)clickTitle:(UIButton *)button{
    [super clickTitle:button];
    for (UIViewController *childViewController in self.childViewControllers){
        [childViewController.view endEditing:YES];
    }
    [self judgeSelectBtnTitleWithBtn];
}

-(void)judgeSelectBtnTitleWithBtn {
    
    SZTableViewController *vc = [self.childViewControllers objectAtIndex:[self.arrayTitle indexOfObject:self.selectedButton.titleLabel.text]];
    if ([vc isKindOfClass:[SZMaintenanceCommentsViewController class]]) {
        [self.boomViewAllSelectBtn setImage:[UIImage imageNamed:@"btn_allSelect_gray"] forState:UIControlStateNormal];
        [self.boomViewAllSelectBtn setTitle:SZLocal(@"btn.title.allSelect") forState:UIControlStateNormal];
        self.boomViewAllSelectBtn.userInteractionEnabled=NO;
        return;
    }
    if (!vc.hasData) {
        [self.boomViewAllSelectBtn setImage:[UIImage imageNamed:@"btn_allSelect_gray"] forState:UIControlStateNormal];
        [self.boomViewAllSelectBtn setTitle:SZLocal(@"btn.title.allSelect") forState:UIControlStateNormal];
        self.boomViewAllSelectBtn.userInteractionEnabled=NO;
    }else{
        
        if (vc.allSelect) {
            [self.boomViewAllSelectBtn setImage:[UIImage imageNamed:@"btn_allSelect_blue"] forState:UIControlStateNormal];
            [self.boomViewAllSelectBtn setTitle:SZLocal(@"btn.title.noSelect") forState:UIControlStateNormal];
            self.boomViewAllSelectBtn.selected = NO;

        }else{
            [self.boomViewAllSelectBtn setImage:[UIImage imageNamed:@"btn_allSelect_blue"] forState:UIControlStateNormal];
            [self.boomViewAllSelectBtn setTitle:SZLocal(@"btn.title.allSelect") forState:UIControlStateNormal];
            self.boomViewAllSelectBtn.selected = YES;

        }
        self.boomViewAllSelectBtn.userInteractionEnabled=YES;
        
    }
}

@end
