//
//  SZSelectViewController.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/24.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTableViewController.h"

@interface SZSelectViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic , strong) SZJHATitleItem *item;
/**
 *  所有的数据
 */
@property (nonatomic, strong) NSArray *titleArray;

/**
 *  选中的
 */
@property (nonatomic, strong) NSArray *selectedtitleArray;

@end
