//
//  TodayViewController.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/20.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZFinalMaintenanceUnitItem.h"

@protocol  TodayDelegate
-(void) ZhiFuBaoStyle;
@end

@interface TodayViewController : SZTableViewController

@property (nonatomic, strong) NSArray *maintain;
@property (nonatomic, weak) id<TodayDelegate> delegate;

@property (nonatomic , assign) BOOL isHidden;

-(SZFinalMaintenanceUnitItem *)isExistenceWithQRCode:(SZQRCodeProcotolitem *)item;
@end
