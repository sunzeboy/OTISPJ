//
//  SZMaintain.h
//  OTIS_PJ
//
//  Created by zy on 16/4/26.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZMaintain : NSObject

// 图片
@property (nonatomic,copy) NSString *icon;
// 电梯Id
@property (nonatomic,copy) NSString *elevatorId;
// 所属机构
@property (nonatomic,copy) NSString *organizationName;
// 编号
@property (nonatomic,copy) NSString *serialNumber;
// 日期分类
@property (nonatomic,copy) NSString *dateType;
// 日期
@property (nonatomic,copy) NSString *date;

- (instancetype)initWithDic:(NSDictionary *)dic;

+ (instancetype)maintainWithDic:(NSDictionary *)dic;

+ (NSArray *)maintainsList;

@end
