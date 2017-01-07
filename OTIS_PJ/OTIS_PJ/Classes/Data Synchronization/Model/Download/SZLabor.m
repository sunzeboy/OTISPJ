//
//  SZLabor.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/16.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZLabor.h"
#import "SZTable_LaborType.h"
#import "NSString+Extention.h"

@implementation SZLabor

-(BOOL)isLutu{
    return [SZTable_LaborType quaryIsLutuWithRelationID:self.RelationID];
}

-(SZLaborHoursItem *)item1{
    if (_item1 == nil) {
        _item1 = [[SZLaborHoursItem alloc] init];
    }
    return _item1;
}
-(SZLaborHoursItem *)item2{
    if (_item2 == nil) {
        _item2 = [[SZLaborHoursItem alloc] init];
    }
    return _item2;
}

-(float)gongshi{
    float time1 = [NSString floatWithString:_item1.Hour1Str];
    float time15 = [NSString floatWithString:_item1.Hour15Str];
    float time2 = [NSString floatWithString:_item1.Hour2Str];
    float time3 = [NSString floatWithString:_item1.Hour3Str];
    
    
    float time21 = [NSString floatWithString:_item2.Hour1Str];
    float time215 = [NSString floatWithString:_item2.Hour15Str];
    float time22 = [NSString floatWithString:_item2.Hour2Str];
    float time23 = [NSString floatWithString:_item2.Hour3Str];
    
    return time1+time15+time2+time3+time21+time215+time23+time22;
}

-(float)mainGongshi{
    
    float time1 = [NSString floatWithString:_item1.Hour1Str];
    float time15 = [NSString floatWithString:_item1.Hour15Str];
    float time2 = [NSString floatWithString:_item1.Hour2Str];
    float time3 = [NSString floatWithString:_item1.Hour3Str];

    return time1+time15+time2+time3;
}

@end
