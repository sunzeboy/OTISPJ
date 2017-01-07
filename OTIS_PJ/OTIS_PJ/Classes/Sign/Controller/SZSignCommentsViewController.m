//
//  SZSignCommentsViewController.m
//  OTIS_PJ
//
//  Created by jQ on 16/6/14.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZSignCommentsViewController.h"
#import "SZTable_Report.h"
#import "UIView+Extension.h"
#import "CustomIOSAlertView.h"
#import "Masonry.h"
@interface SZSignCommentsViewController ()<UITextViewDelegate>

@property(nonatomic,weak) UILabel *commentLabel;

@property(nonatomic,weak) UITextView *commentText;

@property(nonatomic,weak) UIButton *needReformeBtn;

@property(nonatomic,weak) UIButton *needReplaceBtn;

@end

@implementation SZSignCommentsViewController
- (BOOL)shouldAutorotate{
    
    return NO;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setframe];
    
}

-(void)setMaintenanceComments:(NSString *)maintenanceComments{
    _maintenanceComments = maintenanceComments;
    self.commentText.text = maintenanceComments;

}

-(void)setNeedReplace:(BOOL)needReplace{
    _needReplace = needReplace;
    [self.needReplaceBtn setImage:[UIImage imageNamed:@"check_off.png"] forState:UIControlStateNormal];
    [self.needReplaceBtn setImage:[UIImage imageNamed:@"check_on.png"] forState:UIControlStateSelected];
    self.needReplaceBtn.selected = needReplace;
}

-(void)setNeedReform:(BOOL)needReform{
    _needReform = needReform;
    [self.needReformeBtn setImage:[UIImage imageNamed:@"check_off.png"] forState:UIControlStateNormal];
    [self.needReformeBtn setImage:[UIImage imageNamed:@"check_on.png"] forState:UIControlStateSelected];
    self.needReformeBtn.selected = needReform;

}

- (void) setframe {
    // Checkbox图片
    // Checkbox图片
    UIImage* checkOffImage = [UIImage imageNamed:@"check_off.png"];
    UIImage* checkOnImage = [UIImage imageNamed:@"check_on.png"];
    
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    commentLabel.numberOfLines = 0;
    commentLabel.text = [NSString stringWithFormat:@"%@:",SZLocal(@"title.Problems found in the work and the need to deal with customers")];
    // comment内容
    UITextView *commentText = [[UITextView alloc] initWithFrame:CGRectZero];
    commentText.backgroundColor = [UIColor lightGrayColor];
    commentText.delegate = self;
    commentText.text = self.maintenanceComments;
    commentText.font =[UIFont fontWithName:@"Microsoft YaHei" size:15];
    commentText.userInteractionEnabled = NO;
    self.commentText = commentText;
    
    //需要更换
    UILabel *needReplaceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    needReplaceLabel.text = SZLocal(@"title.Need to be replaced");
    
    UIButton *needReplaceBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [needReplaceBtn setImage:checkOffImage forState:UIControlStateNormal];
    [needReplaceBtn setImage:checkOnImage forState:UIControlStateSelected];
    needReplaceBtn.selected = self.needReplace;
    needReplaceBtn.userInteractionEnabled = NO;
    self.needReplaceBtn = needReplaceBtn;
    
    // 需要改造
    UILabel *needReformLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    needReformLabel.text =SZLocal(@"title.Need to transform");
    
    UIButton *needReformeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    needReformeBtn.selected = self.needReform;
    needReformeBtn.userInteractionEnabled = NO;
    [needReformeBtn setImage:checkOffImage forState:UIControlStateNormal];
    [needReformeBtn setImage:checkOnImage forState:UIControlStateSelected];
    self.needReformeBtn = needReformeBtn;

    // comment

    UILabel *commentLabelDetail = [[UILabel alloc] initWithFrame:CGRectZero];
    commentLabelDetail.textColor=[UIColor blackColor];
    commentLabelDetail.text = [NSString stringWithFormat:@"%@:",SZLocal(@"title.If you have any questions, please specify")];
    
    _commentTextDetail = [[UITextView alloc] initWithFrame:CGRectZero];
    _commentTextDetail.delegate = self;
    _commentTextDetail.font =[UIFont fontWithName:@"Microsoft YaHei" size:15];
    _commentTextDetail.backgroundColor = [UIColor lightGrayColor];
    _commentTextDetail.returnKeyType = UIReturnKeyDone;
    
    [self.view addSubview:commentLabel];
    [self.view addSubview:commentText];
    [self.view addSubview:needReplaceLabel];
    [self.view addSubview:needReplaceBtn];
    [self.view addSubview:needReformLabel];
    [self.view addSubview:needReformeBtn];
    [self.view addSubview:commentLabelDetail];
    [self.view addSubview:_commentTextDetail];
    _commentLabel=commentLabel;
    
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(110);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
//        make.height.mas_equalTo(20);
    }];
    
    [commentText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentLabel.mas_bottom).with.offset(10);
        make.left.equalTo(commentLabel.mas_left).with.offset(0);
        make.right.equalTo(commentLabel.mas_right).with.offset(0);
        make.height.mas_equalTo(100);
    }];
    
    [needReplaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentText.mas_bottom).with.offset(10);
        make.left.equalTo(commentText.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    [needReplaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(needReplaceLabel.mas_top).with.offset(0);
        make.left.equalTo(needReplaceLabel.mas_right).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [needReformeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(needReplaceLabel.mas_top).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(-30);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [needReformLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(needReformeBtn.mas_left).with.offset(20);
        make.top.equalTo(needReformeBtn.mas_top).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    [commentLabelDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(needReformLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(needReformLabel.mas_right).with.offset(0);
        make.bottom.equalTo(_commentTextDetail.mas_top).with.offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    [_commentTextDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentLabelDetail.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.mas_equalTo(180);
    }];
    
    

}




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [UIView animateWithDuration:0.25 animations:^{
        [_commentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(-100);
        }];
        [self.view layoutIfNeeded];
    }];
    return YES;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    if (self.commentTextDetailBlock) {
        self.commentTextDetailBlock(textView.text);
    }
    [UIView animateWithDuration:0.25 animations:^{
        [_commentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(110);
        }];
        [self.view layoutIfNeeded];
    }];
    return [self.commentTextDetail resignFirstResponder];
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
//    self.maintenanceComments = textView.text;
}
-(void)textViewDidChange:(UITextView *)textView{
//    self.maintenanceComments = textView.text;
    if (self.commentTextDetailBlock) {
        self.commentTextDetailBlock(textView.text);
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.commentTextDetail resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

@end
