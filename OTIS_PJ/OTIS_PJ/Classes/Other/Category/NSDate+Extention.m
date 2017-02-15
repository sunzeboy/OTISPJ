//
//  NSDate+Extention.m
//  OTIS_PJ
//
//  Created by sunze on 16/5/10.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "NSDate+Extention.h"
#import <Foundation/NSTimeZone.h>
#import "NSDate+Format.h"

@implementation NSDate (Extention)

+(long)sinceDistantPastTime{
//    NSDate *distantPast = [NSDate distantPast];
//    NSDate *currentTime1 = [NSDate date];
//
//    NSTimeInterval time = [currentTime timeIntervalSinceDate:distantPast];
//    return time*10000000;
    
    
    // utc 时间，是伦敦时区
    NSDate *localeDate = [NSDate localeDate];
    
    // 转换为秒数
    long retLong = [localeDate timeIntervalSince1970 ];
    // 转换为纳秒＋1970年以前的时间
    long ret = (long)(retLong*10000000 + 621355968000000000);
    return ret;
    
}

+(long)sinceDistantPastToDateTime:(NSDate *)date{
    //    NSDate *distantPast = [NSDate distantPast];
    //    NSDate *currentTime1 = [NSDate date];
    //
    //    NSTimeInterval time = [currentTime timeIntervalSinceDate:distantPast];
    //    return time*10000000;
    
    
    // 转换为秒数
    long retLong = [date timeIntervalSince1970 ];
    // 转换为纳秒＋1970年以前的时间
    long ret = (long)(retLong*10000000 + 621355968000000000);
    return ret;
    
}

+(NSDate *)localeDate{

    // utc 时间，是伦敦时区
    NSDate *date = [NSDate date];
    // 获取当前时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}


+(long)sinceDistantPast{
//http://www.cnblogs.com/Cristen/p/3599922.html

    NSInteger days = [self getDaysFrom:[NSDate distantPast] To:[NSDate date]];
    return days*24*3600*10000000;
}






/**
 *  从公元0000年第一天到某一天的纳秒数
 */
+(NSInteger)sinceDistantPastToDate:(NSDate *)date{
    if (date == nil) return 0;
        
    NSInteger days = [self getDaysFrom:[NSDate distantPast] To:date];
    return days*24*3600*10000000;
//    return (date.timeIntervalSince1970+62135557865)*10000000;
    
}

+(NSInteger)sinceDistantPastToTime:(NSDate *)date{
    if (date == nil) return 0;
    
    NSInteger days = [self getDaysFrom:[NSDate distantPast] To:date];
    return days*24*3600*10000000;
    //    return (date.timeIntervalSince1970+62135557865)*10000000;
    
}

+(NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate
{
    if (endDate == nil) return 0;
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setFirstWeekday:2];
    
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:serverDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return dayComponents.day-2;
}


+(NSInteger)mondayWithDate:(NSString *)dateString{
    
    NSDate *date1 = [NSDate dateFromDateString:dateString];
    NSDate *date2 = [NSDate date];

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp1 = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:date1];
    NSDateComponents *comp2 = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:date2];

    NSInteger daycount1 = [comp1 weekday] - 2;
    NSDate *weekdaybegin1=[date1 dateByAddingTimeInterval:-daycount1*60*60*24];
    
    NSInteger daycount2 = [comp2 weekday] - 2;
    NSDate *weekdaybegin2=[date2 dateByAddingTimeInterval:-daycount2*60*60*24];
    
    NSCalendar *mycal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned units = NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitYear;
    
    //周一
    comp1 =[mycal components:units fromDate:weekdaybegin1];
    comp2 =[mycal components:units fromDate:weekdaybegin2];

//    NSInteger day1 = [comp1 valueForComponent:NSCalendarUnitDay];
//    NSInteger day2 = [comp2 valueForComponent:NSCalendarUnitDay];

//    NSInteger deltDay =  labs(day2-day1);
    NSDateComponents *cps =  [mycal components:units fromDateComponents:comp1 toDateComponents:comp2 options:0];
    NSInteger deltDay =  [cps day];

    NSInteger deltWeek = deltDay/7 ;
    NSInteger delt = 8-[NSDate date].weekday;

    return  (4-deltWeek)*7+delt;

}

+(NSDate *)thisWeekMondayOrNextSunday:(NSString *)dayOfTheWeek{

    NSDate *date = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:date];
    
    NSInteger daycount = [comp weekday] - 2;
    NSDate *weekdaybegin=[date dateByAddingTimeInterval:-daycount*60*60*24];
    NSDate *weekdayend = [date dateByAddingTimeInterval:(6-daycount)*60*60*24];
    NSCalendar *mycal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned units = NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitYear|NSCalendarUnitWeekday;
    
    //周一
    comp =[mycal components:units fromDate:weekdaybegin];
    NSInteger month = [comp month];
    NSInteger year = [comp year];
    NSInteger day = [comp day];

    NSDate *Monday = [mycal dateFromComponents:comp];

    //周日
    comp = [mycal components:units fromDate:weekdayend];
    month = [comp month];
    year = [comp year];
    day = [comp day];
    NSDate *Sunday = [mycal dateFromComponents:comp];

    
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyyMMdd"];
    

    if ([dayOfTheWeek isEqualToString:@"Monday"]) {
        return Monday;

    }else{
        return [Sunday dateByAddingTimeInterval:7*24*3600];

    }
    return nil;
}

+(NSString *)currentTime
{
    //获取系统当前时间
    NSDate*currentDate=[NSDate date];
    //用于格式化NSDate对象
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSDate转NSString
    return [dateFormatter stringFromDate:currentDate];
    
}

+(NSString *)currentTimeNOMaohao
{
    //获取系统当前时间
    NSDate*currentDate=[NSDate date];
    //用于格式化NSDate对象
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    //NSDate转NSString
    return [dateFormatter stringFromDate:currentDate];
    
}

+(NSString *)currentDate{
    //获取系统当前时间
    NSDate*currentDate=[NSDate date];
    //用于格式化NSDate对象
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //NSDate转NSString
    return [dateFormatter stringFromDate:currentDate];

}

+(NSString *)currentDate2{
    //获取系统当前时间
    NSDate*currentDate=[NSDate date];
    //用于格式化NSDate对象
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    //NSDate转NSString
    return [dateFormatter stringFromDate:currentDate];
    
}

+(NSString *)thisWeekMondayOrNextWeekSunday:(NSString *)dayOfTheWeek{

    //获取系统当前时间
    NSDate*day=[NSDate thisWeekMondayOrNextSunday:dayOfTheWeek];
    //用于格式化NSDate对象
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    //NSDate转NSString
    return [dateFormatter stringFromDate:day];
}

+(NSInteger)currentYear{
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear ;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    return  [dateComponent year];
//    int month = [dateComponent month];
//    int day = [dateComponent day];
//    int hour = [dateComponent hour];
//    int minute = [dateComponent minute];
//    int second = [dateComponent second];

}

+(NSInteger)currentMdInt{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitDay|NSCalendarUnitMonth ;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSString *strMd = [NSString stringWithFormat:@"%ld.%ld",[dateComponent month],[dateComponent day]];
    return  strMd.integerValue;

}

+(NSInteger)currentYYMMDD{
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitDay|NSCalendarUnitMonth ;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSString *strMd = [NSString stringWithFormat:@"%ld%ld%ld",[dateComponent year],[dateComponent month],[dateComponent day]];

    return  strMd.integerValue;


}



+ (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [dateFormatter setTimeZone:GTMzone];
    return  [dateFormatter dateFromString:dateString];
    
}

+ (NSDate *)dateTimeFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [dateFormatter setTimeZone:GTMzone];
    return  [dateFormatter dateFromString:dateString];
    
}

+ (NSDate *)dateFromDateString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [dateFormatter setTimeZone:GTMzone];
    return  [dateFormatter dateFromString:dateString];
    
}

+(BOOL)compareDate:(NSString *)dateString{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [NSDate date];
//    NSDate *tomorrow, *yesterday;
//    
//    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
//    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
//    NSString * todayString = [[today description] substringToIndex:10];
//    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
//    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
////   dateString = [[date description] substringToIndex:10];
    
//    if ([dateString isEqualToString:todayString])
//    {
//        return YES;
//    } else if ([dateString isEqualToString:yesterdayString])
//    {
//        return YES;
//    }else if ([dateString isEqualToString:tomorrowString])
//    {
//        return NO;
//    }
//    else
//    {
//        return NO;
//    }
    NSDate *inputDate = [self dateFromString:dateString];
    long inputLong =[inputDate timeIntervalSince1970 ];
    long todayLong =[today timeIntervalSince1970 ];
    
    int todayDay = (int)(todayLong/secondsPerDay );
    int yesterdayDay = (int)(todayLong/secondsPerDay -1);
    int inputDay = (int )inputLong/secondsPerDay;
    
 
    
    if(inputDay > todayDay || inputDay<yesterdayDay){
        return NO;
    }
    
    return YES;
}

+(BOOL)isDateThisWeek:(NSDate *)date {
    
    NSDate *start;
    NSTimeInterval extends;
    
    NSCalendar *cal=[NSCalendar currentCalendar];
    NSDate *today=[NSDate date];
    
    BOOL success= [cal rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&start interval: &extends forDate:today];
    
    if(!success)
        return NO;
    
    NSTimeInterval dateInSecs = [date timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    
    if(dateInSecs > dayStartInSecs+24*60*60 && dateInSecs < (dayStartInSecs+extends+24*60*60)){
        return YES;
    }
    else {
        return NO;
    }
}

+(BOOL)isSameDay:(NSDate *)date {
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

@end
