//
//  SZWorkingHoursType.h
//  OTIS_PJ
//
//  Created by zy on 16/4/28.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZWorkingHoursType : NSObject

// 工时图片
@property (nonatomic,copy) NSString *workTypeImage;
// 图片名称
@property (nonatomic,copy) NSString *imageName;

- (instancetype)initWithDic:(NSDictionary *)dic;

+ (instancetype)workingHoursTypesWithDic:(NSDictionary *)dic;

+ (NSArray *)workingHoursTypesList:(NSString *)strImageName;

@end
