//
//  SZTodayMaintenance.m
//  OTIS_PJ
//
//  Created by sunze on 16/5/10.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZFinalMaintenanceItem.h"
#import "NSDate+Extention.h"

@implementation SZFinalMaintenanceItem

- (NSString *)description
{
    return [NSString stringWithFormat:@"BuildingNo:%ld,BuildingName:%@,BuildingAddr:%@,Route:%@,Times:%ld,Year:%ld", self.BuildingNo,self.BuildingName,self.BuildingAddr,self.Route,self.Times,self.Year];
}

-(NSString *)BuildingNoStr{
    return [[NSNumber numberWithInteger:self.BuildingNo] stringValue];
}

-(NSString *)CheckDateStr{
    
//    NSInteger time = [NSDate sinceDistantPast]/10000000 -[NSDate date].timeIntervalSince1970-3*24*3600;
//    SZLog(@"%ld",time);
//    
//    NSTimeInterval secs = 635983488000000000/10000000 - time;
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
//    
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setDateFormat:@"yyyy-MM-dd"];
//    SZLog(@"%@",[format stringFromDate:date]);
    
    NSTimeInterval secs = self.CheckDate/10000000 - 62135557865;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    return [format stringFromDate:date];
    
}

-(NSString *)TimesStr
{
    NSString *strTime = [[NSNumber numberWithInteger:self.Times] stringValue];
    NSString *strLast = [strTime substringFromIndex:strTime.length-1];
    NSString *strMonth = [strTime substringToIndex:strTime.length-1];
    if ([strLast isEqualToString:@"1"]) {
        
        return [NSString stringWithFormat:@"%@%@",strMonth,SZLocal(@"time.firstHalfOfTheMonth")];
    }else if ([strLast isEqualToString:@"2"]){
        
        return [NSString stringWithFormat:@"%@%@",strMonth,SZLocal(@"time.lastHalfOfTheMonth")];

    }
    
    return nil;
}

-(NSString *)CardTypeStr
{
    return [NSString stringWithFormat:@"%ld.png",self.CardType];
}

@end
