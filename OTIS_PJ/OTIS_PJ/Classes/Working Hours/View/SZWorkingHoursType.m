//
//  SZWorkingHoursType.m
//  OTIS_PJ
//
//  Created by zy on 16/4/28.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZWorkingHoursType.h"

@implementation SZWorkingHoursType


- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)workingHoursTypesWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}

+ (NSArray *)workingHoursTypesList:(NSString *)strImageName{
    //加载plist
    NSString *path = [[NSBundle mainBundle] pathForResource:strImageName ofType:@"plist"];
    NSArray *dicArray = [NSArray arrayWithContentsOfFile:path];
    
    //字典转模型
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSDictionary *dic in dicArray) {
        SZWorkingHoursType *workingHoursType = [SZWorkingHoursType workingHoursTypesWithDic:dic];
        [tmpArray addObject:workingHoursType];
    }
    return tmpArray;
}

@end
