//
//  SZFinalOutsidePlanMaintenanceItem.m
//  OTIS_PJ
//
//  Created by sunze on 16/5/11.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZFinalOutsidePlanMaintenanceItem.h"

@implementation SZFinalOutsidePlanMaintenanceItem

-(NSString *)BuildingName{
    
    NSString *str =_BuildingName;
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

@end
