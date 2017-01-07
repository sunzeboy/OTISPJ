//
//  SZCustomerSignDetail.m
//  OTIS_PJ
//
//  Created by jQ on 16/5/16.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZCustomerSignDetail.h"

@implementation SZCustomerSignDetail
- (instancetype)initWithDic:(NSDictionary *)dic
{
    if(self = [super init]){
        
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)signDetailWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}

+ (SZCustomerSignDetail *)signDetail{
    //加载plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"signDetailList" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    //字典转模型
    SZCustomerSignDetail *detail = [SZCustomerSignDetail signDetailWithDic:dic];
    detail.signatureImage = nil;
    return detail;
}
@end
