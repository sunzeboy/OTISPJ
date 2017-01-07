//
//  SZAnnualInspection.m
//  OTIS_PJ
//
//  Created by jQ on 16/5/9.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZAnnualInspection.h"

@implementation SZAnnualInspection

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if(self = [super init]){
        
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)annualInspectionWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}

+ (NSArray *)annualInspectionList{
    //加载plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"annualList" ofType:@"plist"];
    NSArray *dicArray = [NSArray arrayWithContentsOfFile:path];
    
    //字典转模型
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSDictionary *dic in dicArray) {
        SZAnnualInspection *szannual = [SZAnnualInspection annualInspectionWithDic:dic];
        [tmpArray addObject:szannual];
    }
    return tmpArray;
}
@end
