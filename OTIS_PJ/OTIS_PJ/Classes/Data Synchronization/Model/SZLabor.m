//
//  SZLabor.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/16.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZLabor.h"
#import "SZTable_LaborType.h"

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
@end
