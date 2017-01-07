//
//  SZWorkingHours.m
//  OTIS_PJ
//
//  Created by zy on 16/5/9.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZWorkingHours.h"

@implementation SZWorkingHours



- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)workingHourWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}

+ (NSArray *)workingHoursList{
    //加载plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"workingHours" ofType:@"plist"];
    NSArray *dicArray = [NSArray arrayWithContentsOfFile:path];
    
    //字典转模型
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSDictionary *dic in dicArray) {
        SZWorkingHours *workingHours = [SZWorkingHours workingHourWithDic:dic];
        [tmpArray addObject:workingHours];
    }
    return tmpArray;
}


@end
