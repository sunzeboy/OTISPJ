//
//  SZWorkingHoursBigCell.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/16.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZLabor.h"

@interface SZWorkingHoursBigCell : UITableViewCell


@property (copy, nonatomic) void (^didClickedTFBlock)(UITextField *tf) ;

@property (copy, nonatomic) void (^deleteBlock)(SZLabor*labor) ;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (nonatomic,strong) SZLabor *labor;


+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
