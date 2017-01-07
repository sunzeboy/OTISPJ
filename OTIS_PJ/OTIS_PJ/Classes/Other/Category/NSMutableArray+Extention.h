//
//  NSMutableArray+Extention.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/23.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Extention)

+(BOOL)whetherEachGroupHasSelectedElementsWithArray:(NSArray *)array;

+(NSMutableArray *)selectedElementsWithArray:(NSArray *)array;

+(int)whetherHadSelectedElementsWithArray:(NSArray *)array;

+(NSMutableArray *)selectedCheckItemsWithArray:(NSArray *)array;
@end
