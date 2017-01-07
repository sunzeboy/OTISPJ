//
//  SZCustomerSignViewController.h
//  OTIS_PJ
//
//  Created by jQ on 16/5/6.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZCustomerSignDetail.h"
#import "SZCustomerSignView.h"
#import "SZSignatureBoardViewController.h"
#import "SZFinalMaintenanceUnitItem.h"

@interface SZCustomerSignViewController : UIViewController<signDelegate,signDetailDelegate>

@property(strong,nonatomic)SZFinalMaintenanceUnitItem *item;

@property(copy,nonatomic)NSString *signComment;

@property(strong,nonatomic) NSMutableArray *signArray;
@property(strong,nonatomic)NSMutableArray *signCommentArray;


- (instancetype)initWithNSArray:(NSArray *)array;
@end
