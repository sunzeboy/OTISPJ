//
//  MDBaseCell.m
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/9.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import "MDBaseCell.h"
#import "Masonry.h"
#import "MDBaseButton.h"
#import "MDMatainModel.h"
#import "MDLiftModel.h"
@implementation MDBaseCell
-(instancetype)initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        [self setSubviews];
    }
    return self;
}

-(void)setSubviews{

    UIImageView* backImageView=[[UIImageView alloc] init];
    backImageView.contentMode=UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:backImageView];
    self.backImageView=backImageView;

    UIEdgeInsets padding=UIEdgeInsetsMake(0, 0, 0, 0);
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(padding);
    }];
}

@end


@implementation MDHomeBoomCell

-(instancetype)initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        [self setSubUI];
    }
    return self;
}

-(void)setSubUI{

    MDBaseButton* button=[[MDBaseButton alloc] init];
    button.enabled=NO;
    button.titleLabel.textAlignment=NSTextAlignmentCenter;
    button.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"Maintain" forState:UIControlStateNormal];
    [self.contentView addSubview:button];
    self.button=button;

    UIEdgeInsets padding=UIEdgeInsetsMake(10, 10, 10, 10);
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(padding);
    }];
}

@end



static CGFloat TitleFont =16.0;
static CGFloat SubTitleFont =15.0;

@implementation MDMaintainTodayCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSubviews];
    }
    return self;
}

-(void)setSubviews{
    
    UIImageView* leftImageView=[[UIImageView alloc] init];
    leftImageView.contentMode=UIViewContentModeScaleAspectFit;
    leftImageView.image=[UIImage imageNamed:@"oes图标1-4"];
    [self.contentView addSubview:leftImageView];
    self.leftImageView=leftImageView;
    
    UILabel* titleLabel=[[UILabel alloc] init];
    titleLabel.font=[UIFont systemFontOfSize:TitleFont];
    titleLabel.text=@"BDMMD555NM";
    [self.contentView addSubview:titleLabel];
    self.titleLabel=titleLabel;
    
    UILabel* dateLabel=[[UILabel alloc] init];
    dateLabel.textColor=MDColor(37, 63, 96, 1.0);
    dateLabel.font=[UIFont systemFontOfSize:SubTitleFont];
    dateLabel.text=@"2016-12-20";
    dateLabel.textAlignment=NSTextAlignmentRight;
    [self.contentView addSubview:dateLabel];
    self.dateLabel=dateLabel;
    
    UILabel* subLabel=[[UILabel alloc] init];
    subLabel.textColor=MDColor(37, 63, 96, 1.0);
    subLabel.font=[UIFont systemFontOfSize:SubTitleFont];
    subLabel.text=@"Otis Electric Elevator Co., Ltd";
    [subLabel sizeToFit];
    subLabel.numberOfLines=0;
    [self.contentView addSubview:subLabel];
    self.subLabel=subLabel;
    
    UILabel* subLabel2=[[UILabel alloc] init];
    subLabel2.textColor=MDColor(37, 63, 96, 1.0);
    subLabel2.font=[UIFont systemFontOfSize:SubTitleFont];
    subLabel2.text=@"2619-B-05-2/1";
    [self.contentView addSubview:subLabel2];
    self.subLabel2=subLabel2;
    
    UIImageView* rightImageView=[[UIImageView alloc] init];
    rightImageView.contentMode=UIViewContentModeScaleAspectFit;
    rightImageView.image=[UIImage imageNamed:@"MainUp"];
    [self.contentView addSubview:rightImageView];
    
    UILabel* subLabel3=[[UILabel alloc] init];
    subLabel3.textColor=MDColor(37, 63, 96, 1.0);
    subLabel3.textAlignment=NSTextAlignmentRight;
    subLabel3.font=[UIFont systemFontOfSize:SubTitleFont];
    subLabel3.text=@"December";
    [self.contentView addSubview:subLabel3];
    self.subLabel3=subLabel3;
    
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY).with.offset(0);
        make.left.equalTo(self.contentView.mas_left).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImageView.mas_right).with.offset(15);
        make.top.equalTo(self.contentView.mas_top).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(150, 20));
    }];
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_top).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_left).with.offset(0);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(5);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    [subLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_left).with.offset(0);
        make.top.equalTo(subLabel.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(120, 20));
    }];
    
    
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.centerY.equalTo(subLabel2.mas_centerY).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [subLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightImageView.mas_left).with.offset(-3);
        make.top.equalTo(subLabel2.mas_top).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
}


-(void)setModel:(MDLiftModel *)model{
    _model=model;
    
    self.titleLabel.text=model.liftNo;
    self.subLabel.text=model.address;
    self.subLabel2.text=model.number;
    self.subLabel3.text=model.mounth;
    self.dateLabel.text=model.dateStr;
}

@end

static CGFloat titleFont=15.0;

@interface MDMatainBaseCell ()



@end

@implementation MDMatainBaseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setSubviews];
    }
    return self;
}


-(void)setSubviews{
    
    UILabel* titleLabel=[[UILabel alloc] init];
    titleLabel.text=@"A-3_13";
    titleLabel.font=[UIFont systemFontOfSize:16.0];
    [titleLabel sizeToFit];
    titleLabel.numberOfLines=0;
    [self.contentView addSubview:titleLabel];
    self.titleLabel=titleLabel;
    
    UILabel* subLabel1=[[UILabel alloc] init];
    subLabel1.font=[UIFont systemFontOfSize:titleFont];
    subLabel1.text=@"看风景的快乐封疆大吏分肯德基疯狂的";
    [subLabel1 sizeToFit];
    subLabel1.numberOfLines=0;
    [self.contentView addSubview:subLabel1];
    self.subLabel1=subLabel1;
    
    UILabel* subLabel2=[[UILabel alloc] init];
    subLabel2.textColor=MDColor(28, 60, 93, 1.0);
    subLabel2.font=[UIFont systemFontOfSize:titleFont];
    subLabel2.text=@"都快放假快点解放了大家疯狂的风景的快乐附近的";
    [subLabel2 sizeToFit];
    subLabel2.numberOfLines=0;
    [self.contentView addSubview:subLabel2];
    self.subLabel2=subLabel2;
    
    UIButton* button1=[[UIButton alloc] init];
    button1.layer.borderWidth=1.0;
    button1.layer.borderColor=[UIColor blackColor].CGColor;
    button1.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [button1 addTarget:self action:@selector(button1Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button1];
    self.button1=button1;
    
    NSString* isAutomatickey=[[NSUserDefaults standardUserDefaults] objectForKey:IsAutomatickey];
   
    UIButton* button2=[[UIButton alloc] init];
    button2.layer.borderWidth=1.0;
    button2.layer.borderColor=[UIColor blackColor].CGColor;
    button2.imageView.contentMode=UIViewContentModeScaleAspectFit;
    button2.enabled=NO;
    [self.contentView addSubview:button2];
    self.button2=button2;
    if (isAutomatickey==nil||[isAutomatickey isEqualToString:@"0"]) {
        button2.hidden=YES;
    }else{
        button2.hidden=NO;
    }
    
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(-5);
        make.centerY.equalTo(self.contentView.mas_centerY).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(button1.mas_left).with.offset(-10);
        make.centerY.equalTo(self.contentView.mas_centerY).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(5);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [subLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_top).with.offset(0);
        make.left.equalTo(titleLabel.mas_right).with.offset(-5);
        make.right.equalTo(button2.mas_left).with.offset(-5);
    }];
    
    [subLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subLabel1.mas_bottom).with.offset(5);
        make.left.equalTo(titleLabel.mas_left).with.offset(0);
        make.right.equalTo(button2.mas_left).with.offset(-5);
    }];
}

-(void)button1Click:(UIButton*)button{
    
    if (self.model.rightTag>=4) {
        self.model.rightTag=0;
    }else{
        self.model.rightTag+=1;
    }
    
    switch (self.model.rightTag) {
        case 0:
        {
            [self.button1 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            [self.button1 setImage:[UIImage imageNamed:@"OK"] forState:UIControlStateNormal];
            
        }
            break;
        case 2:
        {
            [self.button1 setImage:[UIImage imageNamed:@"NeedChangeParts"] forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            [self.button1 setImage:[UIImage imageNamed:@"End"] forState:UIControlStateNormal];
        }
            break;
        case 4:
        {
            [self.button1 setImage:[UIImage imageNamed:@"NoThisItem"] forState:UIControlStateNormal];
            
        }
            break;
        default:
            break;
    }
}


-(void)setModel:(MDMatainModel *)model{
    _model=model;
    self.titleLabel.text=model.title;
    self.subLabel1.text=model.subTitle;
    self.subLabel2.text=model.content;
    if (model.isHiden) {
        self.button2.hidden=YES;
    }else{
        self.button2.hidden=NO;
    }
    
    switch (model.leftTag) {
        case 1:
        {
            [self.button2 setImage:[UIImage imageNamed:@"OK"] forState:UIControlStateDisabled];
        }
            break;
        case 2:
        {
            [self.button2 setImage:[UIImage imageNamed:@"NeedChangeParts"] forState:UIControlStateDisabled];
        }
            break;
//        case 2:
//        {
//            [self.button2 setImage:[UIImage imageNamed:@"End"] forState:UIControlStateDisabled];
//        }
//            break;
//        case 3:
//        {
//            [self.button2 setImage:[UIImage imageNamed:@"NoThisItem"] forState:UIControlStateDisabled];
//        }
//            break;
        default:
            break;
    }
    
    switch (self.model.rightTag) {
        case 0:
        {
            [self.button1 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            [self.button1 setImage:[UIImage imageNamed:@"OK"] forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [self.button1 setImage:[UIImage imageNamed:@"NeedChangeParts"] forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            [self.button1 setImage:[UIImage imageNamed:@"End"] forState:UIControlStateNormal];
        }
            break;
        case 4:
        {
            [self.button1 setImage:[UIImage imageNamed:@"NoThisItem"] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }

}
@end
