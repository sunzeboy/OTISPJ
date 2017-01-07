//
//  XHDropBoxView.m
//  XHDropTextfield
//
//  Created by kfb-2 on 15/6/2.
//  Copyright (c) 2015年 kfb-2. All rights reserved.
//

#import "XHDropBoxView.h"

#define VWidth(v)   (v).frame.size.width
#define VHeight(v)   (v).frame.size.height
#define VWIDTH(v)   (v).frame.size.width + (v).frame.origin.x
#define VHEIGHT(v)  (v).frame.size.height + (v).frame.origin.y
#define kTextColor                      [UIColor darkGrayColor]
#define kBorderColor                    [UIColor colorWithRed:219/255.0 green:217/255.0 blue:216/255.0 alpha:1]

@implementation XHDropBoxView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

-(void)setControlsViewOriginx:(int)originx ViewOriginy:(int)originy TextWidth:(int)textwidth TextAndButtonHigth:(int)hight ButtonWidth:(int)buttonwidth TableHigth:(int)tableHight Editortype:(BOOL)type
{
    self.backgroundColor = [UIColor whiteColor];
    CGRect rect = self.frame;
    rect.size.height = hight;
    rect.origin.x = originx;
    rect.origin.y = originy;
    rect.size.width = textwidth+buttonwidth;
    self.frame = rect;
    
    _view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, hight)];
    _view.layer.borderColor = kBorderColor.CGColor;
    _view.layer.borderWidth = 0.5;
    [self addSubview:_view];
    
    _textfiled = [[UITextField alloc]initWithFrame:CGRectMake(0,0,textwidth,hight)];
    _textfiled.placeholder = @"请输入或者点击右边按钮选择";
    _textfiled.userInteractionEnabled = type;
    _textfiled.font = [UIFont systemFontOfSize:14];
    [_view addSubview:_textfiled];
    
    _buttonImageFlag = YES;
    _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _button.frame = CGRectMake(VWIDTH(_textfiled),0,buttonwidth, hight);
    //[_button setBackgroundImage:[UIImage imageNamed:@"down_dark0"] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(tableShowAndHide:) forControlEvents:UIControlEventTouchUpInside];
     _imageview = [[UIImageView alloc]initWithFrame:CGRectMake(5, 15, 10, 10)];
    _imageview.image = [UIImage imageNamed:@"down_dark0"];
    [_button addSubview:_imageview];
    [_view addSubview:_button];
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, VHEIGHT(_textfiled),buttonwidth+textwidth, tableHight) style:UITableViewStylePlain];
    _tableview.separatorStyle =UITableViewCellSeparatorStyleNone;
    _tableview.hidden = YES;
    _tableview.delegate =self;
    _tableview.dataSource = self;
    _tableview.layer.borderColor = (__bridge CGColorRef)(kBorderColor);
    _tableview.layer.borderWidth= 0.5;
    [self addSubview:_tableview];
}
-(void)tableShowAndHide:(UIButton *)btn
{
    if (_buttonImageFlag==YES)
    {
        [self reloadataTableview];
        CGRect rect = self.frame;
        rect.size.height = _textfiled.frame.size.height+_tableview.frame.size.height;
        self.frame = rect;
        _buttonImageFlag = NO;
       // [_button setBackgroundImage:[UIImage imageNamed:@"down_dark1"] forState:UIControlStateNormal];
        _imageview.transform = CGAffineTransformMakeScale(1.0, -1.0);
        _tableview.hidden = NO;
    }else
    {
        [self closeTableview];
    }
}
//刷新表格
-(void)reloadataTableview
{
    [_tableview reloadData];
}
//关闭表格
-(void)closeTableview
{
    _buttonImageFlag = YES;
    CGRect rect = self.frame;
    rect.size.height = _textfiled.frame.size.height;
    self.frame = rect;
    //[_button setBackgroundImage:[UIImage imageNamed:@"down_dark0"] forState:UIControlStateNormal];
    _imageview.transform = CGAffineTransformMakeScale(1.0, 1.0);
    _tableview.hidden = YES;

}
#pragma mark tabelview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdenttifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenttifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenttifier];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(2, 0, self.frame.size.width-4, 30)];
        label.font = [UIFont systemFontOfSize:14.0];
        label.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:label];
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30, self.frame.size.width, 0.5)];
        imageview.backgroundColor = kBorderColor;
        [cell addSubview:imageview];
    }
    cell.textLabel.text = _arr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(tableView.frame.origin.x, 0, tableView.frame.size.width, 0)];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.5;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _textfiled.text = _arr[indexPath.row];
    [self closeTableview];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_delegate respondsToSelector:@selector(selectAtIndex:WithXHDrooBox:)])
    {
        [_delegate selectAtIndex:(int)indexPath.row WithXHDrooBox:self];
    }
}
@end
