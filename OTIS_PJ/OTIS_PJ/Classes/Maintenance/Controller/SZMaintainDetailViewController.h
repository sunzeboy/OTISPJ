//
//  SZMaintainDetailViewController.h
//  OTIS_PJ
//
//  Created by zy on 16/5/4.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZMaintainDetailViewController : UIViewController

//0-扫描过 1-无二维码 5-无法识别二维码  6-工时分摊

@property (nonatomic , assign) NSInteger scheduleID;

@property (nonatomic , assign) BOOL isWorkingHours;

@property (nonatomic , copy) NSString *rCode;

@property (nonatomic , assign) BOOL isfentan;

@property (nonatomic , copy) NSString *unitNostr;

@property (nonatomic , assign) BOOL isDirectEntry;

@property (nonatomic , assign) BOOL isFixMode;




- (instancetype)initWithBarcodeType:(NSString *)barcodeType;

@end
