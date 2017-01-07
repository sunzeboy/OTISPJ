//
//  SZWorkingHours.h
//  OTIS_PJ
//
//  Created by zy on 16/5/9.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZWorkingHours : NSObject

// 工时类型
@property (nonatomic,copy) NSString *workType;
// 日期
@property (nonatomic,copy) NSString *workDate;
// PUI编号
@property (nonatomic,copy) NSString *puiNumber;
// 删除按钮是否显示flg
@property (nonatomic,copy) NSString *delImgDisFlg;
// ＊1平日工时
@property (nonatomic,copy) NSString *weekday;
// ＊平日加班工时
@property (nonatomic,copy) NSString *overtimeOnWeekday;
// ＊2双休日加班工时
@property (nonatomic,copy) NSString *overtimeOnWeekend;
// ＊国定假日加班工时
@property (nonatomic,copy) NSString *overtimeOnStatutoryHoliday;

- (instancetype)initWithDic:(NSDictionary *)dic;

+ (instancetype)workingHourWithDic:(NSDictionary *)dic;

+ (NSArray *)workingHoursList;


@end
