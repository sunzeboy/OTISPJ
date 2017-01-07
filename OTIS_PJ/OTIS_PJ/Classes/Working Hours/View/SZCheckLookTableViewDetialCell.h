//
//  SZCheckLookTableViewDetialCell.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTable_LaborHours.h"

@interface SZCheckLookTableViewDetialCell : UITableViewCell

@property (nonatomic , strong) SZLaborHoursItem *item;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (copy, nonatomic) void (^didClickedTFBlock)(UITextField*) ;
@property (copy, nonatomic) void (^didDeleteClick)(SZLaborHoursItem *item) ;


+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
