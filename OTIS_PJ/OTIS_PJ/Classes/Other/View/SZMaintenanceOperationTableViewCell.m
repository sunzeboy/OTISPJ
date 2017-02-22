//
//  SZMaintenanceOperationTableViewCell.m
//  OTIS_PJ
//
//  Created by zy on 16/5/5.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZMaintenanceOperationTableViewCell.h"
#import "SZMaintenanceCheckItem.h"
#import "SZTable_Report.h"

@interface SZMaintenanceOperationTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *operationId;
@property (weak, nonatomic) IBOutlet UILabel *operationName;
@property (weak, nonatomic) IBOutlet UILabel *operationContent;
- (IBAction)operationAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *automButton;


@end

@implementation SZMaintenanceOperationTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    
    self.automButton.layer.borderColor=[UIColor blackColor].CGColor;
    self.automButton.layer.borderWidth=1.0;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



//创建自定义可重用的cell对象
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"SZMaintenanceOperationTableViewCell";
    SZMaintenanceOperationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SZMaintenanceOperationTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


//重写属性的setter方法，给子控件赋值
- (void)setMaintenanceOperation:(SZMaintenanceCheckItem *) maintenanceOperation
{
    _maintenanceOperation = maintenanceOperation;
    
    self.operationBtn.tag = maintenanceOperation.state == 99?-1:maintenanceOperation.state;
    [self.operationBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"OTIS_%d",(int)self.operationBtn.tag]] forState:UIControlStateNormal];
    self.operationId.text = maintenanceOperation.ItemCode;
    self.operationContent.text = maintenanceOperation.Description;
    if (maintenanceOperation.Type == 0) {
        NSMutableAttributedString *text0 = [[NSMutableAttributedString alloc] initWithString:maintenanceOperation.ItemName];
        
        NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:@"    (每年一次)"];
        [text1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, text1.length)];
        [text0 appendAttributedString:text1];
        self.operationName.attributedText = text0;
    }else if (maintenanceOperation.Type == -1){
        NSString *subStr = [maintenanceOperation.ItemName substringToIndex:maintenanceOperation.ItemName.length-8];
        NSMutableAttributedString *text0 = [[NSMutableAttributedString alloc] initWithString:subStr];
        
        NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:@"    (年检前一个月)"];
        [text1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, text1.length)];
        [text0 appendAttributedString:text1];
        self.operationName.attributedText = text0;
    }else if (maintenanceOperation.Type == -2){
        NSString *subStr = [maintenanceOperation.ItemName substringToIndex:maintenanceOperation.ItemName.length-8];
        NSMutableAttributedString *text0 = [[NSMutableAttributedString alloc] initWithString:subStr];
        NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:@"    (年检前两月)"];
        [text1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, text1.length)];
        [text0 appendAttributedString:text1];
        self.operationName.attributedText = text0;
    }else{
        self.operationName.text = maintenanceOperation.ItemName;

    }
    
    if (maintenanceOperation.IsSafetyItem==1) {
        self.backgroundColor=[UIColor colorWithHexString:@"#FFDEAD"];
    }else{
        self.backgroundColor=[UIColor whiteColor];
    }
    
    SZLog(@"%d",maintenanceOperation.IsSafetyItem);
    
}


- (IBAction)operationAct:(UIButton *)sender {
    if (self.isFixMode) {
        sender.tag ++;
        if (sender.tag == 3) {
            sender.tag = 1;
        }
        [self.operationBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"OTIS_%ld",(long)sender.tag]] forState:UIControlStateNormal];

        _maintenanceOperation.state = (int)sender.tag;

    }else{
        if (sender.tag == 4) {
            return;
        }
        if (sender.tag == 3) {
            sender.tag = -1;
            [self.operationBtn setBackgroundImage:[UIImage imageNamed:@"OTIS_-1"] forState:UIControlStateNormal];
            
        }else{
            sender.tag +=1;
            [self.operationBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"OTIS_%ld",(long)sender.tag]] forState:UIControlStateNormal];
            
        }
        _maintenanceOperation.state = (int)sender.tag == -1?99:(int)sender.tag;
    }
    
    
}

@end
