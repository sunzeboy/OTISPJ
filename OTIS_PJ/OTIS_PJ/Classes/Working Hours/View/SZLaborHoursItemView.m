//
//  SZLaborHoursItemView.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/21.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZLaborHoursItemView.h"

@interface SZLaborHoursItemView ()

@property (weak, nonatomic) IBOutlet UILabel *laborName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *h1;
@property (weak, nonatomic) IBOutlet UILabel *h15;
@property (weak, nonatomic) IBOutlet UILabel *h2;
@property (weak, nonatomic) IBOutlet UILabel *h3;

@end

@implementation SZLaborHoursItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype) loadSZLaborHoursItemView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SZLaborHoursItemView" owner:self options:nil]lastObject];
}

-(void)setItem:(SZLaborHoursItem *)item{
    _item = item;
    if (item.LaborTypeId == 1) {
        self.laborName.text = SZLocal(@"dialog.title.Normal maintenance");
    }else if (item.LaborTypeId == 2){
        self.laborName.text = SZLocal(@"dialog.title.Normal road maintenance");
    }else{
        self.laborName.text = item.LaborName;
    }
    
    self.time.text = item.CreateTimeStr;
    self.h1.text = item.Hour1RateStr;
    self.h15.text = item.Hour15RateStr;
    self.h2.text = item.Hour2RateStr;
    self.h3.text = item.Hour3RateStr;


}

@end
