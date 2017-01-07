//
//  SZJobHazard.m
//  OTIS_PJ
//
//  Created by zy on 16/5/5.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZJobHazard.h"


@implementation SZJobHazard


- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)jobHazardWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}


+ (NSDictionary *)jobHazardsList{
    //加载plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"jobHazard" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    return dic;
}

+ (NSArray *)jobHazardsGroupList : (NSString *)key {
    //字典转模型
    NSMutableArray *tmpArray = [NSMutableArray array];
    NSDictionary *dicForKey = [[self jobHazardsList] objectForKey:key];
        for (NSDictionary *dic in dicForKey) {
            SZJobHazard *jobHazard = [SZJobHazard jobHazardWithDic:dic];
            [tmpArray addObject:jobHazard];
        }
    return tmpArray;
}

@end
