//
//  SZCheckLookTableViewCell.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/21.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZCheckLookTableViewCell.h"
#import "SZTable_LaborHours.h"
#import "SZLaborHoursItemView.h"


@interface SZCheckLookTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *unitNo;

@end

@implementation SZCheckLookTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"SZCheckLookTableViewCell";
    SZCheckLookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SZCheckLookTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
    
}

-(void)setModel:(SZCheckLookModel *)model{
    _model = model;
    if (model.feishengchanxing) {
        self.unitNo.text = [NSString stringWithFormat:@"%@：",SZLocal(@"title.Non productive time")];
    }else{
        if (model.unitNo.length) {
            self.unitNo.text = [NSString stringWithFormat:@"%@：%@",SZLocal(@"dialog.title.Elevator number"),model.unitNo];
        }else{
            self.unitNo.text = [NSString stringWithFormat:@"%@：%@",SZLocal(@"dialog.title.Contract number"),model.contactNo];
        }
    }
}

-(void)layoutSubviews{

//    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        for (int i =0; i<self.model.laborHours.count; i++) {
            SZLaborHoursItem *laborHour = self.model.laborHours[i];
           
//            dispatch_async(dispatch_get_main_queue(), ^{
                SZLaborHoursItemView *view = [SZLaborHoursItemView loadSZLaborHoursItemView];
                view.frame = CGRectMake(-4, 35+i*(OTIS_SZLaborHoursItemViewH), SCREEN_WIDTH, OTIS_SZLaborHoursItemViewH);
                view.item = laborHour;
                [self.contentView addSubview:view];
//            });
        }
//    });
}

//-(void)setFrame:(CGRect)frame{
////    frame.size.height = self.model.cellHeight - 5;
//    frame.origin.y += 10/2;
//    frame.origin.x -= 4;
//    frame.size.width -= 8;
//
//    [super setFrame:frame];
//
//}


@end
