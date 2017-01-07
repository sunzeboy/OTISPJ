//
//  SZSign.h
//  OTIS_PJ
//
//  Created by ousingi on 16/4/27.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZSign : NSObject
// 电梯类型
@property (nonatomic,copy) NSString *modelType;
// 电梯Id
@property (nonatomic,copy) NSString *elevatorId;
// 所属机构
@property (nonatomic,copy) NSString *organizationName;
// 日期分类
@property (nonatomic,copy) NSString *dateType;
// 日期
@property (nonatomic,copy) NSString *date;
// 签字选择
@property (nonatomic,assign) BOOL sign;

- (instancetype)initWithDic:(NSDictionary *)dic;

+ (instancetype)signWithDic:(NSDictionary *)dic;
+ (NSArray *)signList;
@end
