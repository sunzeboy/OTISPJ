//
//  SZSignTableViewCell.h
//  OTIS_PJ
//
//  Created by ousingi on 16/4/27.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZFinalMaintenanceUnitItem.h"

@protocol  signViewDelegate
-(void) calcSelected;
-(BOOL) selectCheak:(SZFinalMaintenanceUnitItem *)item;
@end
@interface SZSignTableViewCell : UITableViewCell

@property(weak,nonatomic)SZFinalMaintenanceUnitItem *szsign;
@property (weak, nonatomic) IBOutlet UIButton *signView;

+(instancetype)cellWithTableView:(UITableView *)tableView;
- (IBAction)btnClick:(UIButton *)sender;
@property(nonatomic,weak) id<signViewDelegate>delegate;
@end
