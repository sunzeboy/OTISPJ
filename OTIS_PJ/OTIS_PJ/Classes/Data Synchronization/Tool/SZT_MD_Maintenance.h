//
//  SZT_MD_Maintenance.h
//  OTIS_PJ
//
//  Created by sunze on 2017/3/10.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ReqEventLogAndMaintenance : NSObject

@property (nonatomic , assign) NSInteger scheduleID;
@property (nonatomic , copy) NSString *unitNo;
@property (nonatomic , strong) NSArray *item;
@property (nonatomic , copy) NSString *recordTime;
@property (nonatomic , copy) NSString *employeeID;
@property (nonatomic , copy) NSString *username;
@property (nonatomic , copy) NSString *appVer;
@property (nonatomic , copy) NSString *startTime;
@property (nonatomic , copy) NSString *endTime;
@property (nonatomic , copy) NSString *eventLog;
@property (nonatomic , assign) BOOL isCompleteCtrl;
@property (nonatomic , assign) BOOL isCompleteDri;
@property (nonatomic , copy) NSString *ctrlSoftwareVer;
@property (nonatomic , copy) NSString *driSoftwareVer;

@end





@interface ItemInfo : NSObject

@property (nonatomic , assign) NSInteger itemState;
@property (nonatomic , assign) NSInteger itemStateAuto;
@property (nonatomic , copy) NSString *itemCode;
@property (nonatomic , copy) NSString *reason;

@end



@interface SZT_MD_Maintenance : NSObject

+(void)storge:(ReqEventLogAndMaintenance *)model;


+(NSArray<ReqEventLogAndMaintenance *>*)mdList;


@end
