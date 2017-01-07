//
//  CXSelfDrivingViewController.m
//  CarLifeStyle
//
//  Created by sunze on 16/2/16.
//  Copyright © 2016年 mijia. All rights reserved.
//

#import "SZPageViewController.h"

#import "UIView+Extension.h"
#import "UIBarButtonItem+Extention.h"


@interface SZPageViewController ()<UIScrollViewDelegate>

/** 标签栏底部的红色指示器 */
@property (nonatomic, weak) UIView *indicatorView;

/** 顶部的所有标签 */
@property (nonatomic, weak) UIView *titlesView;
/** 底部的所有内容 */
@property (nonatomic, weak) UIScrollView *contentView;

@end

@implementation SZPageViewController

- (BOOL)shouldAutorotate{
    
    return NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置导航栏
    [self setupNav];
    
    // 初始化子控制器
    [self setupChildVces];
    
    // 设置顶部的标签栏
    [self setupTitlesView];
    
    // 底部的scrollView
    [self setupContentView];
    
}

/**
 * 初始化子控制器
 */
- (void)setupChildVces
{
    SZLog(@"fdsgasdgsdas");
}


/**
 * 设置顶部的标签栏
 */
- (void)setupTitlesView
{

    // 标签栏整体
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [UIColor whiteColor];
    titlesView.width = self.view.width;
    titlesView.height = CXTitilesViewH;
    titlesView.y = self.isNeedSpace?CXTitilesViewSpaceY:CXTitilesViewY;
    titlesView.layer.borderWidth = .7;
    titlesView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 底部的红色指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = RGB(29, 96, 169);
    indicatorView.height = 2;
    indicatorView.tag = -1;
    indicatorView.y = titlesView.height - indicatorView.height;
    self.indicatorView = indicatorView;

    // 内部的子标签
    CGFloat width = titlesView.width / self.childViewControllers.count;
    CGFloat height = titlesView.height;
    for (NSInteger i = 0; i<self.childViewControllers.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = i+100;
        button.height = height;
        button.width = width;
        button.x = i * width;
        UIViewController *vc = self.childViewControllers[i];
        [button setTitle:vc.title forState:UIControlStateNormal];
        //        [button layoutIfNeeded]; // 强制布局(强制更新子控件的frame)
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:RGB(29, 96, 169) forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:button];
        
        // 默认点击了第一个按钮
        if (i == 0) {
            button.enabled = NO;
            self.selectedButton = button;
            
            // 让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
            self.indicatorView.width = SCREEN_WIDTH/self.childViewControllers.count;
            self.indicatorView.centerX = button.centerX;
        }
    }
    
    [titlesView addSubview:indicatorView];
}

- (void)titleClick:(UIButton *)button
{
    // 修改按钮状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    self.selectedButton.titleLabel.font = [UIFont systemFontOfSize:19];
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = SCREEN_WIDTH/self.childViewControllers.count;
        self.indicatorView.centerX = button.centerX;
    }];
    
    // 滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x = (button.tag-100) * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
    
    [self clickTitle:button];
}

-(void)setSelectedButton:(UIButton *)selectedButton{
    _selectedButton.titleLabel.font = [UIFont systemFontOfSize:17];
    _selectedButton = selectedButton;

}

-(void)clickTitle:(UIButton *)button{
    

}


/**
 * 底部的scrollView
 */
- (void)setupContentView
{
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame = self.view.bounds;
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    contentView.bounces = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.showsHorizontalScrollIndicator = NO;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    self.contentView = contentView;
    
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
}

/**
 * 设置导航栏
 */
- (void)setupNav
{

}

#pragma mark - <UIScrollViewDelegate>

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
////    CGFloat offsetX = scrollView.contentOffset.x;
////    int count = (int)self.childViewControllers.count;
////    if (offsetX < 0) {
////        UIButton *btn = [self.titlesView viewWithTag:self.childViewControllers.count-1+100];
//////        SZLog(@"%@",btn);
//////        [self titleClick:btn];
////    }else if (offsetX>(count-1)*SCREEN_WIDTH){
////        UIButton *btn = [self.titlesView viewWithTag:100];
//////        SZLog(@"%@",btn);
//////        [self titleClick:btn];
////    }
////    
//}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    CGFloat offsetX = scrollView.contentOffset.x;
    int count = (int)self.childViewControllers.count;
    if (offsetX < 0) {
        index = count-1;
    }else if (offsetX>(count-1)*SCREEN_WIDTH){
        index = 0;
    }
    // 取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = self.isNeedSpace?CXTitilesSubSpaceY:5; // 设置控制器view的y值为0(默认是20)
    vc.view.height = scrollView.height; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
    [scrollView addSubview:vc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:self.titlesView.subviews[index]];

    UIViewController *vc =  self.childViewControllers[index];
    [vc viewWillAppear:YES];
}




@end
