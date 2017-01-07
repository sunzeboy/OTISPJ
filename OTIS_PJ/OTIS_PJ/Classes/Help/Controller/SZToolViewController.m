//
//  SZToolViewController.m
//  OTIS_PJ
//
//  Created by jQ on 16/5/11.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZToolViewController.h"
#import "SZToolListChildViewController.h"

@interface SZToolViewController ()
@end

@implementation SZToolViewController

- (BOOL)shouldAutorotate{
    
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SZLocal(@"title.toolList");
    //
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//添加子滚动条目
-(void)setupChildVces
{
    //must
    SZToolListChildViewController * toolListMust= [[SZToolListChildViewController alloc] init];
    toolListMust.title = SZLocal(@"title.helpMenu.toolListMust");
    toolListMust.index = 0;
    [self addChildViewController:toolListMust];
    //GeneralTools
    SZToolListChildViewController * generalTools= [[SZToolListChildViewController alloc] init];
    generalTools.title = SZLocal(@"title.helpMenu.generalTools");
    generalTools.index = 1;
    [self addChildViewController:generalTools];
    //privateHelicopterEscape
    SZToolListChildViewController * privateHelicopterEscape= [[SZToolListChildViewController alloc] init];
    privateHelicopterEscape.title = SZLocal(@"title.helpMenu.privateHelicopterEscape");
    privateHelicopterEscape.index = 2;
    [self addChildViewController:privateHelicopterEscape];
    //privateEscalatorsAndWalkways
    SZToolListChildViewController * privateEscalatorsAndWalkways= [[SZToolListChildViewController alloc] init];
    privateEscalatorsAndWalkways.title = SZLocal(@"title.helpMenu.privateEscalatorsAndWalkways");
    privateEscalatorsAndWalkways.index = 3;
    [self addChildViewController:privateEscalatorsAndWalkways];
    //unusually
    SZToolListChildViewController * unusuallyTool= [[SZToolListChildViewController alloc] init];
    unusuallyTool.title = SZLocal(@"title.helpMenu.unusually");
    unusuallyTool.index = 4;
    [self addChildViewController:unusuallyTool];
}

@end
