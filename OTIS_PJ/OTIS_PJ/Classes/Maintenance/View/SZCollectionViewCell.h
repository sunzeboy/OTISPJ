//
//  SZCollectionViewCell.h
//  OTIS_PJ
//
//  Created by 杜亚伟 on 16/8/8.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SZJHATitleItem;
@interface SZCollectionViewCell : UICollectionViewCell

@property(nonatomic,weak)UIButton* checkImageView;
@property(nonatomic,weak)UILabel* label;
@property(nonatomic,weak)UITextField* textField;

@property(nonatomic,strong)SZJHATitleItem* jobItem;
@end
