//
//  SZMaintain.m
//  OTIS_PJ
//
//  Created by zy on 16/4/26.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZMaintain.h"

@implementation SZMaintain


- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)maintainWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}


+ (NSArray *)maintainsList{
    //加载plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"records" ofType:@"plist"];
    NSArray *dicArray = [NSArray arrayWithContentsOfFile:path];
    
    //字典转模型
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSDictionary *dic in dicArray) {
        SZMaintain *maintain = [SZMaintain maintainWithDic:dic];
        [tmpArray addObject:maintain];
    }
    return tmpArray;
}

@end
