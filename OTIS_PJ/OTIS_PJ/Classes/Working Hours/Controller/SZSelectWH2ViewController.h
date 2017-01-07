//
//  SZPlain2ViewController.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZSelectWH2ViewController : UIViewController

@property (nonatomic, strong) NSArray *records;

@property (nonatomic, strong) NSString *subTitle;

@property (copy, nonatomic) void (^confirmActBlock)(NSArray *selectedArray) ;

@end
