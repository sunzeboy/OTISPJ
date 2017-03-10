//
//  MDMainOperationVC.m
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/10.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import "MDMainOperationVC.h"
#import "Masonry.h"
#import "MDHalfMounthVC.h"
#import "MDQuarterVC.h"
#import "MDHalfYearVC.h"
#import "MDYearVC.h"
#import "MDRemarkVC.h"
#import "MDBaseButton.h"
#import "FDAlertView.h"
#import "MDCustomAlertView.h"
#import "MDMatainModel.h"
#import "CustomTextView.h"
#import "MDLiftModel.h"
@interface MDMainOperationVC ()
@property(nonatomic,strong) NSMutableArray* allDataArray;

@property(nonatomic,strong) NSMutableArray* saveDataArray;


@end

@implementation MDMainOperationVC

-(NSMutableArray*)saveDataArray{
    if (!_saveDataArray) {
        _saveDataArray=[NSMutableArray array];
    }
    return _saveDataArray;
}

-(NSMutableArray*)allDataArray{
    if (!_allDataArray) {
        _allDataArray=[NSMutableArray array];
    }
    return _allDataArray;
}

- (void)viewDidLoad {
    self.topHeigtht=60;
    self.booViewHeight=60;
    [super viewDidLoad];
    self.title=@"保养操作";
    [self.topBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(self.topHeigtht);
    }];
    [self setOperationView];
    [self.boomViewButtonArray[0] setTitle:@"保存" forState:UIControlStateNormal];
    [self.boomViewButtonArray[0] setImage:[UIImage imageNamed:@"btn_save_blue"] forState:UIControlStateNormal];
    
    [self.boomViewButtonArray[1] setTitle:@"全选" forState:UIControlStateNormal];
    [self.boomViewButtonArray[1] setImage:[UIImage imageNamed:@"btn_save_blue"] forState:UIControlStateNormal];
}

-(void)setOperationView{
    
    UIView* backView=[[UIView alloc] init];
    backView.backgroundColor=MDColor(10, 76, 153, 1.0);
    [self.view addSubview:backView];
    
    UILabel* titleLabel=[[UILabel alloc] init];
    titleLabel.text=[NSString stringWithFormat:@"电梯编号:%@",self.liftModel.UnitNo];
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UILabel* subLabel=[[UILabel alloc] init];
    subLabel.text=[NSString stringWithFormat:@"计划日期:%@",self.liftModel.CheckDateStr];
    subLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:subLabel];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.mas_equalTo(self.topHeigtht);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).with.offset(20);
        make.right.equalTo(backView.mas_right).with.offset(0);
        make.top.equalTo(backView.mas_top).with.offset(0);
        make.height.mas_equalTo(30);
    }];
    
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).with.offset(20);
        make.right.equalTo(backView.mas_right).with.offset(0);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(0);
        make.bottom.equalTo(backView.mas_bottom).with.offset(0);
    }];
}

-(void)initChildVCs{
    
    MDHalfMounthVC* halfMounthVC=[[MDHalfMounthVC alloc] init];
    [self addChildViewController:halfMounthVC];
    
    MDQuarterVC* quarterVC=[[MDQuarterVC alloc] init];
    [self addChildViewController:quarterVC];
    
    MDHalfYearVC* halfYearVC=[[MDHalfYearVC alloc] init];
    [self addChildViewController:halfYearVC];
    
    MDYearVC* yearVC=[[MDYearVC alloc] init];
    [self addChildViewController:yearVC];
//    
//    MDRemarkVC* remarkVC=[[MDRemarkVC alloc] init];
//    [self addChildViewController:remarkVC];
    
    [self.topCollectionView reloadData];
}


-(void)goBack{
    NSLog(@"==============保存数组%lu",(unsigned long)self.saveDataArray.count);

    for (UIViewController* vc in self.navigationController.childViewControllers) {
        if ([vc isMemberOfClass:[MDMaintainVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

//便利所有自控制器的数据源数组，对比自动与手动的不同之处，如有不同弹出提示框。
-(void)judgeRightAndLeftIsSame:(NSMutableArray*)array{

    NSInteger temp=0;
    for (int i =self.searchIndex; i<array.count; i++) {
        //设置self.searchIndex用于跳过已经处理的项目
        self.searchIndex=i+1;
        MDMatainModel* model = array[i];
        
        //跳过没有数据的自动项
        if (model.isHiden)  continue;
//        if (model.isSave)  continue;

        //判断自动与手动是否有不同之处，不同时设置temp等于1，用于标记有项目不同
        if (model.leftTag!=model.rightTag) {
            temp=1;
            break;
        }else{
            if ([self.saveDataArray containsObject:model]) {
                [self.saveDataArray removeObject:model];
                NSLog(@"-------------保存数组%lu",(unsigned long)self.saveDataArray.count);
            }
        }
    }
    
    if (temp==1) {
        MDMatainModel* model = array[self.searchIndex-1];
        if ([self.saveDataArray containsObject:model]) {
            [self judgeRightAndLeftIsSame:array];
            return;
        }
        FDAlertView *alert = [[FDAlertView alloc] init];
        MDCustomAlertView *contentView = [[MDCustomAlertView alloc] initWithFrame:CGRectMake(0, 0, MDScreenW-30,190)];
        contentView.textView.placeholder=[NSString stringWithFormat:@"%@%@",model.title,model.subTitle];
        alert.contentView = contentView;
        [alert show];
        
        contentView.jumpBlcok=^(NSString* reson){
            //相等时表示已经便利完毕
            if (self.searchIndex==array.count) {
                [self.saveDataArray addObject:model];
                [self goBack];
            }else{
//                model.isSave=YES;
                //不相等则继续便利直到便利完成
                [self.saveDataArray addObject:model];
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


-(void)boomViewButtonClick:(UIButton*)button{
    
    if (button.tag==10) {
        //点击之前清空上一个数组，防止在用户点击取消时，从新点击开始保存按钮重复想数组中添加数据
        [self.allDataArray removeAllObjects];
        self.searchIndex=0;
        MDHalfMounthVC* halfMounthVC=(MDHalfMounthVC*)self.childViewControllers[0];
        [self.allDataArray addObjectsFromArray:halfMounthVC.dataArray];
        
        MDQuarterVC* quarterVC=(MDQuarterVC*)self.childViewControllers[1];
        [self.allDataArray addObjectsFromArray:quarterVC.dataArray];

        MDHalfYearVC* halfYearVC=(MDHalfYearVC*)self.childViewControllers[2];
        [self.allDataArray addObjectsFromArray:halfYearVC.dataArray];

        MDYearVC* yearVC=(MDYearVC*)self.childViewControllers[3];
        [self.allDataArray addObjectsFromArray:yearVC.dataArray];
        
        [self judgeRightAndLeftIsSame:self.allDataArray];
    }else{
        
        NSInteger index=self.topCollectionView.contentOffset.x/MDScreenW;
        
        switch (index) {
            case 0:
            {
                MDHalfMounthVC* halfMounthVC=(MDHalfMounthVC*)self.childViewControllers[0];
                
                if (halfMounthVC.isRefresh==NO) {
                    for (MDMatainModel* model in halfMounthVC.dataArray) {
                        model.rightTag=1;
                    }
                    halfMounthVC.isRefresh=YES;
                    [self.boomViewButtonArray[1] setTitle:@"反全选" forState:UIControlStateNormal];
                }else{
                    for (MDMatainModel* model in halfMounthVC.dataArray) {
                        model.rightTag=0;
                    }
                    halfMounthVC.isRefresh=NO;
                    [self.boomViewButtonArray[1] setTitle:@"全选" forState:UIControlStateNormal];
                }
            }
                break;
            case 1:
            {
                MDQuarterVC* quarterVC=(MDQuarterVC*)self.childViewControllers[1];
                
                if (quarterVC.isRefresh==NO) {
                    for (MDMatainModel* model in quarterVC.dataArray) {
                        model.rightTag=1;
                    }
                    quarterVC.isRefresh=YES;
                    [self.boomViewButtonArray[1] setTitle:@"反全选" forState:UIControlStateNormal];
                }else{
                    for (MDMatainModel* model in quarterVC.dataArray) {
                        model.rightTag=0;
                    }
                    quarterVC.isRefresh=NO;
                    [self.boomViewButtonArray[1] setTitle:@"全选" forState:UIControlStateNormal];
                }
            }
                break;
            case 2:
            {
                MDHalfYearVC* halfYearVC=(MDHalfYearVC*)self.childViewControllers[2];
                if (halfYearVC.isRefresh==NO) {
                    for (MDMatainModel* model in halfYearVC.dataArray) {
                        model.rightTag=1;
                    }
                    halfYearVC.isRefresh=YES;
                    [self.boomViewButtonArray[1] setTitle:@"反全选" forState:UIControlStateNormal];
                }else{
                    for (MDMatainModel* model in halfYearVC.dataArray) {
                        model.rightTag=0;
                    }
                    halfYearVC.isRefresh=NO;
                    [self.boomViewButtonArray[1] setTitle:@"全选" forState:UIControlStateNormal];
                }
            }
                break;
            case 3:
            {
                MDYearVC* yearVC=(MDYearVC*)self.childViewControllers[3];
                if (yearVC.isRefresh==NO) {
                    for (MDMatainModel* model in yearVC.dataArray) {
                        model.rightTag=1;
                    }
                    yearVC.isRefresh=YES;
                    [self.boomViewButtonArray[1] setTitle:@"反全选" forState:UIControlStateNormal];
                }else{
                    for (MDMatainModel* model in yearVC.dataArray) {
                        model.rightTag=0;
                    }
                    yearVC.isRefresh=NO;
                    [self.boomViewButtonArray[1] setTitle:@"全选" forState:UIControlStateNormal];
                }
            }
                break;
            default:
                break;
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index=scrollView.contentOffset.x/MDScreenW;
    switch (index) {
        case 0:
        {
            MDHalfMounthVC* halfMounthVC=(MDHalfMounthVC*)self.childViewControllers[0];
            
            if (halfMounthVC.isRefresh==NO) {
                [self.boomViewButtonArray[1] setTitle:@"全选" forState:UIControlStateNormal];
            }else{
                [self.boomViewButtonArray[1] setTitle:@"反全选" forState:UIControlStateNormal];
            }
        }
            break;
        case 1:
        {
            MDQuarterVC* quarterVC=(MDQuarterVC*)self.childViewControllers[1];
            
            if (quarterVC.isRefresh==NO) {
                [self.boomViewButtonArray[1] setTitle:@"全选" forState:UIControlStateNormal];
            }else{
                [self.boomViewButtonArray[1] setTitle:@"反全选" forState:UIControlStateNormal];
            }
        }
            break;
        case 2:
        {
            MDHalfYearVC* halfYearVC=(MDHalfYearVC*)self.childViewControllers[2];
            if (halfYearVC.isRefresh==NO) {
                [self.boomViewButtonArray[1] setTitle:@"全选" forState:UIControlStateNormal];
            }else{
                [self.boomViewButtonArray[1] setTitle:@"反全选" forState:UIControlStateNormal];
            }
        }
            break;
        case 3:
        {
            MDYearVC* yearVC=(MDYearVC*)self.childViewControllers[3];
            if (yearVC.isRefresh==NO) {
                [self.boomViewButtonArray[1] setTitle:@"全选" forState:UIControlStateNormal];
            }else{
                [self.boomViewButtonArray[1] setTitle:@"反全选" forState:UIControlStateNormal];
            }
        }
            break;
        default:
            break;
    }
}


@end
