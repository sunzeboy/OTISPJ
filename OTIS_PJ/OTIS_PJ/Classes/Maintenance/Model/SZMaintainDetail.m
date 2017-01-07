//
//  SZMaintainDetail.m
//  OTIS_PJ
//
//  Created by zy on 16/5/4.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZMaintainDetail.h"

@implementation SZMaintainDetail

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)maintainDetailWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}


+ (NSArray *)elevatorInfosList{
    //加载plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"elevatorInfos" ofType:@"plist"];
    NSArray *dicArray = [NSArray arrayWithContentsOfFile:path];
    
    //字典转模型
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSDictionary *dic in dicArray) {
        SZMaintainDetail *maintainDetail = [SZMaintainDetail maintainDetailWithDic:dic];
        [tmpArray addObject:maintainDetail];
    }
    return tmpArray;
}

@end
