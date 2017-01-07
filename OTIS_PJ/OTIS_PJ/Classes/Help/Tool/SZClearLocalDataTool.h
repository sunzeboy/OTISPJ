//
//  SZClearLocalDataTool.h
//  OTIS_PJ
//
//  Created by sunze on 16/7/11.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZClearLocalDataTool : NSObject

+(BOOL)hasUploadData;

+(void)clearLocalDataWithView:(UIView *)view;

+(void)clearData;

+(void)clear;
@end
