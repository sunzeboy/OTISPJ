//
//  SZUploadFixResponse.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/30.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZUploadFixResponse : NSObject

/**
 */
@property (nonatomic , copy) NSString *Result;
/**
 */
@property (nonatomic , copy) NSString *ScheduleID;
/**
 */
@property (nonatomic , copy) NSString *UnitNo;
/**
 */
@property (nonatomic , copy) NSString * User;
/**
 */
@property (nonatomic , assign) NSInteger Type;

@property (nonatomic , assign) int SignID;

@end
