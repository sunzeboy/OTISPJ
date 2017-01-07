//
//  NotCompletedViewController.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/21.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZFinalMaintenanceUnitItem.h"

@protocol  NotCompletedDelegate
-(void) ZhiFuBaoStyle;
@end

@interface NotCompletedViewController : SZTableViewController
@property (nonatomic, strong) NSArray *maintain;
@property (nonatomic, weak) id<NotCompletedDelegate> delegate;
@property (nonatomic , assign) BOOL isHidden;

-(SZFinalMaintenanceUnitItem *)isExistenceWithQRCode:(SZQRCodeProcotolitem *)item;
@end
