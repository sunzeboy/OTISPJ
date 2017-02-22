//
//  MDBoomView.m
//  OTIS_PJ
//
//  Created by 杜亚伟 on 2017/2/22.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

#import "MDBoomView.h"
#import "Masonry.h"
#import "MDBaseButton.h"
@interface MDBoomView ()

@property(nonatomic,strong) NSArray<NSString*>* boomTitleArray;
@property(nonatomic,strong) NSArray<NSString*>* imageNameArray;

@end

@implementation MDBoomView

-(NSMutableArray*)boomViewButtonArray{
    if (!_boomViewButtonArray) {
        _boomViewButtonArray=[NSMutableArray array];
    }
    return _boomViewButtonArray;
}

-(instancetype)initWithBoomTitleArray:(NSArray*)boomTitleArray imageArray:(NSArray*)imageNameArray{
    
    if (self=[super init]) {
        self.boomTitleArray=boomTitleArray;
        self.imageNameArray=imageNameArray;
        [self setSubviews];
    }
    return self;
}

-(void)setSubviews{
    
    UIView* lineView=[[UIView alloc] init];
    lineView.backgroundColor=MDDescriptionColor;
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(0.5);
    }];
    CGFloat buttonW=MDScreenW/self.boomTitleArray.count;
    
    for (int i =0; i<self.boomTitleArray.count; i++) {
        UIImage* image = [UIImage imageNamed:self.imageNameArray[i]];
        MDMaintainButton* button=[[MDMaintainButton alloc] init];
        button.titleLabel.font=[UIFont systemFontOfSize:13.0];
        button.imageView.contentMode=UIViewContentModeScaleAspectFit;
        button.titleLabel.textAlignment=NSTextAlignmentCenter;
        [button setImage:image forState:UIControlStateNormal];
        [button setTitle:self.boomTitleArray[i] forState:UIControlStateNormal];

        button.tag=i+10;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self addSubview:button];
        [self.boomViewButtonArray addObject:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).with.offset(0);
            make.left.equalTo(self.mas_left).with.offset(buttonW*i);
            make.size.mas_equalTo(CGSizeMake(buttonW, 50));
        }];
    }
}

-(void)buttonClick:(MDMaintainButton*)button{
    
    if (self.buttonClickBlock) {
        self.buttonClickBlock(button.tag);
    }
    
}

@end
