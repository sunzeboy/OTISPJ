//
//  SZYearCheckItem.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/24.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZYearCheckItem : NSObject

/**
 *
 */
@property (nonatomic , assign) NSInteger PDate;
@property (nonatomic , assign) NSInteger PDate_Save;

/**
 *
 */
@property (nonatomic , assign) NSInteger ADate;
@property (nonatomic , assign) NSInteger YCheckADateInt;

/**
 *
 */
@property (nonatomic , copy) NSString *UnitNo;
/**
 *
 */
@property (nonatomic , copy) NSString *EmployeeId;


@property (nonatomic , assign) BOOL is_UPLOADING;
//--------------附加
@property (nonatomic , assign) BOOL isDone;



@end
