//
//  TwoWeeksViewController.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/20.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZFinalMaintenanceUnitItem.h"

@protocol TwoWeeksDelegate
-(void) ZhiFuBaoStyle;
@end

@interface TwoWeeksViewController : SZTableViewController
@property (nonatomic, strong) NSArray *maintain;
@property (nonatomic, weak) id<TwoWeeksDelegate> delegate;
@property (nonatomic , assign) BOOL isHidden;

-(SZFinalMaintenanceUnitItem *)isExistenceWithQRCode:(SZQRCodeProcotolitem *)item;

@end
