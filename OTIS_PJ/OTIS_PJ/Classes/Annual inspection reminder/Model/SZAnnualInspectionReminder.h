//
//  SZAnnualInspectionReminder.h
//  OTIS_PJ
//
//  Created by jQ on 16/5/10.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZAnnualInspectionReminder : NSObject
// 电梯型号
@property (nonatomic,copy) NSString *modelTypeImage;
// 电梯编号
@property (nonatomic,copy) NSString *unitNo;
// 电梯型号
@property (nonatomic,copy) NSString *modelType;
// 超过天数
@property (nonatomic,copy) NSString *overDate;
// 路线
@property (nonatomic,copy) NSString *route;
// 工地
@property (nonatomic,copy) NSString *buildingName;
// 地址
@property (nonatomic,copy) NSString *buildingAddr;
// 电梯负责人
@property (nonatomic,copy) NSString *elevatorOwner;
// 电话
@property (nonatomic,copy) NSString *tel;
// 计划年检日期
@property (nonatomic,copy) NSString *yCheakPDate;
// 实际年检日期
@property (nonatomic,copy) NSString *yCheakADate;

- (instancetype)initWithDic:(NSDictionary *)dic;

+ (instancetype)annualWithDic:(NSDictionary *)dic;
+ (SZAnnualInspectionReminder *)reminderDetail;
@end
