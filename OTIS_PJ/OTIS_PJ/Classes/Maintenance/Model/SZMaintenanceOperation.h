//
//  SZMaintenanceOperation.h
//  OTIS_PJ
//
//  Created by zy on 16/5/5.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZMaintenanceOperation : NSObject

// checkbox图片
@property (nonatomic,copy) NSString *icon;

// 保养操作Id
@property (nonatomic,copy) NSString *operationId;
// 保养操作名称
@property (nonatomic,copy) NSString *operationName;

- (instancetype)initWithDic:(NSDictionary *)dic;

+ (instancetype)maintenanceOperationWithDic:(NSDictionary *)dic;

+ (NSArray *)maintenanceOperationsList;
@end
