//
//  NSMutableArray+Extention.m
//  OTIS_PJ
//
//  Created by sunze on 16/5/23.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "NSMutableArray+Extention.h"
#import "SZMaintenanceCheckItem.h"

@implementation NSMutableArray (Extention)

+(BOOL)whetherEachGroupHasSelectedElementsWithArray:(NSArray *)array{

    NSMutableArray *arrayBool = [NSMutableArray array];
    for (NSArray *subArray in array) {
        NSString * ret = @"NO";
        for (SZJHATitleItem *item in subArray) {
            if (item.select == YES) {
                ret = @"YES";
                break;
            }
        }
        if ([ret isEqualToString:@"YES"] ) {
             [arrayBool addObject:ret];
        }
       
    }
    
    
    if (arrayBool.count == array.count) {
        return YES;
    }
    
    return NO;
}

+(NSMutableArray *)selectedElementsWithArray:(NSArray *)array{

    NSMutableArray *arraySelectedElements = [NSMutableArray array];
    for (NSArray *subArray in array) {

        for (SZJHATitleItem *item in subArray) {
            if (item.select == YES) {
                [arraySelectedElements addObject:item];

            }
        }
    }
    return arraySelectedElements;
}


+(int)whetherHadSelectedElementsWithArray:(NSArray *)array{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    for (SZJHATitleItem *item in array) {
        [dict setObject:item forKey:@(item.JhaItemType)];
    }
    if (dict.allKeys.count == 9) {
        return 1;
    }
//    [dict objectsForKeys:@[@(4),@(5),@(6)]] notFoundMarker:<#(nonnull id)#>];
    NSArray *array1 = @[@(1),@(2),@(3)];
    NSArray *array2 = @[@(4),@(5),@(6)];
    NSArray *array3 = @[@(7),@(8),@(9)];

    int ret = 2;
    for (NSArray *arraySub in @[array1,array2,array3]) {
        ret = 2;
        for (NSNumber *num in arraySub) {
            if (![dict.allKeys containsObject:num]) {
                ret = 0;
            }
        }
        if (ret == 2) return ret;
    }
    
     

    return ret;
}

+(NSMutableArray *)selectedCheckItemsWithArray:(NSArray *)array{
    
    NSMutableArray *arraySelectedElements = [NSMutableArray array];
    for (SZMaintenanceCheckItem *item in array) {
            if (item.state != 99) {
                [arraySelectedElements addObject:item];
            }
    }
    return arraySelectedElements;
}

@end
