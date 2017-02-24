//
//  SZMaintenanceOperationTableViewCell.h
//  OTIS_PJ
//
//  Created by zy on 16/5/5.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SZMaintenanceCheckItem;

typedef NS_ENUM(NSInteger,OTISOperationateType){
    OTISOperationateType0 = 0,//勾
    OTISOperationateType1 = 1,//X
    OTISOperationateType2 = 2,//圈
    OTISOperationateType3 = 3,//禁止
    OTISOperationateType4 = 4,//
    OTISOperationateType5 = 99,//禁止

};

@interface SZMaintenanceOperationTableViewCell : UITableViewCell

@property (nonatomic , assign) BOOL isFixMode;

@property (weak, nonatomic) IBOutlet UIButton *operationBtn;

@property (nonatomic,strong) SZMaintenanceCheckItem *maintenanceOperation;

+(instancetype)cellWithTableView:(UITableView *)tableView;

- (IBAction)operationAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *automButton;

@end
