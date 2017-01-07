//
//  SZTodayMaintenance.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/10.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZFinalMaintenanceUnitItem : NSObject


//------------------------------------------------------------------------------------------------------------------------------------------------

/**
 * 电梯编号*
 */
@property (nonatomic , copy) NSString *UnitNo;
@property (nonatomic , copy) NSString *UnitName;

/**
 * 电梯二维码
 */
@property (nonatomic , copy) NSString *UnitRegcode;

/**
 * 保养报告类型（电梯图标类型）*
 */
@property (nonatomic , assign) NSInteger CardType;
@property (nonatomic , copy) NSString *CardTypeStr;

/**
 * 年检日期*
 */
@property (nonatomic , assign) NSInteger YCheckDate;
@property (nonatomic , copy) NSString *YCheckDateStr;
@property (nonatomic , copy) NSString *YCheckDateMMddStr;
@property (nonatomic , assign) float YCheckDateMMddInt;
@property (nonatomic , copy) NSString *YCheckDateDisplayStr;

@property (nonatomic , assign) NSInteger PDate_Save;

//------------------------------------------------------------------------------------------------------------------------------------------------


/**
 * 工地名*
 */
@property (nonatomic , copy) NSString *BuildingName;

/**
 * 工地路线*
 */
@property (nonatomic , copy) NSString *Route;



//--------------附加


/**
 * 工地编号
 */
@property (nonatomic , assign) NSInteger BuildingNo;
@property (nonatomic , copy) NSString *BuildingNoStr;




//------------------------------------------------------------------------------------------------------------------------------------------------

/**
 * 次数*
 */
@property (nonatomic , assign) NSInteger Times;
@property (nonatomic , copy) NSString *TimesStr;
/**
 * 计划保养日期*
 */
@property (nonatomic , assign) NSInteger CheckDate;
@property (nonatomic , copy) NSString *CheckDateStr;


/**
 *
 */
@property (nonatomic , assign) NSInteger ScheduleID;
//------------------------------------------------------------------------------------------------------------------------------------------------


//--------------附加
@property (nonatomic , assign) BOOL selected;
@property (nonatomic , assign) BOOL showSelected;

/**
 *  自己做的保养，并且是已经上传的维修换件的记录，显示红叉，默认是NO
 */
@property (nonatomic , assign) BOOL isFixMode;


@property (nonatomic , assign) NSInteger Reason;

@property (nonatomic , assign) BOOL IS_UPLOADING;

//--------------附加
@property (nonatomic , copy) NSString *showDateStr;
@property (nonatomic , assign) NSInteger OverdueDays;
@property (nonatomic , copy) NSString *inNextTwoMonths;
@property (nonatomic , assign) NSInteger TipDays;
@property (nonatomic , assign) BOOL isChaoqi;

@property (nonatomic , assign) BOOL isAnnualled;

/**
 *  签字底部的textView的text
 */
@property (nonatomic , copy) NSString * question;

@property (nonatomic , copy) NSString *shengyuDate;

@end
