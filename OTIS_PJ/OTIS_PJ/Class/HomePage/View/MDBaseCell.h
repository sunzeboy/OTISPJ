//
//  MDBaseCell.h
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/9.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MDMatainModel;
@class MDBaseButton;
@interface MDBaseCell : UICollectionViewCell

@property(nonatomic,weak) UIImageView* backImageView;

@end


@interface MDHomeBoomCell : MDBaseCell

@property(nonatomic,weak) MDBaseButton* button;

@end

@class MDLiftModel;
@interface MDMaintainTodayCell : UITableViewCell
@property(nonatomic,weak) UIImageView* leftImageView;

@property(nonatomic,weak) UILabel* titleLabel;

@property(nonatomic,weak) UILabel* dateLabel;

@property(nonatomic,weak) UILabel* subLabel;

@property(nonatomic,weak) UILabel* subLabel2;

@property(nonatomic,weak) UILabel* subLabel3;

@property(nonatomic,strong) MDLiftModel* model;
@end


@interface MDMatainBaseCell : UITableViewCell
@property(nonatomic,weak)  UILabel* titleLabel;
@property(nonatomic,weak)  UILabel* subLabel1;
@property(nonatomic,weak)  UILabel* subLabel2;
@property(nonatomic,weak)  UIButton* button1;
@property(nonatomic,weak)  UIButton* button2;

@property(nonatomic,strong) MDMatainModel* model;

@end
