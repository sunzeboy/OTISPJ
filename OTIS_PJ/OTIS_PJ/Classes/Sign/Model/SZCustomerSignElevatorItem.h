//
//  SZCustomerSignElevatorItem.h
//  OTIS_PJ
//
//  Created by jQ on 16/5/4.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZCustomerSignElevatorItem : NSObject
//保养项目码
@property(nonatomic,copy) NSString *itemCode;
//保养项目编号
@property(nonatomic,copy) NSString *itemName;
//是否国标保养项目
@property(nonatomic,assign) BOOL isStandard;

- (instancetype)initWithDic:(NSDictionary *)dic;

+ (instancetype)signElevatorItemWithDic:(NSDictionary *)dic;
+ (NSArray *)elevatorItemList;
@end
