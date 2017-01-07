//
//  SZFinalMaintenanceUnitDetialItem.m
//  OTIS_PJ
//
//  Created by sunze on 16/5/17.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZFinalMaintenanceUnitDetialItem.h"
#import "NSDate+Extention.h"



@implementation SZFinalMaintenanceUnitDetialItem

-(NSString *)Owner{

    NSString *str =_Owner;
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
