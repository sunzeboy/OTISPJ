//
//  AppDelegate+Version.m
//  otis__PJ
//
//  Created by sunze on 16/4/20.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "AppDelegate+Version.h"
#import "HomeViewController.h"
#import "SZLoginViewController.h"
#import "NSBundle+Extention.h"
#import "SZFMDB.h"
#import "SZBeforehandStorageManager.h"
#import "TablesAndFields.h"

@implementation AppDelegate (Version)

-(void)createTable
{
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSString *strDropUnits = [NSString stringWithFormat:@"DROP TABLE t_Units"];
        
        BOOL ret ;

        ret =[db executeUpdate:strDropUnits];
        if (ret) {
            
        }else{
            SZLog(@"t_Units删除失败！！！");
        }

        
        NSString *strCreatet_JHA_TYPE = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_JHA_TYPE (JhaTypeId INTEGER ,Name TEXT,CardType INTEGER);"];
        
        
        NSString *strCreateUnits = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_Units \
                                    (EmployeeID TEXT, \
                                    UnitNo TEXT ,\
                                    RouteNo INTEGER,\
                                    Route TEXT NOT NULL,\
                                    ContractNo TEXT NOT NULL,\
                                    ModelType TEXT NOT NULL,\
                                    CardType INTEGER,\
                                    Examliterval INTEGER,\
                                    Owner TEXT NOT NULL,\
                                    Tel TEXT NOT NULL,\
                                    Email TEXT NOT NULL,\
                                    CurrentStatus INTEGER,\
                                    BuildingNo LONG,\
                                    YCheckDate LONG,\
                                    UnitRegcode text,\
                                    UnitStatus text,\
                                    UnitName,text);"];
        
        

        NSString *strCreateSchedulet_Report = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_Report (EmployeeID TEXT ,\
                                            ScheduleId INTEGER,\
                                            LastStatus INTEGER,\
                                            IsUploaded BOOL DEFAULT 0,\
                                            IsAbsent BOOL DEFAULT 0,\
                                            IsRepair BOOL DEFAULT 0,\
                                            IsReplace BOOL DEFAULT 0,\
                                            Question TEXT ,\
                                            AdjustmentComment TEXT,\
                                            AdjustmentHours FLOAT,\
                                            AdjustmentType TEXT,\
                                            ItemPhoto TEXT DEFAULT '0',\
                                            ItemDate LONG,\
                                            JhaDate LONG ,\
                                            IsRepairItem INTEGER DEFAULT 0,\
                                            PRIMARY KEY (EmployeeID, ScheduleId,IsRepairItem));"];
       
        
        NSString *strCreatet_Report_Download = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_Report_Download (EmployeeID TEXT NOT NULL,\
                                             ScheduleId INTEGER,\
                                             IsComplete BOOL DEFAULT 0,\
                                             IsRepair BOOL DEFAULT 0,\
                                             IsReplace BOOL DEFAULT 0,\
                                             Question TEXT ,\
                                             PRIMARY KEY (EmployeeID, ScheduleId));"];
        
        
        /**
         *  业务1
         业务:如果保养项全部完成，并且未签字的电梯，此时签字列表存在此电梯
         如果进入保养，添加电梯工时，做JHA未完成，或者做完JHA没有填写工时，则签字列表不显示此电梯
         
         处理方法:
         t_Schedules 表最后添加一列，来保存这个状态 AddLaborHoursState int
         0:默认值，为未做个添加工时       此时签字列表有此电梯
         1:JHA 已经做完，但是未添加工时   此时签字列表无此电梯
         2:JHA已经完成，并且已经添加工时  此时签字列表有此电梯
         */
        
        NSString *strCreateSchedules = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_Schedules (EmployeeID TEXT,ScheduleID INTEGER , UnitNo TEXT NOT NULL ,CheckDate LONG,Year INTEGER,Times INTEGER,RouteNo INTEGER,CardType INTEGER,IsComplete INTEGER,PlanType INTEGER,AddLaborHoursState  INTEGER DEFAULT 0,PRIMARY KEY (ScheduleID) );"];
        
        
        
        
        
        
        NSString *strTAB_UNIT_UN_SCANED_REASON = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS TAB_UNIT_UN_SCANED_REASON \
                                                  (UnitNo TEXT PRIMARY KEY,\
                                                  IsScaned  BOOL,\
                                                  IsNeedDialog  BOOL);"];
      
        
        
        
        
        NSString *strCheckItem = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_CheckItem (ItemCode TEXT NOT NULL,\
                                  CardType INTEGER ,\
                                  ItemName TEXT NOT NULL,\
                                  Description TEXT NOT NULL,\
                                  Type INTEGER,\
                                  IsStandard BOOL,\
                                  IsSafetyItem BOOL);"];
       
        
        
        
        
        NSString *strLaborHours = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_LaborHours (%@ INTEGER,\
                                   %@ INTEGER ,\
                                   %@ TEXT,\
                                   %@ TEXT,\
                                   %@ TEXT,\
                                   %@ TEXT,\
                                   %@ TEXT,\
                                   %@ INTEGER,\
                                   %@ REAL,\
                                   %@ REAL,\
                                   %@ REAL,\
                                   %@ REAL,\
                                   %@ TEXT,\
                                   %@ TEXT,\
                                   %@ TEXT,\
                                   %@ TEXT,\
                                   %@ INTEGER, \
                                   %@ TEXT );",
                                   @"EmployeeID",
                                   @"ScheduleId",
                                   @"GenerateDate",
                                   @"CreateDate",
                                   @"CreateTime",
                                   @"UpdateTime",
                                   @"Property",
                                   @"LaborTypeId",
                                   @"Hour1Rate",
                                   @"Hour15Rate",
                                   @"Hour2Rate",
                                   @"Hour3Rate",
                                   @"CustomerName",
                                   @"ContactNo",
                                   @"Remark",
                                   @"PUINo",
                                   @"GroupID",
                                   @"UnitNo"];
       
        
        
        
        NSString *strCreatet_ScheduleCheckItem = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_ScheduleCheckItem (Times INTEGER,\
                                               CardType INTEGER ,\
                                               ItemCode TEXT);"];
        
        
        // GroupID, ScheduleID, EmployeeID 每个电梯的一次Group数据只有一份
        NSString *strCreateQRCode = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_QRCode ( \
                                     GroupID    INTEGER, \
                                     ScheduleID INTEGER , \
                                     EmployeeID TEXT , \
                                     IsFixItem  INTEGER DEFAULT 0, \
                                     ParseRes   INTEGER , \
                                     QRCode     TEXT , \
                                     StratTime  INTEGER , \
                                     EndTime    INTEGER , \
                                     StartLon   TEXT , \
                                     StartLat   TEXT , \
                                     EndLon     TEXT , \
                                     EndLat     TEXT , \
                                     Property   INTEGER , \
                                     Reason     INTEGER , \
                                     CreateTime INTEGER , \
                                     UpdateTime INTEGER , \
                                     AppVersion TEXT , \
                                     SavedState INTEGER, \
                                     PRIMARY KEY (GroupID, ScheduleID, EmployeeID,IsFixItem) );"];
        
        
        
        //    复合主键
        NSString *strCreateUserRoute = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_UserRoute (EmployeeID TEXT , RouteNo INTEGER,constraint pk_t_UserRoute primary key (EmployeeID,RouteNo));"];
        
        
        
        
        NSString *strCreateUserSupervisor = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_UserSupervisor (EmployeeID TEXT , SupervisorNo INTEGER,constraint pk_t_UserSupervisor primary key (EmployeeID,SupervisorNo));"];
        
        
        
        NSString *strCreateBuilding = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_Building (EmployeeID TEXT,BuildingNo TEXT , \
                                       SupervisorNo INTEGER ,\
                                       Route TEXT NOT NULL,\
                                       BuildingName TEXT NOT NULL,\
                                       BuildingAddr TEXT NOT NULL);"];
        
        NSString *strCreateYearlyCheck = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS TAB_YEARLY_CHECK (\
                                          YCHECK_PDATE LONG ,\
                                          SAVE_YCHECK_PDATE LONG ,\
                                          YCHECK_ADATE LONG,\
                                          IS_UPLOADING BOOL,\
                                          UnitNo TEXT,\
                                          EmployeeId TEXT, \
                                          PRIMARY KEY (YCHECK_PDATE, UnitNo));"];
        
        
        
        NSString *strCreateSignature= [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_Signature (\
                                       SinId INTEGER,\
                                       EmployeeID TEXT ,\
                                       ScheduleID INTEGER,\
                                       SignDate text ,\
                                       Attitude INTEGER,\
                                       Quality INTEGER,\
                                       SignComment TEXT,\
                                       IsAbsent BOOL,\
                                       Customer TEXT,\
                                       Signature TEXT,\
                                       IsEmail BOOL,\
                                       EmailAddr TEXT,\
                                       IsImageUploaded BOOL, \
                                       IsUploaded BOOL DEFAULT 0 );"];
        
        
        
        NSString *strCreateReservedSubject = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_ReservedSubject(LaborTypeID INTEGER PRIMARY KEY, LaborType TEXT NOT NULL,LaborName TEXT NOT NULL,EffectiveDate TEXT NOT NULL,ExpiryDate TEXT NOT NULL,IsSpecialLabor INTEGER,ProductiveType INTEGER);"];
        
        
        
        
        NSString *strCreateRoute = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_Route (RouteNo INTEGER , ScheduleVer INTEGER,LastDownloadScheduleDate LONG,LastDownloadReportDate LONG,LastDownloadFixDate LONG,LastDownloadYCheckDate LONG,EmployeeID TEXT);"];
       
        
        
        
        NSString *t_REPORT_ITEM_COMPLETE_STATE = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_REPORT_ITEM_COMPLETE_STATE (\
                                                  ItemCode TEXT , \
                                                  State INTEGER,\
                                                  EmployeeID TEXT ,\
                                                  ScheduleId INTEGER,\
                                                  isUpload INTEGER, \
                                                  PRIMARY KEY (ItemCode, ScheduleId));"];
        
        
        NSString *t_REPORT_ITEM_COMPLETE_STATE_Download = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_REPORT_ITEM_COMPLETE_STATE_Download (ItemCode TEXT , State INTEGER,EmployeeID TEXT , ScheduleId INTEGER);"];
        
        
        NSString *strCreatet_Supervisor = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_Supervisor (SupervisorNo INTEGER , UnitVer INTEGER ,EmployeeID TEXT);"];
        
        NSString *strCreateYEARLY_CHECK_DOWNLOAD = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS TAB_YEARLY_CHECK_DOWNLOAD (EmployeeID TEXT,\
                                                    YCHECK_PDATE LONG ,\
                                                    YCHECK_ADATE LONG,\
                                                    UnitNo TEXT);"];
        
        NSString *strCreateSystem = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_System (SysID INTEGER , Host TEXT ,IsExpired BOOL,ItemScheduleVer INTEGER,SafetyItemVer INTEGER,LaborItemVer TEXT, EmployeeID TEXT);"];
        
        // 添加Fix选项；如果是0，则不是fix的JHA，否则是Fix JHA
        NSString *strCreatet_JHA_USER_SELECTED_SCHEDULE_ITEM = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS \
                                                                t_JHA_USER_SELECTED_SCHEDULE_ITEM (\
                                                                                    IsFixItem INTEGER DEFAULT 0,\
                                                                                    EmployeeId TEXT, \
                                                                                    ScheduleId INTEGER,\
                                                                                    JhaCodeId INTEGER,\
                                                                                    Other TEXT );"];
        
    
        
        NSString *strLaborType = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_LaborType (\
                                  LaborTypeID INTEGER ,\
                                  LaborType TEXT,\
                                  LaborName TEXT,\
                                  ProductiveType INTEGER,\
                                  RelationID INTEGER,\
                                  EffectiveDate TEXT,\
                                  ExpiryDate TEXT,\
                                  IsSpecialLabor BOOL);"];
        
        
        NSString *strCreateUser111 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_User (EmployeeID TEXT PRIMARY KEY, UserNo TEXT NOT NULL,PassWord TEXT NOT NULL,Name TEXT NOT NULL,Phone TEXT NOT NULL,IsLocked BOOL,LastLoginDate INTEGER,LastConnectDate INTEGER);"];
        
        
        NSString *strSafetyItem = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_SafetyItem (ItemCode TEXT);"];
        
        
        NSString *strCreatet_FIX_DOWNLOAD = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_FIX_DOWNLOAD (ScheduleId INTEGER,\
                                             ItemCode TEXT , \
                                             State INTEGER,\
                                             IsComplete BOOL, \
                                             PRIMARY KEY (ScheduleId, ItemCode));"];
        
        
        
        NSString *strCreatet_t_MD_Maintenance = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_MD_Maintenance (ScheduleId INTEGER,\
                                             UnitNo TEXT , \
                                             RecordTime TEXT,\
                                             EmployeeID TEXT, \
                                             AppVer TEXT, \
                                             StartTime TEXT, \
                                             EndTime TEXT, \
                                             EventLog TEXT, \
                                             IsCompleteCtrl INTEGER, \
                                             IsCompleteDri INTEGER, \
                                             UserName TEXT, \
                                             CtrlSoftwareVer TEXT, \
                                             DriSoftwareVer TEXT, \
                                             PRIMARY KEY (ScheduleId ASC));"];
        
        NSString *strCreatet_t_MD_ItemInfo = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_MD_ItemInfo (ScheduleId INTEGER,\
                                              UnitNo TEXT , \
                                              RecordTime TEXT,\
                                              ID INTEGER NOT NULL, \
                                              ItemCode TEXT, \
                                              ItemState INTEGER, \
                                              ItemStateAuto INTEGER, \
                                              Reason TEXT, \
                                              PRIMARY KEY (ID ASC));"];
        
        
        ret =[db executeUpdate:strCreatet_t_MD_Maintenance];
        if (ret) {
            
        }else{
            SZLog(@"strCreatet_t_MD_Maintenance创建失败！！！");
        }
        
        ret =[db executeUpdate:strCreatet_t_MD_ItemInfo];
        if (ret) {
            
        }else{
            SZLog(@"strCreatet_t_MD_ItemInfo创建失败！！！");
        }
        
        ret =[db executeUpdate:strCreatet_JHA_TYPE];
        if (ret) {
            
        }else{
            SZLog(@"t_JHA_TYPE创建失败！！！");
        }
        
        
        ret = [db executeUpdate:strCreateUnits];
        if (ret) {
            
        }else{
            SZLog(@"电梯表创建失败！！！");
        }
        
        ret = [db executeUpdate:strCreateSchedulet_Report];
        if (ret) {
            
        }else{
            SZLog(@"保养项表创建失败！！！");
        }

        ret = [db executeUpdate:strCreatet_Report_Download];
        if (ret) {
            
        }else{
            SZLog(@"t_Report_Download表创建失败！！！");
        }

        ret = [db executeUpdate:strCreateSchedules];
        if (ret) {
            
        }else{
            SZLog(@"计划表创建失败！！！");
        }

        
        ret = [db executeUpdate:strTAB_UNIT_UN_SCANED_REASON];
        if (ret) {
            
        }else{
            SZLog(@"TAB_UNIT_UN_SCANED_REASON表创建失败！！！");
        }
        
        ret = [db executeUpdate:strCheckItem];
        if (ret) {
            
        }else{
            SZLog(@"保养项表创建失败！！！");
        }
        
        
        ret  = [db executeUpdate:strLaborHours];
        if (ret) {
            
        }else{
            SZLog(@"t_LaborHours表创建失败！！！");
        }
        
        ret  = [db executeUpdate:strCreatet_ScheduleCheckItem];
        if (ret) {
            
        }else{
            SZLog(@"t_ScheduleCheckItem表创建失败！！！");
        }
        
        ret  = [db executeUpdate:strCreateQRCode];
        if (ret) {
            
        }else{
            SZLog(@"QRCode表创建失败！！！");
        }
        
        ret  =[db executeUpdate:strCreateUserRoute];
        if (ret) {
            
        }else{
            SZLog(@"UserRoute表创建失败！！！");
        }
        
        ret  =[db executeUpdate:strCreateUserSupervisor];
        if (ret) {
            
        }else{
            SZLog(@"t_UserSupervisor表创建失败！！！");
        }

        
        ret  = [db executeUpdate:strCreateBuilding];
        if (ret) {
            
        }else{
            SZLog(@"工地表创建失败！！！");
        }

        ret  =[db executeUpdate:strCreateYearlyCheck];
        if (ret) {
            
        }else{
            SZLog(@"YearlyCheck表创建失败！！！");
        }
        
        ret  =[db executeUpdate:strCreateSignature];
        if (ret) {
            
        }else{
            SZLog(@"Signature表创建失败！！！");
        }
        
        ret  =[db executeUpdate:strCreateReservedSubject];
        if (ret) {
            
        }else{
            SZLog(@"ReservedSubject表创建失败！！！");
        }
        
        ret  = [db executeUpdate:strCreateRoute];
        if (ret) {
            
        }else{
            SZLog(@"t_Route表创建失败！！！");
        }
        
        ret  = [db executeUpdate:t_REPORT_ITEM_COMPLETE_STATE];
        if (ret) {
            
        }else{
            SZLog(@"T_ITEM_COMPLETE_STATE表创建失败！！！");
        }
        
        ret  = [db executeUpdate:t_REPORT_ITEM_COMPLETE_STATE_Download];
        if (ret) {
            
        }else{
            SZLog(@"t_REPORT_ITEM_COMPLETE_STATE_Download表创建失败！！！");
        }
        
        ret  = [db executeUpdate:strCreatet_Supervisor];
        if (ret) {
            
        }else{
            SZLog(@"t_Supervisor表创建失败！！！");
        }
        
        ret  = [db executeUpdate:strCreateYEARLY_CHECK_DOWNLOAD];
        if (ret) {
            
        }else{
            SZLog(@"YEARLY_CHECK_DOWNLOAD表创建失败！！！");
        }
        
        ret  = [db executeUpdate:strCreateSystem];
        if (ret) {
            
        }else{
            SZLog(@"System表创建失败！！！");
        }
        
        ret  = [db executeUpdate:strCreatet_JHA_USER_SELECTED_SCHEDULE_ITEM];
        if (ret) {
            
        }else{
            SZLog(@"t_JHA_USER_SELECTED_SCHEDULE_ITEM表创建失败！！！");
        }
        
        
        ret  = [db executeUpdate:strLaborType];
        if (ret) {
            
        }else{
            SZLog(@"LaborType表创建失败！！！");
        }
        
        ret  =[db executeUpdate:strCreateUser111];
        if (ret) {
            
        }else{
            SZLog(@"User111表创建失败！！！");
        }
        
        ret  =[db executeUpdate:strSafetyItem];
        if (ret) {
            
        }else{
            SZLog(@"strSafetyItem表创建失败！！！");
        }
        
        ret  =[db executeUpdate:strCreatet_FIX_DOWNLOAD];
        if (ret) {
            
        }else{
            SZLog(@"t_FIX_DOWNLOAD表创建失败！！！");
        }
        
    }];
    
}


-(void)rootController
{
    SZLoginViewController *loginVc = [[SZLoginViewController alloc] init];
    self.window.rootViewController = [[SZNavigationController alloc] initWithRootViewController:loginVc];
    
#if 1

    // 上一次的使用版本（存储在沙盒中的版本号）
    NSString *lastVersion = [USER_DEFAULT objectForKey:@"NewfeatureVersion"];
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle bundleVersionString];
    
    if ([currentVersion isEqualToString:lastVersion]) { // 版本号相同：这次打开和上次打开的是同一个版本
        
        [USER_DEFAULT setObject:@0 forKey:OTIS_isNewfeatureVersion];

    } else { // 这次打开的版本和上一次不一样，显示新特性

        [USER_DEFAULT setObject:@1 forKey:OTIS_isNewfeatureVersion];

        [self createTable];
        
        // 将当前的版本号存进沙盒
        [USER_DEFAULT setObject:currentVersion forKey:@"NewfeatureVersion"];
        [USER_DEFAULT synchronize];
        /**
         *  预先存储一些JHA信息(当应用程序第一次安装或版本升级的时候才执行)
         */
        [SZBeforehandStorageManager beforehandStorage];
        SZLog(@"更新版本或第一次安装程序");
    }
#endif
    
    [self.window makeKeyAndVisible];
}

@end
