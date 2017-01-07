//
//  SZPassWordChange.m
//  OTIS_PJ
//
//  Created by jQ on 16/5/12.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZPassWordChange.h"

@implementation SZPassWordChange
- (instancetype)initWithDic:(NSDictionary *)dic
{
    if(self = [super init]){
        
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)changePassWordWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}

+ (SZPassWordChange *)changePassWord{
    //加载plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"passWordList" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    //字典转模型
    SZPassWordChange *changePW = [SZPassWordChange changePassWordWithDic:dic];
    return changePW;
}
@end