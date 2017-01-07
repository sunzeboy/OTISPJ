//
//  SZWorkingHoursPUIllCell.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/28.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZLabor.h"

@interface SZWorkingHoursPUIllCell : UITableViewCell

@property (copy, nonatomic) void (^didClickedTFBlock)(UITextField *tf) ;

@property (copy, nonatomic) void (^deleteBlock)(SZLabor*labor) ;


@property (nonatomic,strong) SZLabor *labor;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
