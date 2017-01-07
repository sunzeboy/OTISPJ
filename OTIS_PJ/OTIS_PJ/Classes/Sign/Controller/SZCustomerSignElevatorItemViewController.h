//
//  SZCustomerSignElevatorItemViewController.h
//  OTIS_PJ
//
//  Created by jQ on 16/5/4.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZPageViewController.h"

@interface SZCustomerSignElevatorItemViewController : SZPageViewController

@property(strong,nonatomic) NSMutableArray *signArray;

- (instancetype)initWithNSArray:(NSArray *)array index:(NSInteger )index;
@end
