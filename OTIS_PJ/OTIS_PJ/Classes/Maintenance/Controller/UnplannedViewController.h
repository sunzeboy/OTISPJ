//
//  UnplannedViewController.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/20.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZFinalMaintenanceUnitItem.h"
@protocol UnplannedViewControllerDelegate
-(void) ZhiFuBaoStyle;
@end
@interface UnplannedViewController : SZTableViewController

@property (nonatomic, strong) NSArray *maintain;
@property (nonatomic , assign) BOOL isWorkingHours;
@property (nonatomic , assign) BOOL isHidden;
@property (nonatomic, weak) id<UnplannedViewControllerDelegate> delegate;


-(SZFinalMaintenanceUnitItem *)isExistenceWithQRCode:(SZQRCodeProcotolitem *)item;

@end
