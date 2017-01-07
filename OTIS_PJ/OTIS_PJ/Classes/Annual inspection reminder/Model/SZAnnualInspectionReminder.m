//
//  SZAnnualInspectionReminder.m
//  OTIS_PJ
//
//  Created by jQ on 16/5/10.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZAnnualInspectionReminder.h"

@implementation SZAnnualInspectionReminder
- (instancetype)initWithDic:(NSDictionary *)dic
{
    if(self = [super init]){
        
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)annualWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}

+ (SZAnnualInspectionReminder *)reminderDetail{
    //加载plist
//    SZLog(@"model1");
    NSString *path = [[NSBundle mainBundle] pathForResource:@"reminderList" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    //字典转模型
    SZAnnualInspectionReminder *remander = [SZAnnualInspectionReminder annualWithDic:dic];

//    SZLog(@"model2");
    return remander;
}
@end
