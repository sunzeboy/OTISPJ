//
//  SZScanErrorViewController.h
//  OTIS_PJ
//
//  Created by zhangyang on 16/6/3.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZScanErrorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *elevatorNo;

@property (weak, nonatomic) IBOutlet UILabel *planDate;

@property (weak, nonatomic) IBOutlet UILabel *rCode;

@property (weak, nonatomic) IBOutlet UILabel *tip;

@property (weak, nonatomic) IBOutlet UILabel *tip2;

@property (nonatomic , copy) NSString *code;

/**
 */
@property (nonatomic , copy) NSString *tips;

@property (nonatomic , copy) NSString *tips2;

@property (nonatomic , copy) NSString *planDateStr;

@end
