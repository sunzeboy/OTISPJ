//
//  MDMatainModel.h
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/15.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDMatainModel : NSObject

@property (nonatomic,copy) NSString * title;

@property (nonatomic,copy) NSString* subTitle;

@property (nonatomic,copy) NSString* content;

@property(nonatomic,assign) CGFloat rowHeight;

@property(assign,nonatomic) NSInteger leftTag;

@property(assign,nonatomic) NSInteger rightTag;

@property(nonatomic,assign) BOOL isHiden;

@property(nonatomic,assign) BOOL isSave;

@property(nonatomic,assign) BOOL isChange;

@end
