//
//  SZDownloadTool.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZDownloadTool.h"
#import "SZYearCheckItem.h"
#import "SZClearLocalDataTool.h"


@implementation SZDownloadTool


+(void)downloadSafetyItemWithRequest:(SZSafetyItemRequest*)request success:(void(^)(NSString *str))success failure:(void(^)(NSError *error))failure{
    
    [SZHttpTool post:[SZNetwork stringByAppendingString:APISafetyItemForOffline] parameters:request.mj_keyValues success:^(id obj) {
        
        SZLog(@"------%@",obj);
        SZSafetyItemResponse *response = [SZSafetyItemResponse mj_objectWithKeyValues:obj];
        if (response.Result.intValue == 3||response.Result.intValue == 0) {
            if (response.SafetyItemVer!=[SZTable_System safetyItemVer].integerValue) {
                
                [SZTable_CheckItem updateScheduleCards:response.SafetyItem];
                
                
                [SZTable_System updateTabSystemWithSafeItemVer:response.SafetyItemVer];
                if (response.SafetyItem.count>0) {
                    success(@"-下载安全项数据 成功！");
                }else{
                    success(@"");
                }
                //szlog(@"-下载安全项数据 成功！");

            }else{
                success(@"");
            
            }
        }
        
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}


+(void)downloadLaborTypeWithRequest:(SZLaborTypeRequest*)request success:(void(^)(NSString *str))success failure:(void(^)(NSError *error))failure{
    [SZHttpTool post:[SZNetwork stringByAppendingString:APILaborType] parameters:request.mj_keyValues success:^(id obj) {
//        szlog(@"%@",obj);
        SZLaborTypeResponse *response = [SZLaborTypeResponse mj_objectWithKeyValues:obj];
        
        if ([response.Result integerValue] == 0){
            
            if (response.LaborItemVer.integerValue!=[SZTable_System laborItemVer].integerValue) {
                [SZTable_LaborType storagWithLaborTypeResponse:response.Labor];
                
                [SZTable_System updateLaborTypeWithLaborItemVer:response.LaborItemVer];
                success(@"-下载工时类型数据 成功！");
            }else{
                success(@"");
            }
           
        }else{
             NSError * err = [NSError errorWithUserInfo:SZLocal(@"error.OTISDownloadLaborType")];
            failure(err);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];

}

+(void)downloadUnitsWithRequest:(SZDownload_UnitsRequest*)request success:(void(^)(NSString *str))success failure:(void(^)(NSError *error))failure
{
//    //szlog(@"电梯离线下载... %@",[NSThread currentThread]);

    [SZHttpTool post:[SZNetwork stringByAppendingString:APIUnitsForOffline] parameters:request.mj_keyValues success:^(id obj) {
        
            
        
            
            
        SZDownload_UnitsResponse *response = [SZDownload_UnitsResponse mj_objectWithKeyValues:obj];
        SZLog(@"response.Units.mj_keyValues : %@",obj);
//            //szlog(@"电梯离线下载...%@  %@",obj,[NSThread currentThread]);

        
            /**
             
             *  电梯下载成功
             
             */
            
            if ([response.Result integerValue] == 0) {
                
                
                if (response.Ver != [SZTable_Supervisor unitUpdateVer].integerValue) {
                    /**
                     
                     *  存储Buildings到SZTable_Building
                     
                     */
                    
                    [SZTable_Building storageBuildings:response.Buildings];
                    
                    /**
                     
                     *  存储Units到SZTable_Unit
                     
                     */
                    
                    [SZTable_Unit storageUnits:response.Units];
                    
                    
                    /**
                     *  存储电梯版本号到SZTable_Supervisor
                     */
                    [SZTable_Supervisor updateTabSupervisorWithUnitVer:response.Ver];
                    success(@"-下载电梯 成功！");
//                    ////szlog(@"-下载电梯数据 成功！");

                }else{
                
                    success(@"");

                }
                

                
            }else{
                
                NSError * err = [NSError errorWithUserInfo:SZLocal(@"error.OTISDownloadUnits")];
                
                failure(err);
                
            }
                
            
        } failure:^(NSError *error) {
        failure(error);
    }];
    
}

+(void)downloadUnScanedReasonWithRequest:(SZDownload_UnScanedReasonRequest *)request success:(void (^)(NSString *str))success failure:(void (^)(NSError *))failure{

    [SZHttpTool post:[SZNetwork stringByAppendingString:APIUnScanedReasonForOffline] parameters:request.mj_keyValues success:^(id obj) {
        SZDownload_UnScanedReasonResponse *response = [SZDownload_UnScanedReasonResponse mj_objectWithKeyValues:obj];
        if (response.Result.integerValue == 0) {
            [SZTable_Unit updateUnScanReasons:response.Units];
            success(@"-下载上次未扫描原因 成功！");
//            ////szlog(@"-下载未扫描原因数据 成功！");
        }else{
            NSError * err = [NSError errorWithUserInfo:SZLocal(@"error.OTISDownloadUnits")];
            
            failure(err);
        }
        
//        ////szlog(@"%@",obj);
    } failure:^(NSError *error) {
        
    }];


}



+(void)downloadSchedulesWithRequest:(SZDownload_V4Request*)request success:(void(^)(NSString *str))success failure:(void(^)(NSError *error))failure
{
    [SZHttpTool post:[SZNetwork stringByAppendingString:APISchedulesForOffline] parameters:request.mj_keyValues success:^(id obj) {
        
            
            
            
            //                ////szlog(@"计划离线下载。。。%@%@",[NSThread currentThread],statuses);
            
            SZDownload_V4Response *response = [SZDownload_V4Response mj_objectWithKeyValues:obj];
            
            /**
             
             *  计划下载成功
             
             */
            
            if ([response.Result integerValue] == 0) {
                
                    
                if (response.ScheduleVer != [SZTable_Route scheduleVer].integerValue) {
                    /**
                     *  有版本更新就删除本地数据
                     */
                    [SZClearLocalDataTool clearData];
                    
                    /**
                     *  存储Schedules到SZTable_Schedules
                     */
                    [SZTable_Schedules storageSchedules:response.Schedules];
                    
                    /**
                     *  保存计划版本号和时间戳
                     */
                    [SZTable_Route updateTabRouteWithScheduleVer:response.ScheduleVer timeStamp:[response.TimeStamp integerValue]];
                     success(@"-下载计划 成功！");
                    ////szlog(@"-下载计划数据 成功！");

                }else{
                
                
                    success(@"");
                
                }
                
                
            }else{
                
                NSError * err = [NSError errorWithUserInfo:SZLocal(@"error.OTISDownloadSchedules")];
                
                failure(err);

                
            }
            

        
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

+(void)downloadScheduleCardsWithRequest:(SZDownload_CardsRequest*)request success:(void(^)(NSString *str))success failure:(void(^)(NSError *error))failure
{
    [SZHttpTool post:[SZNetwork stringByAppendingString:APIScheduleCardsForOffline] parameters:request.mj_keyValues success:^(id obj) {
        //            ////szlog(@"保养卡离线下载。。。%@",[NSThread currentThread]);
        
        SZDownload_CardsResponse *response = [SZDownload_CardsResponse mj_objectWithKeyValues:obj];
        
        if ([response.Result integerValue] == 0) {

                /**
                 *  如果本地保养项版本号和response.Ver不一样就全部删除重新存，否则不用存
                 */
                if (![response.Ver isEqualToString:[SZTable_System updateVer]]) {
                    /**
                     *  存储Items到SZTable_SchedulesCards
                     */

                    [SZTable_CheckItem storageScheduleCards:response.Items];
                    /**
                     *  存储Schedule到SZTable_ScheduleCheckItem
                     */
                    [SZTable_ScheduleCheckItem storageScheduleCheckItems:response.Schedule];
                    /**
                     *  保存计划保养项版本号
                     */
                    [SZTable_System updateTabSystemWithUpdateVer:response.Ver];
                    success(@"-下载安全保养项目 成功！");
                    ////szlog(@"-下载保养项数据 成功");
                }else{
                
                    success(@"");

                
                }
            
            
        }else{
            
            NSError * err = [NSError errorWithUserInfo:SZLocal(@"error.OTISDownloadSchedulesCards")];
            
            failure(err);
            
            
            
        }
        

    } failure:^(NSError *error) {
        failure(error);
    }];
    
    
}

+(void)downloadUnfinishedItemsWithRequest:(SZDownload_UnfinishedItemsRequest*)request success:(void(^)(NSString *str))success failure:(void(^)(NSError *error))failure
{
    [SZHttpTool post:[SZNetwork stringByAppendingString:APIUnfinishedItemsForOffline] parameters:request.mj_keyValues success:^(id obj) {
        
            
            //   ////szlog(@"未完成项离线下载...%@",statuses);
            
            SZDownload_UnfinishedItemsResponse *response = [SZDownload_UnfinishedItemsResponse mj_objectWithKeyValues:obj];
            
            if ([response.Result integerValue] == 0) {
                
                if (response.ReportStamp!=[[SZTable_Route reportDate] integerValue] && response.Report.count) {
                    
                    [SZTable_UnfinishedMaintenanceItem storgeTabReportItemCompleteState:response];
                    
                    
//                    if (response.Report.count>0) {
//                        success(@"-下载同事的保养报告 成功！");
//                        
//
//                    }else{
//                        success(@"");
//                    }
                    ////szlog(@"-下载未完成项数据 成功！");

                }
                
                if (response.FixStamp!=[[SZTable_Route fixDate] integerValue] && response.Fix.count) {
                    
                    [SZTable_UnfinishedMaintenanceItem storgeFixItemCompleteState:response];
                    
                    /**
                     *  保存未完成项版本号和时间戳
                     */
                    [SZTable_Route updateTabRouteWithReportDate:response.ReportStamp fixDate:response.FixStamp];
                    success(@"-下载未完成项 成功！");

                }else{
                
                    success(@"");

                }
                

                
            }else{
                
                NSError * err = [NSError errorWithUserInfo:SZLocal(@"error.OTISDownloadUnfinishedItems")];
                
                failure(err);
                
            }
            

        
    } failure:^(NSError *error) {
        failure(error);
    }];
    
    
}


+(void)downloadReservedSubjectWithRequest:(SZDownload_ReservedSubjectRequest*)request success:(void(^)(NSString *str))success failure:(void(^)(NSError *error))failure{
    
    [SZHttpTool post:[SZNetwork stringByAppendingString:APIReservedSubjectForOffline] parameters:request.mj_keyValues success:^(id obj) {
        success(obj);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}


+(void)downloadYearCheckWithRequest:(SZYearCheckRequest*)request success:(void(^)(NSString *str))success failure:(void(^)(NSError *error))failure{
    
    [SZHttpTool post:[SZNetwork stringByAppendingString:APIYCheckForOffline] parameters:request.mj_keyValues success:^(id obj) {
        SZLog(@"年检下载...%@",obj);
        //
        SZYearCheckResponse *response = [SZYearCheckResponse mj_objectWithKeyValues:obj];

        if ([response.Result integerValue] == 0){
            
            if (response.TimeStamp!=[SZTable_Route yCheckDate].integerValue ) {
                
                [SZTable_YearlyCheckDownload storageYearlyCheckWithParams:response.YCheck];
                [SZTable_Route updateTabRouteWithYCheckDate:response.TimeStamp];
                if (response.YCheck.count == 0) {
                    success(@"");

                }else{
                    success(@"-下载已年检记录 成功");
                }

            }else{
            
                success(@"");

            }
           


        }
        
        
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}




@end
