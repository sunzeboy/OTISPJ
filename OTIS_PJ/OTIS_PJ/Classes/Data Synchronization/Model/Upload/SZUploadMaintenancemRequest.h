//
//  SZUploadMaintenancemModel.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/24.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SZReportItem : NSObject

/**
 * 用户密码
 */
@property (nonatomic , copy) NSString *Code;
/**
 * 保养完成情况(State状态)
 0：正常项目
 1：需调整或更换部件的项目，追踪电梯
 2：已完成清洁、润滑和更换的项目
 3：无此项目
 4：保养中完成换件
 99：未完成

 */
@property (nonatomic , assign) NSInteger State;

@end

//------------------------------------------------------------------------------------------------------------------------------------------------


@interface SZJHAItem : NSObject

/**
 * JHA字符串。
 */
@property (nonatomic , copy) NSString *JHACode;

@end

//------------------------------------------------------------------------------------------------------------------------------------------------
@interface SZOprateItem : NSObject


@property (nonatomic , copy) NSString *Type;
@property (nonatomic , assign) NSInteger StartTime;
@property (nonatomic , assign) NSInteger EndTime;
@property (nonatomic , copy) NSString *StartLocalX;
@property (nonatomic , copy) NSString *StartLocalY;
@property (nonatomic , copy) NSString *EndLocalX;
@property (nonatomic , copy) NSString *EndLocalY;
@property (nonatomic , assign) NSInteger Reason;

@end
//------------------------------------------------------------------------------------------------------------------------------------------------

@interface SZAddHoursItem : NSObject

@property (nonatomic , assign) NSInteger LaborTypeID;
@property (nonatomic , assign) float UploadHours1;
@property (nonatomic , assign) float UploadHours15;
@property (nonatomic , assign) float UploadHours2;
@property (nonatomic , assign) float UploadHours3;
@property (nonatomic , copy) NSString *PUINum;

@end
//------------------------------------------------------------------------------------------------------------------------------------------------


@interface SZUploadMaintenancemRequest : NSObject

/**
 * 登录终端的员工EmployeeID
 */
@property (nonatomic , copy) NSString *UserNo;
/**
 * 用户密码
 */
@property (nonatomic , copy) NSString *Password;
/**
 * 接口版本号。如：LBS_V8.0.0
 */
@property (nonatomic , copy) NSString *Ver;
/**
 * 计划ID
 */
@property (nonatomic , copy) NSString * ScheduleID;

/**
 * 保养日期时间的ticks（长整形，可以为空）（如果已经有此对应记录，则不生成重复记录
 */
@property (nonatomic , copy) NSString * ItemDate;
/**
 * JHA日期时间的ticks（长整形，可以为空）（如果已经有此对应记录，则不生成重复记
 */
@property (nonatomic , copy) NSString * JhaDate;
/**
 * 此次保养人EmployeeID(如：8018)
 */
@property (nonatomic , copy) NSString *Checker;
/**
 * 此次保养人EmployeeID(如：8018)
 */
@property (nonatomic , copy) NSString *ItemPhoto;
/**
 *保养项目内容的json字符串
 */
@property (nonatomic, copy) NSString * Report;

/**
 *JHA字符串。
 */
@property (nonatomic, copy) NSString * JHA;
/**
 * 是否中断 0：否 1：是
 */
@property (nonatomic , copy) NSString *IsAdjust;


/**
 * 中断原因ID：CB：召修；OTCB：加班召修；R：修理；OTR:加班修理；T:T修理；OT:加班
 */
@property (nonatomic , copy) NSString *AdjustmentType;

/**
 * 中断预计时间
 */
@property (nonatomic , copy) NSString * AdjustmentHour;

/**
 * 此次保养人EmployeeID(如：8018)
 */
@property (nonatomic , copy) NSString *Comment;

/**
 * 客户是否不在 1：是 0：否
 */
@property (nonatomic , copy) NSString *IsAbsent;

/**
 *操作记录做成json的字符串。
 */
@property (nonatomic, copy) NSString * operate;

/**
 * 保存工时和操作记录是生成的GroupID。
 */
@property (nonatomic , copy) NSString *GroupID;

/**
 *维保和维保路途工时数据做成的json字符串。
 */
@property (nonatomic, copy) NSString * AddHours;


/**
 * 维保电梯的扫描到的二维码信息。
 */
@property (nonatomic , copy) NSString *QRCode;

/**
 * 手机App的版本号。如：V2.0.0.8
 */
@property (nonatomic , copy) NSString *PhoneVersion;

/**
 * 维保时，备注画面填写的内容。做完JHA直接填写工时时，此字段不上传。
 */
@property (nonatomic , copy) NSString *Question;
/**
 * 维保时，备注画面“需要更换”的勾选内容。做完JHA直接填写工时时，此字段不上传。
 */
@property (nonatomic , copy) NSString *IsReplace;
/**
 * 维保时，备注画面“需要改造”的勾选内容。做完JHA直接填写工时时，此字段不上传。
 */
@property (nonatomic , copy) NSString *IsOK;

/**
 * 数据接收校验
 */
@property (nonatomic , copy) NSString *IsRepair;

@end
