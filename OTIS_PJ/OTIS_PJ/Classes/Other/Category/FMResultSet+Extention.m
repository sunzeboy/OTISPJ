//
//  FMResultSet+Extention.m
//  OTIS_PJ
//
//  Created by sunze on 16/7/8.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "FMResultSet+Extention.h"

@implementation FMResultSet (Extention)
/**
 *  float a=0.12345f;
 int t=(int)(a*100+0.5f);
 a=(float)t/100;
 *
 *  @param columnName <#columnName description#>
 *
 *  @return <#return value description#>
 */
-(float)floatForColumn:(NSString *)columnName{

    NSArray *dateStrArray = [[self stringForColumn:columnName] componentsSeparatedByString:@":"];
    int xiaoshi = [dateStrArray[0] intValue];
    float fenzhong = [dateStrArray[1] intValue]/60.00;
    int fz = (int)(fenzhong*100+0.5f);
    return xiaoshi+(float)fz/100;
}


 

@end
