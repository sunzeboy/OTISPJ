//
//  CustomTextView.m
//  TextViewPlactor
//
//  Created by 杜亚伟 on 16/9/28.
//  Copyright © 2016年 杜亚伟. All rights reserved.
//

#import "CustomTextView.h"


@interface CustomTextView ()

@property (nonatomic, weak) UILabel *placeholderLabel;

@end

@implementation CustomTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.keyboardType=UIKeyboardTypeDefault;
        self.backgroundColor=[UIColor whiteColor];
        //        self.autoresizingMask
        //        = UIViewAutoresizingFlexibleHeight;
        self.font = [UIFont systemFontOfSize:15];
        self.alwaysBounceVertical = YES;
        
        
        // 1.添加提示文字
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.textColor = [UIColor lightGrayColor];
        placeholderLabel.hidden = YES;
        placeholderLabel.numberOfLines = 0;
        [placeholderLabel sizeToFit];
        placeholderLabel.backgroundColor = [UIColor clearColor];
        placeholderLabel.font = self.font;
        [self insertSubview:placeholderLabel atIndex:0];
        self.placeholderLabel = placeholderLabel;
        
        // 2.监听textView文字改变的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}


- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    self.placeholderLabel.text = placeholder;
    if (placeholder.length) { // 需要显示
        self.placeholderLabel.hidden = NO;
        
        // 计算frame
        CGFloat placeholderX = 5;
        CGFloat placeholderY = 7;
        CGRect placeholderSize = [placeholder boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-35, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.placeholderLabel.font} context:nil];
        
        
        self.placeholderLabel.frame = CGRectMake(placeholderX, placeholderY, placeholderSize.size.width, placeholderSize.size.height);
    } else {
        self.placeholderLabel.hidden = YES;
    }
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placeholderLabel.font = font;
    self.placeholder = self.placeholder;
}

- (void)textDidChange
{
    self.placeholderLabel.hidden = (self.text.length != 0);
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
