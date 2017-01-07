//
//  SZMaintenanceCheckItem.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/26.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZMaintenanceCheckItem : NSObject


/**
 * 
 */
@property (nonatomic , copy) NSString *ItemCode;
/**
 *
 */
@property (nonatomic , copy) NSString *ItemName;

/**
 *
 */
@property (nonatomic , assign) int CardType;

/**
 *
 */
@property (nonatomic , copy) NSString * Description;

/**
 *
 */
@property (nonatomic , assign) int Type;

/**
 *
 */
@property (nonatomic , assign) int  IsStandard;

/**
 *
 */
@property (nonatomic , assign) int  IsSafetyItem;
//＊＊＊＊＊＊＊＊＊＊另外添加的属性＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
/** SZMaintenanceOperationTableViewCell的高度 */
@property (assign, nonatomic) CGFloat operationTableViewCellHeight;

/**
 *
 */
@property (nonatomic , assign) int  state;
//--------------附加
@property (nonatomic , assign) BOOL ischanged;
@property (nonatomic , assign) int  state2;


@property (nonatomic , assign) NSInteger  SchedulesId;
@property (nonatomic , assign) BOOL isUpload;
//@property (nonatomic , assign) BOOL isRepair;



@end
