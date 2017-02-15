//
//  SZUploadTool.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/24.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZUploadTool.h"
#import "SZHttpTool.h"
#import "SZModuleQueryTool.h"
#import "SZUploadResponse.h"
#import "SZUploadFixResponse.h"
#import "TablesAndFields.h"
#import "SZUploadMaintenancePicRequest.h"
#import "SZUploadFullLaborHoursRequest.h"
#import "NSData+AES256.h"
#import "AppDelegate.h"
#import "SZNavigationController.h"
#import "NSDate+Extention.h"

@implementation SZUploadTool

+(void)uploadMaintenanceSuccess:(void(^)(NSString *))success failure:(void(^)(NSError *error))failure done:(void(^)(NSString *))done{
    NSArray *arrayUploadData = [SZModuleQueryTool queryMaintenanceUploadData];
    if (arrayUploadData.count == 0) {
        done(@"");
    }
   __block NSInteger count = 0;
    for (NSString *strUpload in arrayUploadData) {
        SZLog(@"维保上传数据：%@",strUpload);
        
        [SZHttpTool post:[SZNetwork stringByAppendingString:APIUploadSaveReportV7] parameters:strUpload success:^(id obj) {
            count++;
            SZLog(@"维保上传%@",obj);
            SZUploadResponse *response = [SZUploadResponse mj_objectWithKeyValues:obj];
            
            if ([response.Result isEqualToString:@"0"]) {
                if (count == arrayUploadData.count) {
                    [SZTable_Report storageIsUploaded:YES withScheduleId:response.ScheduleID.intValue];
                    
                    done([NSString stringWithFormat:@"上传%@保养操作成功！",response.UnitNo]);
                }else{
                    
                    
                    [SZTable_Report storageIsUploaded:YES withScheduleId:response.ScheduleID.intValue];
                    success([NSString stringWithFormat:@"上传%@保养操作成功！",response.UnitNo]);
                    SZLog(@"维保上传成功返回%@",obj);
                    
                }
                NSInteger yymmdd =  [NSDate currentYYMMDD];
                NSString *strKey = [NSString stringWithFormat:@"%ld_%@START",yymmdd,response.UnitNo];
                [USER_DEFAULT setObject:nil forKey:strKey];
                strKey = [NSString stringWithFormat:@"%ld_%@ENDJHA",yymmdd,response.UnitNo];
                [USER_DEFAULT setObject:nil forKey:strKey];
                strKey = [NSString stringWithFormat:@"%ld_%@END",yymmdd,response.UnitNo];
                [USER_DEFAULT setObject:nil forKey:strKey];
                [USER_DEFAULT setObject:nil forKey:@"ENDTIME"];
                strKey = [NSString stringWithFormat:@"%ld_%@zhongduan",yymmdd,response.UnitNo];
                [USER_DEFAULT setObject:nil forKey:strKey];
                strKey = [NSString stringWithFormat:@"%ld_%@zhongduanTime",yymmdd,response.UnitNo];
                [USER_DEFAULT setObject:nil forKey:strKey];
                strKey = [NSString stringWithFormat:@"%ld_%@lutuTime",yymmdd,response.UnitNo];
                [USER_DEFAULT setObject:nil forKey:strKey];

            }else{
            
                success([NSString stringWithFormat:@"上传%@保养操作失败！",response.UnitNo]);

                [[NSNotificationCenter defaultCenter] postNotificationName:SZNotificationUploadFailed object:self userInfo:nil];

                if (count == arrayUploadData.count) {
                    [SZTable_Report storageIsUploaded:YES withScheduleId:response.ScheduleID.intValue];
                    

                }else{
                    
                    
                    [SZTable_Report storageIsUploaded:YES withScheduleId:response.ScheduleID.intValue];
                    success([NSString stringWithFormat:@"上传%@保养操作失败！",response.UnitNo]);
                    
                    
                }

            }

            
            
        } failure:^(NSError *error) {
            

        }];
    }
    

}


/**
 *  维保照片上传
 */
+(void)uploadMaintenancePicSuccess:(void(^)(NSString *))success failure:(void(^)(NSError *error))failure done:(void(^)(NSString *))done{

    NSArray *arrayUploadData = [SZModuleQueryTool queryUploadImageData];
    if (arrayUploadData.count == 0) {
        done(@"");
    }
    __block NSInteger count = 0;

    for (SZUploadMaintenancePicRequest *request in arrayUploadData) {
        
        SZImageUploadParam *param = [[SZImageUploadParam alloc] init];
        param.data = UIImageJPEGRepresentation(request.image, 0.4);
        param.fileName = @"filename";
        param.paramName = @"paramname";
        
        NSMutableDictionary *dic = request.mj_keyValues;
        [dic removeObjectForKey:@"image"];
        SZLog(@"维保照片上传:%@",dic);
        [SZHttpTool upload:[SZNetwork stringByAppendingString:APIUploadImageV3] param:dic uploadParam:param success:^(id obj) {
            count++;

            SZLog(@"维保照片上传数据%@",obj);

            SZUploadResponse *response = [SZUploadResponse mj_objectWithKeyValues:obj];
            
            
            if (count == arrayUploadData.count) {
                
                if ([response.Result isEqualToString:@"0"]) {
                    
                    if (response.Type == 6) {// 签字图片
                        
                        [SZTable_Signature uploadedImagewithSignId:response.ScheduleID.intValue];
                        
                        done([NSString stringWithFormat:@"上传%@签名图片 成功！",response.UnitNo]);
                        /**
                         *  删除图片
                         */
                        if ([[NSFileManager defaultManager] removeItemAtPath:kSignature error:NULL]) {
                            NSLog(@"Removed successfully");
                        }
                    }else{// 保养图片
                        [SZTable_Signature uploadedWeibaoImagewithScheduleID:response.ScheduleID.intValue];

                        done([NSString stringWithFormat:@"上传%@保养图片 成功！",response.UnitNo]);
                        /**
                         *  删除图片
                         */
                        if ([[NSFileManager defaultManager] removeItemAtPath:PicImageDir error:NULL]) {
                            NSLog(@"Removed successfully");
                        }
                        SZLog(@"维保照片上传成功返回%@",obj);
                    }
                    
                }else{
                    

                    
                    if (response.Type == 6) {
                        [SZTable_Signature uploadedImagewithSignId:response.ScheduleID.intValue];
                        success([NSString stringWithFormat:@"上传%@签名图片 失败！",response.UnitNo]);
                    }else{
                        success([NSString stringWithFormat:@"上传%@保养图片 失败！",response.UnitNo]);
                        //                    SZLog(@"维保照片上传成功返回%@",obj);
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:SZNotificationUploadFailed object:self userInfo:nil];

                }
                
            }else{
            
                if ([response.Result isEqualToString:@"0"]) {
                    if (response.Type == 6) {
                        [SZTable_Signature uploadedImagewithSignId:response.ScheduleID.intValue];
                        success([NSString stringWithFormat:@"上传%@签名图片成功！",response.UnitNo]);
                    }else{
                        [SZTable_Signature uploadedWeibaoImagewithScheduleID:response.ScheduleID.intValue];
                        success([NSString stringWithFormat:@"上传%@保养图片 成功！",response.UnitNo]);
                        SZLog(@"维保照片上传成功返回%@",obj);
                    }
                    
                }else{
                    if (response.Type == 6) {
                        [SZTable_Signature uploadedImagewithSignId:response.ScheduleID.intValue];
                        success([NSString stringWithFormat:@"上传%@签名图片 失败！",response.UnitNo]);
                    }else{
                        success([NSString stringWithFormat:@"上传%@保养图片 失败！",response.UnitNo]);
                        //                    SZLog(@"维保照片上传成功返回%@",obj);
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:SZNotificationUploadFailed object:self userInfo:nil];

                    
                }
                
            }

            
            
            
        } failure:^(NSError *error) {
            


        }];
    }
}



/**
 * 维修换件报告上传
 */
+(void)uploadFixSuccess:(void(^)(NSString *))success failure:(void(^)(NSError *error))failure done:(void(^)(NSString *))done{

    NSArray *arrayUploadData = [SZModuleQueryTool queryFixUploadData];
    __block NSInteger count = 0;
    if (arrayUploadData.count == 0) {
        done(@"");
    }
    for (NSString *strUpload in arrayUploadData) {
        SZLog(@"维修换件报告上传数据：%@",strUpload);
        [SZHttpTool post:[SZNetwork stringByAppendingString:APISaveFixV4] parameters:strUpload success:^(id obj) {
            count++;

//            SZLog(@"维修换件报告上传%@",obj);
            
            SZUploadFixResponse *response = [SZUploadFixResponse mj_objectWithKeyValues:obj];
            
            
            if ([response.Result isEqualToString:@"0"]) {
                
                if (count == arrayUploadData.count) {
                    
                    [SZTable_REPORT_ITEM_COMPLETE_STATE updateUploadedWithScheduleId:response.ScheduleID];

                    done([NSString stringWithFormat:@"上传%@维修换件报告成功!",response.UnitNo]);
                }else{
                    
                    [SZTable_REPORT_ITEM_COMPLETE_STATE updateUploadedWithScheduleId:response.ScheduleID];

                    success([NSString stringWithFormat:@"上传%@维修换件报告成功!",response.UnitNo]);
                }
            
                
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:SZNotificationUploadFailed object:self userInfo:nil];

                done(@"");

            }
           
        } failure:^(NSError *error) {
            

        }];
    }
}

///**
// * 批量中断上传
// */
//+(void)uploadReportInBatchesSuccess:(void(^)(NSString *))success failure:(void(^)(NSError *error))failure{
//
//
//}

/**
 * 上传签字数据
 */
+(void)uploadSignatureSuccess:(void(^)(NSString *))success failure:(void(^)(NSError *error))failure done:(void(^)(NSString *))done{
    NSArray *arrayUploadData = [SZModuleQueryTool queryUploadSignature];
    __block NSInteger count = 0;
    if (arrayUploadData.count == 0) {
        done(@"");
    }
    for (NSString *strUpload in arrayUploadData) {
        SZLog(@"信息：上传签字数据：%@",strUpload);
        [SZHttpTool post:[SZNetwork stringByAppendingString:APIESignatureV5] parameters:strUpload success:^(id obj) {
            count++;
            
            SZLog(@"信息 上传签字返回结果：%@",obj);
            SZUploadFixResponse *response = [SZUploadFixResponse mj_objectWithKeyValues:obj];
            if ([response.Result isEqualToString:@"0"]) {
                if (count == arrayUploadData.count) {
                    SZLog(@"上传全部签字成功返回%@",obj);
                    [SZTable_Signature uploadedwithSignId:response.SignID];
                    done([NSString stringWithFormat:@"上传签字记录成功！"]);
                }else{
                    SZLog(@"上传单个签字成功返回%@",obj);
                    [SZTable_Signature uploadedwithSignId:response.SignID];
                    success([NSString stringWithFormat:@"上传签名记录成功！"]);
                }
            }else{
                success(@"错误：签字上传失败");
                [[NSNotificationCenter defaultCenter] postNotificationName:SZNotificationUploadFailed object:self userInfo:nil];

            }
            
        } failure:^(NSError *error) {
            done(SZLocal(@"NoNetwork"));

        }];
    }
}

/**
 * 上传年检记录
 */
+(void)uploadYearlyCheckSuccess:(void(^)(NSString *))success failure:(void(^)(NSError *error))failure done:(void(^)(NSString *))done{

    NSArray *arrayUploadData = [SZModuleQueryTool queryYearlyCheckUpload];
    if (arrayUploadData.count == 0) {
        done(@"");
    }
    __block NSInteger count = 0;

    for (NSString *strUpload in arrayUploadData) {
        SZLog(@"上传年检记录数据：%@",strUpload);
        [SZHttpTool post:[SZNetwork stringByAppendingString:APISaveYearlyCheck] parameters:strUpload success:^(id obj) {
            count++;

            SZLog(@"年检记录上传%@",obj);
            SZUploadResponse *response = [SZUploadResponse mj_objectWithKeyValues:obj];
            if ([response.Result isEqualToString:@"0"]) {
                if (count == arrayUploadData.count) {
                    
                    [SZTable_YearlyCheck updateYearlyCheckDone];
                    done([NSString stringWithFormat:@"上传%@年检记录成功！",response.UnitNo]);
                }else{
//                    [SZTable_YearlyCheck updateYearlyCheckDone];
                    success([NSString stringWithFormat:@"上传%@年检记录成功！",response.UnitNo]);
                }
                
                
//                SZLog(@"年检记录上传成功返回%@",obj);
            }else{
                done(@"");
                [[NSNotificationCenter defaultCenter] postNotificationName:SZNotificationUploadFailed object:self userInfo:nil];

            }
            
        } failure:^(NSError *error) {
            done(SZLocal(@"NoNetwork"));

        }];
    }

}




/**
 * 上传全工时数据
 */
+(void)uploadFullLaborHoursSuccess:(void(^)(NSString *))success failure:(void(^)(NSError *error))failure{
    SZLog(@"%@",[SZModuleQueryTool queryFullLaborHoursUpload]);
    if ([SZModuleQueryTool queryFullLaborHoursUpload] == nil) {
         success(@"");
        return;
    }
   __block NSMutableDictionary *dic = [SZModuleQueryTool queryFullLaborHoursUpload];
   
    NSString *str = (NSString *)(dic.mj_keyValues);
    SZLog(@"全工时数据上传数据：%@",str);

    [SZHttpTool post:[SZNetwork stringByAppendingString:APISaveFullLaborHours] parameters:str success:^(id obj) {
        
        SZLog(@"全工时数据上传成功返回%@",obj);
        SZUploadResponse *response = [SZUploadResponse mj_objectWithKeyValues:obj];
        if ([response.Result isEqualToString:@"0"]) {
            
            if ([SZTable_LaborHours queryhasHoursUploadData]) {
                [SZTable_LaborHours clearData];
                success([NSString stringWithFormat:@"上传%@工时记录成功！",[SZTable_LaborHours queryDatetime]]);
            }else{
                success(@"");
            }
            
        }else{
//            failure([NSError errorWithUserInfo:@"xxxx"]);
            success(@"");
            [[NSNotificationCenter defaultCenter] postNotificationName:SZNotificationUploadFailed object:self userInfo:nil];

        }
        
    } failure:^(NSError *error) {

        failure(error);
    }];

}

/**
 * 上传日志
 */
+(void)uploadLogSuccess:(void(^)(NSString *))success failure:(void(^)(NSError *error))failure{



}


@end
