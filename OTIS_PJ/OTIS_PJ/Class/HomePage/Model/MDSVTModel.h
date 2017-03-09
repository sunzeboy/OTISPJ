//
//  MDSVTModel.h
//  OTIS_PJ
//
//  Created by 杜亚伟 on 2017/2/28.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MDSVTModelDetail;
@class MDSVTLastModel;
@class MDSVTErrorData;
@interface MDSVTModel : NSObject

@property(nonatomic,strong) MDSVTModelDetail* controllerModel;
@property(nonatomic,strong) MDSVTLastModel* Drive;

@end


@interface MDSVTEventModel : NSObject
@property (nonatomic,copy) NSString* EventNumber;
@property (nonatomic,copy) NSString* EventName;
@property (nonatomic,copy) NSString* ElapsedTime;
@end


@interface MDSVTErrorData : NSObject
@property (nonatomic,copy) NSString* Step;
@property (nonatomic,copy) NSString* ErrorCode;
@end

@interface MDSVTModelDetail : NSObject
@property (nonatomic,copy) NSString* SoftwareBaselineVersion;
@property (nonatomic,strong) MDSVTErrorData* ErrorData;
@property (nonatomic,copy) NSString* IsEventLogComplete;
@property (nonatomic,copy) NSString* SCN;
@end



@interface MDSVTLastModel : NSObject

@property (nonatomic,copy) NSString* SoftwareBaselineVersion;
@property (nonatomic,copy) NSString* SCN;
@property (nonatomic,strong) NSArray* SavedDriveEvents;
@property (nonatomic,strong) NSArray* DriveEvents;
@property (nonatomic,copy) NSString* IsEventLogComplete;
@end



