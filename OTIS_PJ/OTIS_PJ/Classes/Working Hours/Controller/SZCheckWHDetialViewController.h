//
//  SZCheckWHDetialViewController.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZCheckLookModel.h"
#import "KMDatePicker.h"

@interface SZCheckWHDetialViewController : UIViewController<KMDatePickerDelegate>

@property (nonatomic , strong) SZCheckLookModel *model;


@end
