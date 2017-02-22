//
//  MDMaintainVC.m
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/9.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import "MDMaintainVC.h"
#import "MDUnrealizedVC.h"
#import "MDTadayVC.h"
#import "Masonry.h"
#import "MDBaseButton.h"
#import "SGScanningQRCodeVC.h"
static NSString* const CollectionViewCellID=@"collectionViewCellID";

@interface MDMaintainVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(assign) CGFloat startX;

@property(assign) BOOL forbidTouchToAdjustPosition;

@property(assign) NSInteger startIndex;

@property(assign) NSInteger endIndex;

@property(assign) NSInteger lastIndex;

@property(nonatomic,strong) NSMutableArray* buttonArray;

@property (strong, nonatomic) NSArray *deltaRGB;
@property (strong, nonatomic) NSArray *selectedColorRgb;
@property (strong, nonatomic) NSArray *normalColorRgb;

@end

@implementation MDMaintainVC

-(void)dealloc{
    NSLog(@"delloc====%@",[self class]);
    self.deltaRGB=nil;
    self.selectedColorRgb=nil;
    self.normalColorRgb=nil;
    self.buttonArray=nil;
    self.titleArray=nil;
}

-(NSMutableArray*)boomViewButtonArray{
    if (!_boomViewButtonArray) {
        _boomViewButtonArray=[NSMutableArray array];
    }
    return _boomViewButtonArray;
}

-(NSMutableArray*)buttonArray{
    if (!_buttonArray) {
        _buttonArray=[NSMutableArray array];
    }
    return _buttonArray;
}

-(NSArray*)titleArray{
    if (!_titleArray) {
        _titleArray=[NSArray array];
    }
    return _titleArray;
}

-(instancetype)initWithTitleArray:(NSArray*)titleArray boomViewButtonArray:(NSArray*)boomTitleArray{
    if (self=[super init]) {
        self.titleArray=titleArray;
        self.boomTitleArray=boomTitleArray;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"维保";
    self.booViewHeight=60;
    [self initChildVCs];
    [self setTopViews:self.titleArray];
    [self setContentView];
    [self setBoomView];
}

-(void)setTopViews:(NSArray*)titleArray{
    self.titleArray=titleArray;
    UIView* topBackView=[[UIView alloc] init];
    topBackView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:topBackView];
    self.topBackView=topBackView;
    
    NSInteger buttonW = MDScreenW/self.titleArray.count;
    for (int i =0; i<self.titleArray.count; i++) {
        UIButton* button=[[UIButton alloc] init];
        button.tag=i;
        button.titleLabel.textAlignment=NSTextAlignmentCenter;
        button.titleLabel.font=[UIFont systemFontOfSize:15.0];
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [topBackView addSubview:button];
        
        if (i!=0) {
            [button setTitleColor:[UIColor colorWithRed:51.0/255.0 green:53.0/255.0 blue:75/255.0 alpha:1.0] forState:UIControlStateNormal];
        }else{
            [button setTitleColor:MDColor(10, 76, 153, 1.0) forState:UIControlStateNormal];
        }
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(i* buttonW);
            make.centerY.equalTo(topBackView.mas_centerY).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(buttonW, 30));
        }];
        [self.buttonArray addObject:button];
        [self.view layoutIfNeeded];
    }

    UIView* lineView=[[UIView alloc] init];
    lineView.backgroundColor=MDColor(10, 76, 153, 1.0);
    [topBackView addSubview:lineView];
    self.lineView=lineView;
    
    UIView* boomLineView=[[UIView alloc] init];
    boomLineView.backgroundColor=MDDescriptionColor;
    [topBackView addSubview:boomLineView];
    
    
    [topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.mas_equalTo(50);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topBackView.mas_bottom).with.offset(0);
        make.left.equalTo(topBackView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(buttonW, 2));
    }];
    
    [boomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(topBackView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(0.5);
    }];
}

-(void)setBoomView{
    
    UIView* boomView=[[UIView alloc] init];
    [self.view addSubview:boomView];
    
    UIView* lineView=[[UIView alloc] init];
    lineView.backgroundColor=MDDescriptionColor;
    [boomView addSubview:lineView];
    
    [boomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.mas_equalTo(self.booViewHeight);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(boomView.mas_top).with.offset(0);
        make.left.equalTo(boomView.mas_left).with.offset(0);
        make.right.equalTo(boomView.mas_right).with.offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    CGFloat buttonW=MDScreenW/self.boomTitleArray.count;
    
    for (int i =0; i<self.boomTitleArray.count; i++) {
        UIImage* image = [UIImage imageNamed:@"btn_scan"];
        MDMaintainButton* button=[[MDMaintainButton alloc] init];
        button.titleLabel.font=[UIFont systemFontOfSize:13.0];
        button.imageView.contentMode=UIViewContentModeScaleAspectFit;
        button.titleLabel.textAlignment=NSTextAlignmentCenter;
        [button setImage:image forState:UIControlStateNormal];
        [button setTitle:@"扫一扫" forState:UIControlStateNormal];
        button.tag=i+10;
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(boomViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [boomView addSubview:button];
        [self.boomViewButtonArray addObject:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(boomView.mas_centerY).with.offset(0);
            make.left.equalTo(boomView.mas_left).with.offset(buttonW*i);
            make.size.mas_equalTo(CGSizeMake(buttonW, 50));
        }];
    }
    
//    UIImage* image = [UIImage imageNamed:@"btn_scan"];
//    MDMaintainButton* button=[[MDMaintainButton alloc] init];
//    button.titleLabel.font=[UIFont systemFontOfSize:13.0];
//    button.imageView.contentMode=UIViewContentModeScaleAspectFit;
//    button.titleLabel.textAlignment=NSTextAlignmentCenter;
//    [button setImage:image forState:UIControlStateNormal];
//    [button setTitle:@"扫一扫" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(boomViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [boomView addSubview:button];
//    self.button=button;
}
-(void)setContentView{
    UICollectionViewFlowLayout* topCollectionViewFlowLayout=[[UICollectionViewFlowLayout alloc] init];
    topCollectionViewFlowLayout.itemSize=CGSizeMake(MDScreenW, MDScreenH-(64+50+self.topHeigtht+self.booViewHeight));
    topCollectionViewFlowLayout.minimumInteritemSpacing=0;
    topCollectionViewFlowLayout.minimumLineSpacing=0;
    topCollectionViewFlowLayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView* topCollectionView=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:topCollectionViewFlowLayout];
    topCollectionView.delegate=self;
    topCollectionView.dataSource=self;
    topCollectionView.bounces=NO;
    topCollectionView.pagingEnabled=YES;
    topCollectionView.showsHorizontalScrollIndicator=NO;
    topCollectionView.backgroundColor=[UIColor greenColor];
    [topCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellID];
    [self.view addSubview:topCollectionView];
    self.topCollectionView=topCollectionView;
    
    [topCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBackView.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-self.booViewHeight);
    }];
}

-(void)initChildVCs{
    
    MDTadayVC* dayVC=[[MDTadayVC alloc] init];
    [self addChildViewController:dayVC];
    
    MDUnrealizedVC* unrealizedVC=[[MDUnrealizedVC alloc] init];
    [self addChildViewController:unrealizedVC];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.childViewControllers.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell=[collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellID forIndexPath:indexPath];
    
    for (UIView* subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    UIViewController* vc=(UIViewController*)self.childViewControllers[indexPath.row];
    vc.view.frame=CGRectMake(0, 0, MDScreenW, MDScreenH-(64+50+self.topHeigtht+self.booViewHeight));
    [cell.contentView addSubview:vc.view];
    return cell;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    self.startX=scrollView.contentOffset.x;
    self.forbidTouchToAdjustPosition=NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (self.forbidTouchToAdjustPosition) return;
    
    CGFloat offSetX=scrollView.contentOffset.x;
    CGFloat tempScale=offSetX/scrollView.bounds.size.width;
    //floor(tempScale)获取X的最小数，例如3.14=3 -9.99=-10
    //progress 滑动比例
    CGFloat progress=tempScale-floor(tempScale);

    if (offSetX>self.startX) {
        
        if (progress==0.0) return;
        
        self.startIndex=(offSetX/scrollView.bounds.size.width);
        
        self.endIndex=self.startIndex+1;

        //开始的index为最后一个时特殊处理一下
        if (self.endIndex>=self.childViewControllers.count) {
            self.endIndex=self.childViewControllers.count-1;
            self.lastIndex=self.endIndex;
            return;
        }
        self.lastIndex=self.endIndex;

    }else{
        
        self.endIndex=(offSetX/MDScreenW);
        self.startIndex=self.endIndex+1;
        
        if (self.startIndex>=self.childViewControllers.count) {
            self.startIndex=self.childViewControllers.count-1;
            self.lastIndex=self.endIndex;
            return;
        }
        self.lastIndex=self.endIndex;
        progress = 1.0 - progress;
    }

    UIButton* startButton=self.buttonArray[self.startIndex];
    UIButton* endButton=self.buttonArray[self.endIndex];
    
    CGFloat xDistance = endButton.frame.origin.x - startButton.frame.origin.x;
    
    CGFloat startX=startButton.frame.origin.x+xDistance*progress;

    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBackView.mas_left).with.offset(startX);
    }];
    
    UIColor* startButtonTextColor=[UIColor colorWithRed:[self.selectedColorRgb[0] floatValue] + [self.deltaRGB[0] floatValue] * progress green:[self.selectedColorRgb[1] floatValue] + [self.deltaRGB[1] floatValue] * progress blue:[self.selectedColorRgb[2] floatValue] + [self.deltaRGB[2] floatValue] * progress alpha:1.0];
    
    UIColor* endButtonTextColor=[UIColor colorWithRed:[self.normalColorRgb[0] floatValue] - [self.deltaRGB[0] floatValue] * progress green:[self.normalColorRgb[1] floatValue] - [self.deltaRGB[1] floatValue] * progress blue:[self.normalColorRgb[2] floatValue] - [self.deltaRGB[2] floatValue] * progress alpha:1.0];
    
    [startButton setTitleColor:startButtonTextColor forState:UIControlStateNormal];
    [endButton setTitleColor:endButtonTextColor forState:UIControlStateNormal];
    
//    CGFloat deltaScale = 1.3- 1.0;
//    startButton.titleLabel.transform=CGAffineTransformMakeScale(1.3- deltaScale * progress, 1.3- deltaScale * progress);
//    endButton.titleLabel.transform=CGAffineTransformMakeScale(1.0 + deltaScale * progress, 1.0 + deltaScale * progress);
}

- (NSArray *)deltaRGB {
    if (_deltaRGB == nil) {
        NSArray *normalColorRgb = self.normalColorRgb;
        NSArray *selectedColorRgb = self.selectedColorRgb;
        
        NSArray *delta;
        if (normalColorRgb && selectedColorRgb) {
            CGFloat deltaR = [normalColorRgb[0] floatValue] - [selectedColorRgb[0] floatValue];
            CGFloat deltaG = [normalColorRgb[1] floatValue] - [selectedColorRgb[1] floatValue];
            CGFloat deltaB = [normalColorRgb[2] floatValue] - [selectedColorRgb[2] floatValue];
            delta = [NSArray arrayWithObjects:@(deltaR), @(deltaG), @(deltaB), nil];
            _deltaRGB = delta;
        }
    }
    return _deltaRGB;
}


- (NSArray *)normalColorRgb {
    if (!_normalColorRgb) {
        NSArray *normalColorRgb = [self getColorRgb:[UIColor colorWithRed:51.0/255.0 green:53.0/255.0 blue:75/255.0 alpha:1.0]];
        NSAssert(normalColorRgb, @"设置普通状态的文字颜色时 请使用RGB空间的颜色值");
        _normalColorRgb = normalColorRgb;
        
    }
    return  _normalColorRgb;
}


- (NSArray *)selectedColorRgb {
    if (!_selectedColorRgb) {
        NSArray *selectedColorRgb = [self getColorRgb:MDColor(10, 76, 153, 1.0)];
        NSAssert(selectedColorRgb, @"设置选中状态的文字颜色时 请使用RGB空间的颜色值");
        _selectedColorRgb = selectedColorRgb;
    }
    return  _selectedColorRgb;
}

- (NSArray *)getColorRgb:(UIColor *)color {
    //CGColorGetComponents方法返回的是一个数组，存储的是RGBALPHA四个值
    CGFloat numOfcomponents = CGColorGetNumberOfComponents(color.CGColor);
    NSArray *rgbComponents;
    if (numOfcomponents == 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        rgbComponents = [NSArray arrayWithObjects:@(components[0]), @(components[1]), @(components[2]), nil];
    }
    return rgbComponents;
}

-(void)buttonClick:(UIButton*)button{
    self.forbidTouchToAdjustPosition=YES;
    NSIndexPath* indexPath =[NSIndexPath indexPathForRow:button.tag inSection:0];
    [self.topCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:0 animated:YES];
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBackView.mas_left).with.offset((MDScreenW/self.titleArray.count)*button.tag);
    }];
    
    UIButton* lastButton=self.buttonArray[self.lastIndex];
    [lastButton setTitleColor:[UIColor colorWithRed:51.0/255.0 green:53.0/255.0 blue:75/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button setTitleColor:MDColor(10, 76, 153, 1.0) forState:UIControlStateNormal];
    self.lastIndex=button.tag;
}

-(void)boomViewButtonClick:(UIButton*)button{
    
    NSLog(@"%@",[self class]);
    
    SGScanningQRCodeVC* scgVC=[[SGScanningQRCodeVC alloc] init];
    [self.navigationController pushViewController:scgVC animated:YES];
    
}

@end
