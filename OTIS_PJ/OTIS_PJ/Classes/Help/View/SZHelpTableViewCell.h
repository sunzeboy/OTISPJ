//
//  SZHelpTableViewCell.h
//  OTIS_PJ
//
//  Created by jQ on 16/5/11.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZhelp.h"

@interface SZHelpTableViewCell : UITableViewCell
@property(weak,nonatomic)SZHelp *szhelp;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
