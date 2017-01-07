//
//  SZCustomTipView.h
//  aosima
//
//  Created by sunze on 2016/10/28.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <MMPopupView/MMPopupView.h>

@interface SZCustomTipView : MMPopupView

@property (copy, nonatomic) void (^btnClickBlock)() ;

@end
