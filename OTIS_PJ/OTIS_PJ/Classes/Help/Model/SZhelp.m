//
//  SZhelp.m
//  OTIS_PJ
//
//  Created by jQ on 16/5/11.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZHelp.h"

@implementation SZHelp
- (instancetype)initWithDic:(NSDictionary *)dic
{
    if(self = [super init]){
        
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)helpWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}

+ (NSArray *)helpList{
    //加载plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"helpList" ofType:@"plist"];
    NSArray *dicArray = [NSArray arrayWithContentsOfFile:path];
    
    //字典转模型
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSDictionary *dic in dicArray) {
        SZHelp *help = [SZHelp helpWithDic:dic];
        [tmpArray addObject:help];
    }
    return tmpArray;
}
@end
