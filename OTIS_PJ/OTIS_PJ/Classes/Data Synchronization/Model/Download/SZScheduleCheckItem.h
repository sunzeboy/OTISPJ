//
//  SZScheduleCheckItem.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/25.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZScheduleCheckItem : NSObject

/**
 * 
 */
@property (nonatomic , copy) NSString *ItemCode;

/**
 *
 */
@property (nonatomic , assign) int CardType;
/**
 *
 */
@property (nonatomic , assign) int Times;

@end
