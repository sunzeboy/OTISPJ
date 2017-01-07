//
//  HDButton.h
//  map
//
//  Created by 智富360 on 16/1/6.
//  Copyright © 2016年 智富360. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SZButton : UIView


@property (nonatomic , strong) UILabel *badge;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (copy, nonatomic) void (^btnClickBlock)(UIButton *sender) ;

@end
