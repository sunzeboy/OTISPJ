//
//  SZCheckLookTableViewCell.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/21.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZCheckLookModel.h"
@interface SZCheckLookTableViewCell : UITableViewCell

@property (nonatomic , strong) SZCheckLookModel *model;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
