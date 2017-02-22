//
//  MDMaintainLiftView.h
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/15.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MDMaintainLiftView;
@class MDLiftModel;
@protocol MDMaintainLiftViewDelegate <NSObject>

@required

-(NSInteger)maintainLiftView:(MDMaintainLiftView*)maintainView;
-(MDLiftModel*)maintainLiftView:(MDMaintainLiftView*)maintainView index:(NSInteger)row;
//-(CGFloat)maintainLiftView:(MDMaintainLiftView*)maintainView indexHeight:(NSInteger)row;
@end

@interface MDMaintainLiftView : UIView

@property(nonatomic,weak) UITableView* table;
@property(nonatomic,weak) id<MDMaintainLiftViewDelegate>delegate;

@end
