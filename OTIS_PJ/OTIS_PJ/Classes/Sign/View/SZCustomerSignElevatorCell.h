//
//  SZCustomerSignElevatorCell.h
//  OTIS_PJ
//
//  Created by jQ on 16/5/4.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZCustomerSignElevatorItem.h"

@interface SZCustomerSignElevatorCell : UITableViewCell
@property(weak,nonatomic) SZCustomerSignElevatorItem *szCustomerSignElevatorItem;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
