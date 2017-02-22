//
//  NSObject+MDObjectTool.m
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/16.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import "NSObject+MDObjectTool.h"

@implementation NSObject (MDObjectTool)


-(BOOL)IsAutomaticOpen{
    NSString* isAutomatickey=[[NSUserDefaults standardUserDefaults] objectForKey:IsAutomatickey];

    if (isAutomatickey==nil||[isAutomatickey isEqualToString:@"0"]) {
        return NO;
    }else{
        return YES;
    }
}


@end
