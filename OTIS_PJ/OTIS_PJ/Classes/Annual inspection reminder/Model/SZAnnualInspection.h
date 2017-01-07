//
//  SZAnnualInspection.h
//  OTIS_PJ
//
//  Created by jQ on 16/5/9.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZAnnualInspection : NSObject
// 电梯编号
@property (nonatomic,copy) NSString *unitNo;
// 所属机构
@property (nonatomic,copy) NSString *organizationName;
// Id
@property (nonatomic,copy) NSString *route;
// 超过天数
@property (nonatomic,copy) NSString *overDate;
// 年检日期
@property (nonatomic,copy) NSString *yCheakPDate;
// 电梯类型
@property (nonatomic,copy) NSString *modelType;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)annualInspectionWithDic:(NSDictionary *)dic;
+ (NSArray *)annualInspectionList;
@end
