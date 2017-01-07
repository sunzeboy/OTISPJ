//
//  SZCheckBoxViewCell.m
//  OTIS_PJ
//
//  Created by zy on 16/5/5.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZCheckBoxViewCell.h"
#import "SZJHATitleItem.h"
#import "UIView+Extension.h"
#import "SZCollectionViewCell.h"
#import "Masonry.h"
#import "SZModuleQueryTool.h"
#import "SZJobHazard.h"
#import "SZJHATitleItem.h"
@interface SZCheckBoxViewCell()<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *hazardName;
@property(nonatomic,weak)UICollectionView* collectionView;
@property(nonatomic,weak)UIButton* button;

@property (nonatomic , assign) BOOL select;


@end

@implementation SZCheckBoxViewCell





-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSubViews];
    }
    return self;
}

-(void)setSubViews{
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumLineSpacing=10;//cell 的每行间距
    flowLayout.minimumInteritemSpacing=10;//cell的间距
    flowLayout.sectionInset=UIEdgeInsetsMake(10, 10, 0, 10);//设置cell距collection的内边距
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-30)/2.0, 30);// cell的大小(6位内边距加上cell间距)
    
    UICollectionView* collectionView=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.delegate=self;
    collectionView.dataSource=self;
    collectionView.backgroundColor=[UIColor whiteColor];
    collectionView.alwaysBounceVertical = YES;
    //允许多选，设为yes时点击item两次才有响应
    //collectionView.allowsMultipleSelection = YES;
    collectionView.scrollEnabled=NO;
    [self.contentView addSubview:collectionView];
    [collectionView registerClass:[SZCollectionViewCell class] forCellWithReuseIdentifier:@"SZCollectionViewCell"];
    self.collectionView=collectionView;
    
    UIEdgeInsets insets=UIEdgeInsetsMake(0, 0, 0, 0);
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(insets);
    }];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //NSLog(@"**********%ld",(long)self.cellCount);
    return [self.dataArray[self.cellCount] count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SZCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SZCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor whiteColor];
    NSArray* array=self.dataArray[self.cellCount];
    SZJHATitleItem *gb = array[indexPath.row];
    cell.jobItem = gb;
    cell.checkImageView.tag=indexPath.row+10;
    cell.textField.delegate=self;
    if ([gb.Name isEqualToString:@"其他"]) {
        self.button=cell.checkImageView;


        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:cell.textField];
    }
   // [cell.checkImageView addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SZCollectionViewCell*cell=(SZCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    NSArray* array=self.dataArray[self.cellCount];
    SZJHATitleItem *gb = array[indexPath.row];
    if ([gb.Name isEqualToString:@"其他"]) {
    }else{
        cell.checkImageView.selected=!cell.checkImageView.selected;
        gb.select= cell.checkImageView.selected;
    }
}


-(void)buttonClick:(UIButton*)btn{

}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray=dataArray;
    [self.collectionView reloadData];
}


//创建自定义可重用的cell对象
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"SZTableViewCell";
    SZCheckBoxViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SZCheckBoxViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

//重写属性的setter方法，给子控件赋值
- (void)setJobHazard:(SZJHATitleItem *) jobHazard
{
    _jobHazard = jobHazard;

    self.btn.selected = jobHazard.select;
    
    self.hazardName.text = jobHazard.Name;
    if ([jobHazard.Name isEqualToString:@"其他"]) {
        self.textField.hidden = NO;
        self.textField.text = jobHazard.Other;
        self.textField.delegate = self;
        if (jobHazard.Other.length>0) {
            _jobHazard.select = YES;
            self.btn.selected = YES;
        }else{
            _jobHazard.select = NO;
            self.btn.selected = NO;
        }
    }else{
        self.textField.hidden = YES;
    }
}
- (IBAction)btnClick:(UIButton *)sender {
    _jobHazard.select = !_jobHazard.select;
    sender.selected = _jobHazard.select;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (self.updateTableviewBlock) {
        self.updateTableviewBlock();
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
//   _jobHazard.Other = textField.text;
//    [self setOtherWithTextField:textField];
    if (self.endEditBlock) {
        self.endEditBlock();
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //[self setOtherWithTextField:textField];
    if (self.editBlock) {
        self.editBlock();
    }
}

-(void)setOtherWithTextField:(UITextField *)textField{
    if (textField.text.length>0) {
        _jobHazard.select = YES;
        self.btn.selected = YES;
    }else{
        _jobHazard.select = NO;
        self.btn.selected = NO;
    }
}

//-(void)textValueChange:(UITextField *) textField{
//    
//    NSArray* array=self.dataArray[self.cellCount];
//    SZJHATitleItem *gb = [array lastObject];
//    self.button.selected=textField.text.length;
//    NSInteger length = textField.text.length;
//    if (length > 4) {
//        textField.text = [textField.text substringToIndex:4];
//    }
//    if (textField.text.length>0) {
//        gb.select=YES;
//        gb.Other=textField.text;
//    }else{
//        gb.Other=@"";
//        gb.select=NO;
//    }
//}
-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 4) {
                textField.text = [toBeString substringToIndex:4];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > 4) {
            textField.text = [toBeString substringToIndex:4];
        }  
    }
    NSArray* array=self.dataArray[self.cellCount];
    SZJHATitleItem *gb = [array lastObject];
    self.button.selected=textField.text.length;
    
    if (textField.text.length>0) {
        gb.select=YES;
        gb.Other=textField.text;
    }else{
        gb.Other=@"";
        gb.select=NO;
    }
}


@end
