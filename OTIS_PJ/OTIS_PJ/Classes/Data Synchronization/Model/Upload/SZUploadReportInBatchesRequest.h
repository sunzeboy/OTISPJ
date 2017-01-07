//
//  SZUploadReportInBatchesRequest.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZUploadReportInBatchesRequest : NSObject

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
 *JHA图片名称
 */
@property (nonatomic, copy) NSString *  JHAPhoto;

/**
 * 平日工时
 */
@property (nonatomic, copy) NSString * RTE1Rate;
/**
 * 平日加班工时
 */
@property (nonatomic , copy) NSString *RTE15Rate;
/**
 * 双休日加班工时
 */
@property (nonatomic, copy) NSString * RTE2Rate;
/**
 * 国定假日加班工时
 */
@property (nonatomic, copy) NSString * RTE3Rate;

/**
 * 平日路途工时
 */
@property (nonatomic, copy) NSString * TT1Rate;
/**
 *  平日加班路途工时
 */
@property (nonatomic, copy) NSString * TT15Rate;
/**
 * 双休日加班路途工时
 */
@property (nonatomic, copy) NSString * TT2Rate;
/**
 * 国定假日路途工时
 */
@property (nonatomic, copy) NSString * TT3Rate;


/**
 *保养项目内容的json字符串
 */
@property (nonatomic, copy) NSString * Report;

/**
 *JHA字符串。
 */
@property (nonatomic, copy) NSString * JHA;


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
 * 维保时，备注画面“需要改造”的勾选内容。做完JHA直接填写工时时，此字段不上传。
 */
@property (nonatomic , copy) NSString *IsOK;



@end
