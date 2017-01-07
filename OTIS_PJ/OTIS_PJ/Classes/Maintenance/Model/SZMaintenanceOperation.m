//
//  SZMaintenanceOperation.m
//  OTIS_PJ
//
//  Created by zy on 16/5/5.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZMaintenanceOperation.h"

@implementation SZMaintenanceOperation



- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)maintenanceOperationWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}


+ (NSArray *)maintenanceOperationsList{
    //加载plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"maintenanceOperation" ofType:@"plist"];
    NSArray *dicArray = [NSArray arrayWithContentsOfFile:path];
    
    //字典转模型
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSDictionary *dic in dicArray) {
        SZMaintenanceOperation *maintenanceOperation = [SZMaintenanceOperation maintenanceOperationWithDic:dic];
        [tmpArray addObject:maintenanceOperation];
    }
    return tmpArray;
}

@end
