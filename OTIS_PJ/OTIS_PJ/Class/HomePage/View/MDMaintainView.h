//
//  MDMaintainView.h
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/15.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MDMaintainView;
@class MDMatainModel;
@protocol MDMaintainViewDelegate <NSObject>

@required

-(NSInteger)maintainView:(MDMaintainView*)maintainView;
-(MDMatainModel*)maintainView:(MDMaintainView*)maintainView index:(NSInteger)row;
-(CGFloat)maintainView:(MDMaintainView*)maintainView indexHeight:(NSInteger)row;
@end

@interface MDMaintainView : UIView
@property(nonatomic,weak) UITableView* table;
@property(nonatomic,weak) id<MDMaintainViewDelegate>delegate;
@end
