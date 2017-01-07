//
//  SZLoginViewController.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTextField.h"


@interface SZLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet SZTextField *userNameTF;

@property (weak, nonatomic) IBOutlet SZTextField *passWordTF;

@end
