//
//  SZJHATitleItem.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/20.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZJHATitleItem : NSObject

/**
 *
 */
@property (nonatomic , copy) NSString *title;


/**
 *
 */
@property (nonatomic , assign) NSInteger JhaTypeId;


/**
 *
 */
@property (nonatomic , assign) NSInteger JhaItemType;

/**
 *
 */
@property (nonatomic , copy) NSString *JhaCode;
/**
 *
 */
@property (nonatomic , assign,) NSInteger JhaCodeId;
/**
 *
 */
@property (nonatomic , copy) NSString *Name;
/**
 *
 */
@property (nonatomic , copy) NSString *Other;

//------------------------------------------------------------------------------------------------------------------------------------------------
//
@property (nonatomic,assign) BOOL select;

@property (nonatomic , copy) NSString *Remark;
@end
