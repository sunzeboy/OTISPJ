//
//  SZTableViewCell.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/21.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SZFinalMaintenanceUnitItem;
@interface SZTableViewCell : UITableViewCell
@property (nonatomic,strong) SZFinalMaintenanceUnitItem *maintain;
@property (weak, nonatomic) IBOutlet UIImageView *fixXXX;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
