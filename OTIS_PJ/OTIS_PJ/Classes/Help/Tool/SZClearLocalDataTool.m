//
//  SZClearLocalDataTool.m
//  OTIS_PJ
//
//  Created by sunze on 16/7/11.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZClearLocalDataTool.h"
#import "TablesAndFields.h"
#import "SZModuleQueryTool.h"
#import "CustomIOSAlertView.h"
#import "UIView+Extension.h"
#import "AppDelegate.h"

@implementation SZClearLocalDataTool

+(BOOL)hasUploadData{
    NSArray *arrayUploadData1 = [SZModuleQueryTool queryMaintenanceUploadData];
    NSArray *arrayUploadData2 = [SZModuleQueryTool queryUploadImageData];
    NSArray *arrayUploadData3 = [SZModuleQueryTool queryUploadImageData];
    NSArray *arrayUploadData4 = [SZModuleQueryTool queryFixUploadData];
    NSArray *arrayUploadData5 = [SZModuleQueryTool queryUploadSignature];
    NSArray *arrayUploadData6 = [SZModuleQueryTool queryYearlyCheckUpload];
    
    if (arrayUploadData1.count || arrayUploadData2.count || arrayUploadData3.count || arrayUploadData4.count || arrayUploadData5.count || arrayUploadData6.count||[SZTable_LaborHours queryhasHoursUploadData]) {
        return YES;
    }

    return NO;
}


+(void)clearLocalDataWithView:(UIView *)view{


    if ([self hasUploadData]) {
        
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:SZLocal(@"dialog.content.You have the data did not upload")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            if(buttonIndex == 0){
                
                [self clearData];
                [alertView close];
                [view createWithMessage:SZLocal(@"dialog.content.Successful empty data!")];

            }else if(buttonIndex == 1){
                [alertView close];
            }
        };
        [alertView show];
        
    }else{
    
        
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.clearData")
                                                                                     dialogContents:SZLocal(@"dialog.content.clearData")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            if(buttonIndex == 0){
                SZLog(@"clear data comfirm!");
                
                
                //清空数据
                [self clearData];
                
                [alertView close];
                [view createWithMessage:SZLocal(@"dialog.content.Successful empty data!")];
            }else if(buttonIndex == 1){
                [alertView close];
            }
        };
        [alertView show];

        
    }
    
    
   

}


+(void)clearData{
    NSArray *strArray = @[@"t_Units",@"t_Report",@"t_Report_Download",@"t_Schedules",@"TAB_UNIT_UN_SCANED_REASON",@"t_CheckItem",@"t_LaborHours",@"t_ScheduleCheckItem",@"t_QRCode",@"t_Building",@"TAB_YEARLY_CHECK",@"t_Signature",@"t_ReservedSubject",@"t_Route",@"t_REPORT_ITEM_COMPLETE_STATE",@"t_REPORT_ITEM_COMPLETE_STATE_Download",@"t_Supervisor",@"TAB_YEARLY_CHECK_DOWNLOAD",@"t_System",@"t_JHA_USER_SELECTED_SCHEDULE_ITEM",@"t_LaborType",@"t_FIX_DOWNLOAD",@"t_FIX_JHA_USER_SELECTED_SCHEDULE_ITEM"];
    for (NSString *str in strArray) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",str];
        [OTISDB inDatabase:^(FMDatabase *db) {
            BOOL ret = [db executeUpdate:sql];
            if (ret) {
                //                            SZLog([NSString stringWithFormat:@"DELETE FROM %@ 成功",str]);
            }else{
                SZLog(@"清除本地数据失败!");
            }
        }];
    }
    AppDelegate *appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appD.annualInspectionCount =0 ;
    [[NSNotificationCenter defaultCenter] postNotificationName:SZNotificationUpdateBadgeViewCount object:self userInfo:nil];
    /**
     *  删除图片
     */
    if ([[NSFileManager defaultManager] removeItemAtPath:PicImageDir error:NULL]) {
        NSLog(@"Removed successfully");
    }

    /**
     *  删除图片
     */
    if ([[NSFileManager defaultManager] removeItemAtPath:kSignature error:NULL]) {
        NSLog(@"Removed successfully");
    }


}



+(void)clear{
//    NSArray *strArray = @[@"t_Route",@"t_Supervisor",@"t_System"];
//    for (NSString *str in strArray) {
//        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",str];
//        [OTISDB inDatabase:^(FMDatabase *db) {
//            BOOL ret = [db executeUpdate:sql];
//            if (ret) {
//                //                            SZLog([NSString stringWithFormat:@"DELETE FROM %@ 成功",str]);
//            }else{
//                SZLog(@"清除本地数据失败!");
//            }
//        }];
//    }
    NSString *sql = [NSString stringWithFormat:@"UPDATE t_Route SET ScheduleVer = 0  WHERE EmployeeID = %@ ",[OTISConfig EmployeeID]];

    [OTISDB inDatabase:^(FMDatabase *db) {
        BOOL ret = [db executeUpdate:sql];
        if (ret) {
            //                            SZLog([NSString stringWithFormat:@"DELETE FROM %@ 成功",str]);
        }else{
            SZLog(@"清除本地数据失败!");
        }
    }];
}



@end
