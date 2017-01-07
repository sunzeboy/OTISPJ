//
//  SZYearCheckItem.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/24.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZYearCheckItem.h"
#import "NSDate+Extention.h"

@implementation SZYearCheckItem


-(NSInteger)YCheckADateInt{
    
    NSTimeInterval secs = self.PDate/10000000 - 62135557865;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    [format setDateFormat:@"yyyy"];
    
    NSString *str = [format stringFromDate:date];
    
    return str.integerValue;

}

-(float)YCheckDateMMddInt{
    NSTimeInterval secs = self.PDate/10000000 - 62135557865;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    [format setDateFormat:@"MM.dd"];
    
    NSString *str = [format stringFromDate:date];
    
    return str.floatValue;
}

-(BOOL)isDone{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM.dd"];
    float  currentDateInt = [[dateFormatter stringFromDate:currentDate] floatValue];
    
    
    NSDateFormatter *dateFormatterYear = [[NSDateFormatter alloc] init];
    [dateFormatterYear setDateFormat:@"YYYY"];
    int  currentYearInt = [[dateFormatterYear stringFromDate:currentDate] intValue];
    
    
    if (self.YCheckDateMMddInt>currentDateInt) {
        if (self.YCheckADateInt>currentYearInt) {
            return currentYearInt-1 == self.YCheckADateInt;

        }else{
            return currentYearInt == self.YCheckADateInt;

        }
    }else {
        return currentYearInt == self.YCheckADateInt;
    }
    
    return NO;


}


@end
