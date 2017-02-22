//
//  MDCoverView.h
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/16.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDCoverView : UIView
@property(nonatomic,strong) NSMutableArray<NSString*>* dataArray;

@property(nonatomic,weak) UITableView* table;
@end
