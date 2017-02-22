//
//  MDMaintainVC.h
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/9.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import "MDBaseVC.h"
@class MDMaintainButton;
@interface MDMaintainVC : MDBaseVC
-(instancetype)initWithTitleArray:(NSArray*)titleArray boomViewButtonArray:(NSArray*)boomTitleArray;
@property(nonatomic,strong) NSArray* titleArray;
@property(nonatomic,strong) NSArray* boomTitleArray;
@property(nonatomic,weak) UIView* lineView;
@property(nonatomic,weak) UIView* topBackView;
@property(nonatomic,weak) UICollectionView* topCollectionView;

@property(assign,nonatomic) CGFloat topHeigtht;
@property(assign,nonatomic) CGFloat booViewHeight;

@property(nonatomic,strong) NSMutableArray<MDMaintainButton*>* boomViewButtonArray;



@end
