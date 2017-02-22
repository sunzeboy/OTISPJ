//
//  MDBoomView.h
//  OTIS_PJ
//
//  Created by 杜亚伟 on 2017/2/22.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MDMaintainButton;
@interface MDBoomView : UIView
@property(nonatomic,strong) NSMutableArray<MDMaintainButton*>* boomViewButtonArray;


@property(nonatomic,strong) void(^buttonClickBlock)(NSInteger index);

-(instancetype)initWithBoomTitleArray:(NSArray*)boomTitleArray imageArray:(NSArray*)imageNameArray;
@end
