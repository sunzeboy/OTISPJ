//
//  SZTableViewController.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/21.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZJHATitleItem.h"
#import "SubLBXScanViewController.h"

@interface SZTableViewController : UITableViewController

@property (nonatomic , strong) UISearchBar *bar;

@property (nonatomic , strong) NSMutableArray *dataArray;

@property (nonatomic , assign) BOOL hasData;

@property (nonatomic , assign) BOOL allSelect;
@property (nonatomic , assign) BOOL weixuan;
@property (nonatomic , assign) int  unCompleteCount;


-(void)initToolBar;

@end
