//
//  SZMaintenanceCommentsViewController.h
//  OTIS_PJ
//
//  Created by zy on 16/5/6.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTableViewController.h"

@interface SZMaintenanceCommentsViewController : UIViewController

@property (nonatomic , strong) UIButton *needReplaceBtn;
@property (nonatomic , strong) UIButton *needReformeBtn;
@property (nonatomic , strong) UITextView *commentText;

@property (nonatomic , assign) int scheadleId;

@end
