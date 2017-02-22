//
//  MDCustomAlertView.h
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/16.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomTextView;
@interface MDCustomAlertView : UIView

@property(nonatomic,weak) CustomTextView* textView;


@property(nonatomic,strong) void(^jumpBlcok)();

@property(nonatomic,strong) void(^cancleBlcok)();


@end
