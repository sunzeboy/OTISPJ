//
//  MDSVTModel.h
//  OTIS_PJ
//
//  Created by 杜亚伟 on 2017/2/28.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDSVTModel : NSObject


@property(nonatomic,strong) NSArray* ControllerEvents;

@property(nonatomic,strong) NSArray* ElapsedMinutes;

@property(nonatomic,strong) NSArray* NumberOfRuns;

@property(nonatomic,strong) NSArray* SCN;

@property(nonatomic,strong) NSArray* SoftwareBaselineVersion;


@property(nonatomic,strong) NSMutableArray* detailModelArray;

+(instancetype)mdSvtModelWithDic:(NSDictionary*)dic;
@end


@interface MDSVTModelDetail : NSObject

/*
 
 CarPosition = "**";
 Counter = 014;
 ElapsedTime = 001222;
 EventNumber = 0213;
 EventSubcode = "";
 TextOfEvent = "DrvPrepErr+";
 
 */

@property (nonatomic,copy) NSString* CarPosition;
@property (nonatomic,copy) NSString* Counter;
@property (nonatomic,copy) NSString* ElapsedTime;
@property (nonatomic,copy) NSString* EventNumber;
@property (nonatomic,copy) NSString* EventSubcode;
@property (nonatomic,copy) NSString* TextOfEvent;

+(instancetype)mdSvtModelDetailWithDic:(NSDictionary*)dic;
@end



@interface MDSVTLastModel : NSObject

/*
 
 {
 
 ControllerEvents =             {
 CarPosition = 05;
 Counter = 050;
 ElapsedTime = 001222;
 TextOfEvent = "+DFCM+Fault";
 };
 
 ErrorData =             (
 {
 ErrorCode = "";
 Step = "GECB+macro+step41";
 },
 {
 ErrorCode = "";
 Step = "GDCB+macro+step3";
 },
 {
 ErrorCode = "";
 Step = "GDCB+macro+step3";
 }
 );
 EventNumber =             (
 0218,
 0218
 );
 
 }
 
 
 */
@property (nonatomic,copy) NSString* CarPosition;
@property (nonatomic,copy) NSString* Counter;
@property (nonatomic,copy) NSString* ElapsedTime;
@property (nonatomic,strong) NSArray* EventNumber;
@property (nonatomic,copy) NSString* EventSubcode;
@property (nonatomic,copy) NSString* TextOfEvent;

@property (nonatomic,copy) NSString* IsEventLogComplete;
@property (nonatomic,strong) NSArray* ErrorData;

@property(nonatomic,strong)MDSVTModelDetail* detailModel;
+(instancetype)mdSvtLastModelWithDic:(NSDictionary*)dic;
@end




