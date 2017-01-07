//
//  SZJobHazard.h
//  OTIS_PJ
//
//  Created by zy on 16/5/5.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZJobHazard : NSObject

// checkbox图片
@property (nonatomic,copy) NSString *icon;
// 危险项目
@property (nonatomic,copy) NSString *hazardName;

- (instancetype)initWithDic:(NSDictionary *)dic;

+ (instancetype)jobHazardWithDic:(NSDictionary *)dic;

+ (NSDictionary *)jobHazardsList;

+ (NSArray *)jobHazardsGroupList : (NSString *)key;


@end
