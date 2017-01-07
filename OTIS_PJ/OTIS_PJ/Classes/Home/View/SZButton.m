//
//  SZButton.m
//  otis__PJ
//
//  Created by sunze on 16/4/20.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZButton.h"
#import "AppDelegate.h"

@implementation SZButton

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self loadContentView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self loadContentView];
    }
    return self;
}
//1 懒加载
- (UILabel *)badge
{
    if (_badge ==nil) {
        _badge  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImage.frame)-10, CGRectGetMinY(self.iconImage.frame)-10, 22, 22)];
        _badge .layer.cornerRadius = 11;
        _badge .clipsToBounds = YES;
        _badge .backgroundColor = [UIColor redColor];
        _badge .textColor = [UIColor whiteColor];
        _badge .font = [UIFont systemFontOfSize:10];
        _badge .textAlignment = NSTextAlignmentCenter;
        _badge .hidden = YES;

    }
    return _badge;
}


- (void)loadContentView {
    
    UIView *contentView = [[NSBundle mainBundle] loadNibNamed:@"SZButton" owner:self options:nil].firstObject;
    if (contentView) {
        [self addSubview:contentView];
        contentView.translatesAutoresizingMaskIntoConstraints = YES;
        contentView.frame = self.bounds;
        
        
        [self addSubview:self.badge];
    }
    self.backgroundColor = [UIColor whiteColor];
    
}
- (IBAction)tapButton:(id)sender {
    if (self.btnClickBlock) {
        self.btnClickBlock(sender);
    }
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
