//
//  SZCheckLookIModel.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/21.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZCheckLookModel.h"
#import "NSString+Extention.h"
#import "SZTable_LaborHours.h"

@implementation SZCheckLookModel

+(instancetype)modelWithUnitNo:(NSString *)unitNo andLaborHours:(NSMutableArray *)laborHours{

    SZCheckLookModel *model = [[SZCheckLookModel alloc] init];
    model.unitNo = unitNo ;
    model.laborHours = laborHours;
    return model;
}


-(CGFloat)cellHeight{
    return 45+(OTIS_SZLaborHoursItemViewH*(_laborHours.count));
}

-(float)gongshi{
    
    float total = 0;
    for (SZLaborHoursItem *item in _laborHours) {
        total+=item.gongshi;
    }
    return total;

}

@end
