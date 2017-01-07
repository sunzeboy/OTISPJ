//
//  SZSign.m
//  OTIS_PJ
//
//  Created by ousingi on 16/4/27.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZSign.h"

@implementation SZSign

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if(self = [super init]){
    
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}


+ (instancetype)signWithDic:(NSDictionary *)dic{
    return [[self alloc] initWithDic:dic];
}



+ (NSArray *)signList{
    //加载plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"signlist" ofType:@"plist"];
    NSArray *dicArray = [NSArray arrayWithContentsOfFile:path];
    
    //字典转模型
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSDictionary *dic in dicArray) {
        SZSign *szsign = [SZSign signWithDic:dic];
        [tmpArray addObject:szsign];
    }
    return tmpArray;
}

@end
