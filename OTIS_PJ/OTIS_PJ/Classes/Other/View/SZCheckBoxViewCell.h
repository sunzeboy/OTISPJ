//
//  SZCheckBoxViewCell.h
//  OTIS_PJ
//
//  Created by zy on 16/5/5.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SZJHATitleItem;
@interface SZCheckBoxViewCell : UITableViewCell

@property (nonatomic,strong) SZJHATitleItem *jobHazard;
@property(nonatomic,assign)NSInteger cellCount;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UITextField *textField;

+(instancetype)cellWithTableView:(UITableView *)tableView;

- (IBAction)btnClick:(UIButton *)sender ;


@property(nonatomic,strong)NSArray* dataArray;
@property(nonatomic,strong)NSMutableArray* cellSelectedArray;
@property(nonatomic,copy)void(^editBlock)();
@property(nonatomic,copy)void(^endEditBlock)();
@property(nonatomic,copy)void(^updateTableviewBlock)();

@end
