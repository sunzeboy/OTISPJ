//
//  SZHelpTableViewCell.m
//  OTIS_PJ
//
//  Created by jQ on 16/5/11.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZHelpTableViewCell.h"
@interface SZHelpTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *iconName;
@property (weak, nonatomic) IBOutlet UIImageView *gotoImage;

@end
@implementation SZHelpTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//创建可重用的cell对象
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"SZHelpTableViewCell";
    SZHelpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SZHelpTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
    
}

//cell内项目赋值
-(void)setSzhelp:(SZHelp *)szhelp
{
    [self.layer setBorderWidth:1.0];
    self.layer.borderColor = [UIColor colorWithHexString: @"d2d2d2"].CGColor;
    _szhelp = szhelp;
    self.iconName.text = szhelp.iconName;
    //add underline
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:szhelp.iconName];
    //
    if([szhelp.iconName isEqualToString:SZLocal(@"btn.title.Exit login")]){
        [content addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0079ff"] range:NSMakeRange(0, content.length)];
        self.iconName.attributedText = content;
        self.iconName.textAlignment = NSTextAlignmentCenter;
    }else{
        self.iconName.attributedText = content;
    }
    //图片
    self.iconImage.image = [UIImage imageNamed:szhelp.iconImage];
    self.gotoImage.image = [UIImage imageNamed:szhelp.gotoImage];
}
@end
