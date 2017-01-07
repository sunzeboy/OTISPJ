//
//  SZTodayMaintenance.m
//  OTIS_PJ
//
//  Created by sunze on 16/5/10.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZFinalMaintenanceUnitItem.h"
#import "NSDate+Extention.h"


@implementation SZFinalMaintenanceUnitItem


-(NSString *)BuildingNoStr{
    return [[NSNumber numberWithInteger:self.BuildingNo] stringValue];
}

-(NSString *)CheckDateStr{
    
    NSTimeInterval secs = self.CheckDate/10000000 - 62135557865;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    [format setDateFormat:@"yyyy-MM-dd"];
    
    NSString *str = [format stringFromDate:date];
    
    return str;
}

-(NSString *)TimesStr
{
    NSString *strTime = [[NSNumber numberWithInteger:self.Times] stringValue];
    NSString *strLast = [strTime substringFromIndex:strTime.length-1];
    NSString *strMonth = [strTime substringToIndex:strTime.length-1];
    if ([strLast isEqualToString:@"1"]) {
        
        return [NSString stringWithFormat:@"%@月%@",strMonth,SZLocal(@"time.firstHalfOfTheMonth")];
    }else if ([strLast isEqualToString:@"2"]){
        
        return [NSString stringWithFormat:@"%@月%@",strMonth,SZLocal(@"time.lastHalfOfTheMonth")];

    }else{
        return [NSString stringWithFormat:@"%@月备用%d",strMonth,strLast.intValue-2];
    }
    
    return nil;
}

-(NSString *)shengyuDate{

    NSInteger day = [NSDate mondayWithDate:self.CheckDateStr];
    
    return [NSString stringWithFormat:@"剩余%ld天",day];
}

-(NSString *)CardTypeStr
{
    return [NSString stringWithFormat:@"%ld.jpg",(long)self.CardType];
}


-(NSString *)YCheckDateStr{
    NSTimeInterval secs = self.YCheckDate/10000000 - 62135557865;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    [format setDateFormat:@"yyyy-MM-dd"];
    
    NSString *str = [format stringFromDate:date];
    
    return str;
}


-(NSString *)YCheckDateMMddStr{
    NSTimeInterval secs = self.YCheckDate/10000000 - 62135557865;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    [format setDateFormat:@"MM-dd"];
    
    NSString *str = [format stringFromDate:date];
    
    return str;
}

-(float)YCheckDateMMddInt{
    NSTimeInterval secs = self.YCheckDate/10000000 - 62135557865;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    [format setDateFormat:@"MM.dd"];
    
    NSString *str = [format stringFromDate:date];
    
    return str.floatValue;
}

-(NSString *)BuildingName{
    
    NSString *str = _BuildingName;
    NSMutableString *str1 = [NSMutableString string];
    NSUInteger length = [str length];
    for (int i=0; i<length; ++i)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [str substringWithRange:range];
        const char  *cString = [subString UTF8String];
        if (strlen(cString) == 3)
        {
            [str1 appendString:subString];
        }
        
    }
    return [NSString stringWithString:str1];
}




-(NSString *)showDateStr{

    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM.dd"];
    float  currentDateInt = [[dateFormatter stringFromDate:currentDate] floatValue];
    
    
    NSDateFormatter *dateFormatterYear = [[NSDateFormatter alloc] init];
    [dateFormatterYear setDateFormat:@"YYYY"];
    int  currentYearInt = [[dateFormatterYear stringFromDate:currentDate] intValue];

    NSString *strDate = [[NSString stringWithFormat:@"%.2f",self.YCheckDateMMddInt] stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    
    if (self.YCheckDateMMddInt>currentDateInt) {
        return [NSString stringWithFormat:@"%d-%@",currentYearInt-1,strDate];
    }else{
        return [NSString stringWithFormat:@"%d-%@",currentYearInt,strDate];
    }

    return @"";

}

-(NSInteger)OverdueDays{

    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM.dd"];
    float  currentDateInt = [[dateFormatter stringFromDate:currentDate] floatValue];
    
    
    NSDateFormatter *dateFormatterYear = [[NSDateFormatter alloc] init];
    [dateFormatterYear setDateFormat:@"YYYY"];
    int  currentYearInt = [[dateFormatterYear stringFromDate:currentDate] intValue];
    
    NSString *strDate = [[NSString stringWithFormat:@"%.2f",self.YCheckDateMMddInt] stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    
    if (self.YCheckDateMMddInt>currentDateInt) {
        NSString *str = [NSString stringWithFormat:@"%d-%@",currentYearInt-1,strDate];
        return [self computeDaysWithDataFromString:str];
    }else{
        NSString *str = [NSString stringWithFormat:@"%d-%@",currentYearInt,strDate];
        return [self computeDaysWithDataFromString:str];

    }
    
    return 0;
}

-(NSString *)inNextTwoMonths{
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM.dd"];
    float  currentDateInt = [[dateFormatter stringFromDate:currentDate] floatValue];
    
    
    NSDateFormatter *dateFormatterYear = [[NSDateFormatter alloc] init];
    [dateFormatterYear setDateFormat:@"YYYY"];
    int  currentYearInt = [[dateFormatterYear stringFromDate:currentDate] intValue];
    
    NSString *strDate = [[NSString stringWithFormat:@"%.2f",self.YCheckDateMMddInt] stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    
    if (self.YCheckDateMMddInt-currentDateInt>0 && self.YCheckDateMMddInt-currentDateInt<2) {
        
        return [NSString stringWithFormat:@"%d-%@",currentYearInt,strDate];
    }
    
    return nil;

}



-(NSInteger)TipDays{
    
    if (self.inNextTwoMonths) {
        return [self computeDaysWithDataFromString:self.inNextTwoMonths];
    }
    return 0;
}

//计算日期间隔天数
- (NSInteger)computeDaysWithDataFromString:(NSString *)string
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:[dateFormatter dateFromString:string]];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:[NSDate date]];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return dayComponents.day;
}

@end
