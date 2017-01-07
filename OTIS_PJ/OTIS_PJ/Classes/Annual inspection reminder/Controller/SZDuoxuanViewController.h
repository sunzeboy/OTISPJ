//
//  SZDuoxuanViewController.h
//  OTIS_PJ
//
//  Created by sunze on 16/7/21.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZDuoxuanViewController : UIViewController

@property (copy, nonatomic) void (^confirmActBlock)() ;

@property(strong,nonatomic) NSMutableArray *arraySelected;


@end
