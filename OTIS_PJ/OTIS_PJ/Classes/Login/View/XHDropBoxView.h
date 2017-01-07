//
//  XHDropBoxView.h
//  XHDropTextfield
//
//  Created by kfb-2 on 15/6/2.
//  Copyright (c) 2015年 kfb-2. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XHDropBoxView;
@protocol XHDropBoxDelegate <NSObject>

-(void)selectAtIndex:(int)index WithXHDrooBox:(XHDropBoxView *)dropbox;

@end

@interface XHDropBoxView : UIView<UITableViewDelegate,UITableViewDataSource>

//视图控件部分
@property(nonatomic,strong)UITextField *textfiled;
@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)UIView *view;
@property(nonatomic,strong)UIImageView *imageview;

//数据处理部分
@property(nonatomic,strong)NSArray *arr;
@property(nonatomic,assign)BOOL buttonImageFlag;
@property(nonatomic,assign)id<XHDropBoxDelegate>delegate;
//调用方法部分
/*第一个参数设置：frame.origin.x 第二个参数：frame.origin.y  第三个参数：textfield宽度 第四个参数：textfield高度  第五个参数：button宽度
 第六个参数：tableview的高度 第七个参数：设置是否能够编辑  yes能编辑  no不能编辑
 默认button高度和textfiled高度一样
 默认tableview宽度为textfield和button的宽度只和*/
-(void)setControlsViewOriginx:(int)originx ViewOriginy:(int)originy TextWidth:(int)textwidth TextAndButtonHigth:(int)hight ButtonWidth:(int)buttonwidth TableHigth:(int)tableHight Editortype:(BOOL)type;
-(void)tableShowAndHide:(UIButton *)btn;
-(void)reloadataTableview;
-(void)closeTableview;
@end

