//
//  SZAnnualInspectionTableViewCell.h
//  OTIS_PJ
//
//  Created by jQ on 16/5/9.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZFinalMaintenanceUnitItem.h"

@interface SZAnnualInspectionTableViewCell : UITableViewCell
@property(weak,nonatomic)SZFinalMaintenanceUnitItem *szannual;

@property (weak, nonatomic) IBOutlet UILabel *overDate;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
