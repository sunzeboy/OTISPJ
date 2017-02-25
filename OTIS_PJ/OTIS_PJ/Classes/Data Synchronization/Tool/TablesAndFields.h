//
//  TablesAndFields.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/28.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#ifndef TablesAndFields_h
#define TablesAndFields_h


#import "FMDB.h"
#import "SZFMDB.h"
#import "MJExtension.h"

#import "SZDownload_UnitsResponse.h"
#import "SZUnit.h"


#import "SZDownload_V4Response.h"
#import "SZV4.h"


#import "SZDownload_CardsResponse.h"
#import "SZCard.h"

#import "SZDownload_UnfinishedItemsResponse.h"



#import "SZTable_Supervisor.h"

#import "SZTable_Route.h"

#import "SZTable_Unit.h"

#import "SZTable_Schedules.h"

#import "SZTable_CheckItem.h"

#import "SZTable_Building.h"

#import "SZTable_User.h"

#import "SZTable_UserRoute.h"

#import "SZTable_UserSupervisor.h"

#import "SZTable_System.h"

#import "SZTable_ScheduleCheckItem.h"

#import "SZTable_YearlyCheck.h"

#import "SZTable_UnfinishedMaintenanceItem.h"

#import "SZTable_REPORT_ITEM_COMPLETE_STATE.h"

#import "SZTable_UnfinishedMaintenanceItem.h"

#import "SZTable_Report.h"

#import "SZTable_YearlyCheckDownload.h"

#import "SZDownload_UnScanedReasonResponse.h"

#import "SZTable_QRCode.h"

#import "SZTable_Signature.h"

#import "SZTable_LaborHours.h"

#define OTISDB [SZFMDB sharedSZFMDB].dbQueue


//------------------------------------------------------------------------------------------------------------------------------------------------
static NSString * const dirName                            = @"downdata";
#pragma mark - 表名
//static NSString * const t_User                             = @"t_User";//用户表
//static NSString * const t_Units                            = @"t_Units";//电梯表
//static NSString * const t_Schedules                        = @"t_Schedules";//保养计划表
//static NSString * const t_CheckItem                        = @"t_CheckItem";//保养项目表
//static NSString * const t_ScheduleCheckItem                = @"t_ScheduleCheckItem";//计划保养项目表
//
//static NSString * const t_LaborHours                     = @"t_WorkingHours";//工时记录表
//static NSString * const t_QRCode                           = @"t_QRCode";//二维码信息记录表
//static NSString * const t_UserRoute                        = @"t_UserRoute";//路线人员对应表
//static NSString * const t_UserSupervisor                   = @"t_UserSupervisor";//所属服务主管对应表
//static NSString * const t_CompletedYaerMaintenanceSchedule = @"t_CompletedYaerMaintenanceSchedule";//已完成的年度保养项目表
//static NSString * const t_Building                         = @"t_Building";//工地表
//static NSString * const t_Log                              = @"t_Log";//日志表
//static NSString * const t_YearlyCheck                      = @"t_YearlyCheck";//年检记录表
//static NSString * const t_Signature                        = @"t_Signature";//签字记录表
//static NSString * const t_MaintenanceOperation             = @"t_MaintenanceOperation";//维修换件操作记录表
//static NSString * const t_Interrupt                        = @"t_Interrupt";//批量中断记录表
//static NSString * const t_ReservedSubject                  = @"t_ReservedSubject";//预留科目记录表
//static NSString * const t_Route                            = @"t_Route";//路线记录表
//static NSString * const t_System                           = @"t_System";//系统表
//static NSString * const t_Supervisor                       = @"t_Supervisor";//服务主管表
//static NSString * const t_Report                           = @"t_Report";//保养项目操作记录表
//
//static NSString * const t_REPORT_ITEM_COMPLETE_STATE       = @"t_REPORT_ITEM_COMPLETE_STATE";//
//static NSString * const t_JHA_USER_SELECTED_SCHEDULE_ITEM  = @"t_JHA_USER_SELECTED_SCHEDULE_ITEM";//
//static NSString * const t_JHA_TYPE                         = @"t_JHA_TYPE";//
//static NSString * const t_JHA_ITEM                         = @"t_JHA_ITEM";//
//static NSString * const t_JHA_ITEM_TYPE                    = @"t_JHA_ITEM_TYPE";//


//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - 用户t_User
//static NSString * const UserNo                             = @"UserNo";
//static NSString * const EmployeeID                         = @"EmployeeID";
//static NSString * const PassWord                           = @"PassWord";
//static NSString * const Name                               = @"Name";
//static NSString * const Phone                              = @"Phone";
//static NSString * const IsLocked                           = @"IsLocked";
//static NSString * const LastLoginDate                      = @"LastLoginDate";
//static NSString * const LastConnectDate                    = @"LastConnectDate";

//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - 电梯t_Units
//static NSString * const UnitNo                             = @"UnitNo";
//static NSString * const RouteNo                            = @"RouteNo";
//static NSString * const Route                              = @"Route";
//static NSString * const ContractNo                         = @"ContractNo";
//static NSString * const ModelType                          = @"ModelType";
//static NSString * const CardType                           = @"CardType";
//static NSString * const Examliterval                       = @"Examliterval";
//static NSString * const Owner                              = @"Owner";
//static NSString * const Tel                                = @"Tel";
//static NSString * const Email                              = @"Email";
//static NSString * const CurrentStatus                      = @"CurrentStatus";
//static NSString * const BuildingNo                         = @"BuildingNo";
//static NSString * const YCheckDate                         = @"YCheckDate";
//static NSString * const UnitRegcode                        = @"UnitRegcode";

//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - 计划t_Schedules
//static NSString * const ScheduleID                         = @"ScheduleID";
//static NSString * const UnitNo = @"UnitNo";
//static NSString * const Unit                               = @"Unit";
//static NSString * const CheckDate                          = @"CheckDate";
//static NSString * const Year                               = @"Year";
//static NSString * const Times                              = @"Times";
//static NSString * const RouteNo = @"RouteNo";
//static NSString * const CardType = @"CardType";
//static NSString * const ScheduleType                       = @"ScheduleType";
//static NSString * const IsComplete                         = @"IsComplete";
//static NSString * const PlanType                           = @"PlanType";


//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - 计划卡t_CheckItem
//static NSString * const ItemCode                           = @"ItemCode";
//static NSString * const ItemName                           = @"ItemName";
//static NSString * const CardType          = @"CardType";
//static NSString * const Description                        = @"Description";
//static NSString * const Type                               = @"Type";
//static NSString * const IsStandard                         = @"IsStandard";//是否国标的保养项目 0:否 1：是
//static NSString * const IsSafetyItem                       = @"IsSafetyItem";//是否是安全项目

//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - 保养项目操作记录表t_Report
//static NSString * const EmployeeID                           = @"EmployeeID";
//static NSString * const ScheduleId                         = @"ScheduleId";
//static NSString * const LastStatus                         = @"LastStatus";
//static NSString * const IsUploaded                         = @"IsUploaded";
//static NSString * const IsMerge                            = @"IsMerge";
//static NSString * const IsAbsent                           = @"IsAbsent";//
//static NSString * const IsRepair                           = @"IsRepair";//
//static NSString * const IsReplace                          = @"IsReplace";
//static NSString * const Question                           = @"Question";
//static NSString * const AdjustmentComment                  = @"AdjustmentComment";
//static NSString * const AdjustmentHours                    = @"AdjustmentHours";
//static NSString * const AdjustmentType                     = @"AdjustmentType";
//static NSString * const ItemPhoto                          = @"ItemPhoto";
//static NSString * const ItemDate                           = @"ItemDate";
//static NSString * const JhaDate                            = @"JhaDate";
//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - 计划保养项目表t_ScheduleCheckItem
//static NSString * const Times                           = @"Times";
//static NSString * const CardType          = @"CardType";
//static NSString * const ItemCode                        = @"ItemCode";

//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - 工时记录表t_LaborHours
//static NSString * const GroupID                            = @"GroupID";
//static NSString * const LaborTypeId                     = @"LaborTypeId";
//static NSString * const ScheduleID     = @"ScheduleID";
//static NSString * const UntiNo                             = @"UntiNo";
//static NSString * const GenerateDate                       = @"GenerateDate";
//static NSString * const EmployeeID     = @"EmployeeID";
//static NSString * const Property                           = @"Property";
//static NSString * const LaborType                          = @"LaborType";
//static NSString * const LaborName                          = @"LaborName";
//static NSString * const Hour1Rate                          = @"Hour1Rate";
//static NSString * const Hour15Rate                         = @"Hour15Rate";
//static NSString * const Hour2Rate                          = @"Hour2Rate";
//static NSString * const Hour3Rate                          = @"Hour3Rate";
//static NSString * const Longitude                          = @"Longitude";
//static NSString * const Latitude                           = @"Latitude";
//static NSString * const CustomerName                       = @"CustomerName";
//static NSString * const ContactNo                          = @"ContactNo";
//static NSString * const RecordDate                         = @"RecordDate";
//static NSString * const Remark                             = @"Remark";
//static NSString * const CreateTime                         = @"CreateTime";
//static NSString * const UpdateTime                         = @"UpdateTime";
//static NSString * const PUINo                              = @"PUINo";
//static NSString * const AppVersion                         = @"AppVersion";
//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - 二维码信息记录表t_QRCode
//static NSString * const AutoID                             = @"AutoID";
//static NSString * const GroupID    = @"GroupID";
//static NSString * const ScheduleID = @"ScheduleID";
//static NSString * const UnitNo     = @"UnitNo";
//static NSString * const ParseRes                           = @"ParseRes";
//static NSString * const QRCode                             = @"QRCode";
//static NSString * const StratTime                          = @"StratTime";
//static NSString * const EndTime                            = @"EndTime";
//static NSString * const StartLon                           = @"StartLon";
//static NSString * const StartLat                           = @"StartLat";
//static NSString * const EndLon                             = @"EndLon";
//static NSString * const EndLat                             = @"EndLat";
//static NSString * const Property   = @"Property";
//static NSString * const Reason                             = @"Reason";
//static NSString * const CreateTime = @"CreateTime";
//static NSString * const UpdateTime = @"UpdateTime";
//static NSString * const AppVersion = @"AppVersion";
//static NSString * const SavedState                         = @"SavedState";
//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - 路线人员对应表t_UserRoute
//static NSString * const EmployeeID = @"EmployeeID";
//static NSString * const RouteNo    = @"RouteNo";

//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - 所属服务主管对应表t_UserSupervisor
//static NSString * const EmployeeID = @"EmployeeID";
//static NSString * const SupervisorNo                       = @"SupervisorNo";

//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - 已完成的年度保养项目表t_CompletedYaerMaintenanceSchedule
//static NSString * const CheckID                            = @"CheckID";
//static NSString * const UnitNo   = @"UnitNo";
//static NSString * const ItemCode = @"ItemCode";
//static NSString * const Year     = @"Year";
//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - 工地表t_Building

//static NSString * const BuildingNo   = @"BuildingNo";
//static NSString * const SupervisorNo = @"SupervisorNo";
//static NSString * const Route        = @"Route";
//static NSString * const BuildingName                       = @"BuildingName";
//static NSString * const BuildingAddr                       = @"BuildingAddr";

//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - 日志表t_Log
//static NSString * const LogID                              = @"LogID";
//static NSString * const Type    = @"Type";
//static NSString * const Message                            = @"Message";
//static NSString * const User                               = @"User";
//static NSString * const LogDate                            = @"LogDate";

//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - 年检记录表t_YearlyCheck

//static NSString * const YCheckPDate                        = @"YCheckPDate";
//static NSString * const YCheckADate                        = @"YCheckADate";
//static NSString * const IsUploading        = @"IsUploading";
//static NSString * const EmployeeId      = @"EmployeeId";
//static NSString * const UnitNo                               = @"UnitNo";

//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - 签字记录表t_Signature
//static NSString * const SignID                             = @"SignID";
//static NSString * const SignDate                           = @"SignDate";
//static NSString * const IsReplace                          = @"IsReplace";
//static NSString * const IsRepair                           = @"IsRepair";
//static NSString * const Attitude                           = @"Attitude";
//static NSString * const Quality                            = @"Quality";
//static NSString * const Question                           = @"Question";
//static NSString * const Customer                           = @"Customer";
//static NSString * const IsEmail                            = @"IsEmail";
//static NSString * const EmailAddr                          = @"EmailAddr";

//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - 维修换件操作记录表t_MaintenanceOperation
//static NSString * const JhaJson                            = @"JhaJson";
//static NSString * const ItemDate                           = @"ItemDate";
//static NSString * const JhaDate                            = @"JhaDate";
//static NSString * const ItemPhoto                          = @"ItemPhoto";
//static NSString * const JHAPhoto                           = @"JHAPhoto";
//static NSString * const ScheduleID = @"ScheduleID";
//static NSString * const FixMan                             = @"FixMan";
//static NSString * const   IsOK     = @"  IsOK";

//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - 批量中断记录表t_Interrupt
//static NSString * const AdjustmentID                       = @"AdjustmentID";
//static NSString * const ScheduleIDs                        = @"ScheduleIDs";
//static NSString * const AdjustmentType                     = @"AdjustmentType";
//static NSString * const AdjustmentHours                    = @"AdjustmentHours";
//static NSString * const AdjustmentComment                  = @"AdjustmentComment";
//static NSString * const AdjustmentDate                     = @"AdjustmentDate";
//static NSString * const User              = @"User";
//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - 预留科目记录表t_ReservedSubject
//static NSString * const LaborTypeID                        = @"LaborTypeID";
//static NSString * const LaborType      = @"LaborType";
//static NSString * const LaborName      = @"LaborName";
//static NSString * const EffectiveDate                      = @"EffectiveDate";
//static NSString * const ExpiryDate                         = @"ExpiryDate";
//static NSString * const IsSpecialLabor                     = @"IsSpecialLabor";
//static NSString * const ProductiveType                     = @"ProductiveType";
//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - 服务主管表t_Supervisor
//static NSString * const SupervisorNo    = @"SupervisorNo";
//static NSString * const UnitVer                            = @"UnitVer";
//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - 路线记录表t_Route
//static NSString * const RouteNo                  = @"RouteNo";
//static NSString * const ScheduleVer                        = @"ScheduleVer";
//static NSString * const LastDownloadScheduleDate           = @"LastDownloadScheduleDate";//上次下载保养计划日期
//static NSString * const LastDownloadReportDate             = @"LastDownloadReportDate";//上次下载未完成保养项日期
//static NSString * const LastDownloadFixDate                = @"LastDownloadFixDate";//上次下载未完成维修换件日期
//static NSString * const LastDownloadYCheckDate             = @"LastDownloadYCheckDate";//上次下载年检日期
//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - 系统表t_System
//static NSString * const SysID                              = @"SysID";
//static NSString * const Host                               = @"Host";//主机IP地址
//static NSString * const IsExpired                          = @"IsExpired";//软件版本是否已过期
//static NSString * const ItemScheduleVer                    = @"ItemScheduleVer";//保养卡下载的版本
//static NSString * const SafetyItemVer                      = @"SafetyItemVer";//安全保养项下载的版本
//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - 系统表t_REPORT_ITEM_COMPLETE_STATE
//static NSString * const ItemCode                               = @"ItemCode";
//static NSString * const State                              = @"State";//
//static NSString * const EmployeeID                         = @"EmployeeID";//
//static NSString * const ScheduleId                         = @"ScheduleId";//

//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - 系统表t_JHA_USER_SELECTED_SCHEDULE_ITEM
//static NSString * const EmployeeId                         = @"EmployeeId";
//static NSString * const ScheduleId                         = @"ScheduleId";//
//static NSString * const JhaCodeId                          = @"JhaCodeId";//
//static NSString * const Other                              = @"Other";//

//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - 系统表t_JHA_TYPE
//static NSString * const JhaTypeId                          = @"JhaTypeId";
//static NSString * const Name                               = @"Name";//
//static NSString * const CardType                           = @"CardType";//

//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - 系统表t_JHA_ITEM
//static NSString * const JhaCodeId                          = @"JhaCodeId";
//static NSString * const JhaItemType                        = @"JhaItemType";//
//static NSString * const JhaCode                            = @"JhaCode";//
//static NSString * const Name                               = @"Name";//

//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - 系统表t_JHA_ITEM_TYPE
//static NSString * const JhaItemType                        = @"JhaItemType";
//static NSString * const Name                               = @"Name";//
//static NSString * const JhaTypeId                          = @"JhaTypeId";//


#endif /* TablesAndFields_h */
