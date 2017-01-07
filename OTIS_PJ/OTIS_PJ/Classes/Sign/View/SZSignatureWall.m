//
//  SZSignatureWall.m
//  OTIS_PJ
//
//  Created by jQ on 16/5/9.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZSignatureWall.h"
@interface SZSignatureWall();
//声明背赛尔曲线
@property(nonatomic, strong)UIBezierPath *path;
@end
@implementation SZSignatureWall

//懒加载
- (NSMutableArray *)pathArr {
    if (_pathArr == nil) {
        
        _pathArr = [NSMutableArray array];
        
    }
    return _pathArr;
}
//xib加载时调用
- (void)awakeFromNib {
    [self setUp];
}
//
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

//自定义初始化方法
- (void)setUp {
    
    //添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    //初始化时设置路径线宽
    _lineWidth = 5;
}

//手指拖动到时候调用
- (void)pan:(UIPanGestureRecognizer *)pan
{
    // 获取当前手指触摸点
    CGPoint startP = [pan locationInView:self];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        //创建贝塞尔路径
        _path = [UIBezierPath bezierPath];
        
        //设置起点
        [_path moveToPoint:startP];
        // 设置画笔粗细
        [_path setLineWidth:_lineWidth];
        
        //添加到数组里面
        [_pathArr addObject:_path];
    }
    //连线（手指拖动，添加当前点到路径）
    [_path addLineToPoint:startP];
    
    //重绘，调用drawRect方法
    [self setNeedsDisplay];
    
    if (self.changeSaveBtnState) {
        self.changeSaveBtnState();
    }
}

//绘制图形
- (void)drawRect:(CGRect)rect {
    
    //把所有路径画出来
    for (UIBezierPath *path in self.pathArr) {
        [path stroke];
    }

}

- (void)clear {
    //清除
    [self.pathArr removeAllObjects];

    [self setNeedsDisplay];

}
@end
