//
//  SZMaintainDetail.h
//  OTIS_PJ
//
//  Created by zy on 16/5/4.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZMaintainDetail : NSObject

// 电梯编号
@property (nonatomic,copy) NSString *elevatorNo;
// 计划日期
@property (nonatomic,copy) NSString *plannedDate;
// 日期分类
@property (nonatomic,copy) NSString *dateType;
// 本次保养项目数
@property (nonatomic,copy) NSString *projectCount;
// 电梯型号
@property (nonatomic,copy) NSString *elevatorModel;
// 工地
@property (nonatomic,copy) NSString *company;
// 电梯负责人
@property (nonatomic,copy) NSString *elevatorPrincipal;
// 电话
@property (nonatomic,copy) NSString *phone;
// 二维码信息
@property (nonatomic,copy) NSString *barcodeInfo;
// 坐标X
@property (nonatomic,copy) NSString *coordinateX;
// 坐标Y
@property (nonatomic,copy) NSString *coordinateY;
// 图片
@property (nonatomic,copy) NSString *icon;
// 机构
@property (nonatomic,copy) NSString *organization;
// 路线
@property (nonatomic,copy) NSString *line;
// 电梯数量
@property (nonatomic,copy) NSString *elevatorCount;
// 地址
@property (nonatomic,copy) NSString *address;

- (instancetype)initWithDic:(NSDictionary *)dic;

+ (instancetype)maintainDetailWithDic:(NSDictionary *)dic;

+ (NSArray *)elevatorInfosList;

@end
