//
//  SZUploadManger.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/30.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZUploadManger.h"
#import "SZUploadTool.h"
#import "SZSynchronizationView.h"
#import <MBProgressHUD.h>
#import "SZDownloadManger.h"
#import "SZDownloadTool.h"
#import "CustomIOSAlertView.h"
#import "SZHttpTool.h"
#import "SZForceUpdateModel.h"
#import "SZTipVIew.h"
#import "AppDelegate.h"
#import "SZAnnualInspectionViewController.h"

#define kUploadCompeted      if (ret1&&ret2&&ret3&&ret4&&ret5&&ret6)
#define kDownloadCompeted      if (ret1&&ret2&&ret3&&ret4&&ret5&&ret6&&ret7&&ret8)


@interface SZUploadManger ()


@end

@implementation SZUploadManger
static MBProgressHUD *hud;
static SZSynchronizationView *fatherView;
static CustomIOSAlertView *alertView;



+(void)startUploadWithView:(UIView *)view success:(void(^)())success{
    
    hud =[MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = SZLocal(@"dialog.title.Data synchronization");
    hud.mode = MBProgressHUDModeIndeterminate;
    
    fatherView = [[SZSynchronizationView alloc] initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, SCREEN_HEIGHT)];
    fatherView.center = view.center;
    [view addSubview:fatherView];
    [view insertSubview:hud aboveSubview:fatherView];
    
    
    
    
    
    //1 uploadMaintenanceSuccess
    [SZUploadTool uploadMaintenanceSuccess:^(NSString *str) {
        [self synchronizData:str fatherView:fatherView];
    } failure:^(NSError *error) {
        
    }done:^(NSString *str){
        
//        if ([str isEqualToString:@"失败"]) {
//            [self fauilTipView:view];
//        }
        

        [self synchronizData:str fatherView:fatherView];

        //2 uploadMaintenancePicSuccess
        [SZUploadTool uploadMaintenancePicSuccess:^(NSString *str) {
            [self synchronizData:str fatherView:fatherView];
            
        } failure:^(NSError *error) {
            
            
        }done:^(NSString *str){
            
            
            [self synchronizData:str fatherView:fatherView];
            //3 uploadSignatureSuccess
            [SZUploadTool uploadSignatureSuccess:^(NSString *str) {
                [self synchronizData:str fatherView:fatherView];
            } failure:^(NSError *error) {
                
            }done:^(NSString *str){
                [self synchronizData:str fatherView:fatherView];
                //4
                [SZUploadTool uploadFixSuccess:^(NSString *str) {
                    [self synchronizData:str fatherView:fatherView];
                } failure:^(NSError *error) {
                    
                }done:^(NSString *str){
                    [self synchronizData:str fatherView:fatherView];
                    
                    //5
                    [SZUploadTool uploadYearlyCheckSuccess:^(NSString *str) {
                        [self synchronizData:str fatherView:fatherView];
                        
                    } failure:^(NSError *error) {
                        
                    }done:^(NSString *str){
                        [self synchronizData:str fatherView:fatherView];
                        
                        //6
                        [SZUploadTool uploadFullLaborHoursSuccess:^(NSString *str) {
                            [self synchronizData:str fatherView:fatherView];
                            //7
                            [self doneWithView:view];
                            success();
                            
                        } failure:^(NSError *error) {
                            [self doneWithView:view];
                            
                            
                        }];
                        
                        
                    }];
                    
                }];
                
                
            }];
            
            
            
        }];
        
        
        
    }];
    
    
}



+(void)startDownloadWithView:(UIView *)view fatherView:(SZSynchronizationView *)veiw{

    
    
    
    
    [SZDownloadTool downloadSchedulesWithRequest:[SZDownload_V4Request v4Request] success:^(NSString *str) {
        [self synchronizData:str fatherView:fatherView];
        
        
        //2
        [SZDownloadTool downloadUnitsWithRequest:[SZDownload_UnitsRequest unitsRequest] success:^(NSString *str) {
            [self synchronizData:str fatherView:fatherView];
            
            //                kDownloadCompeted  [self doneWithView:view];
            //3
            [SZDownloadTool downloadScheduleCardsWithRequest:[SZDownload_CardsRequest cardsRequest] success:^(NSString *str) {
                [self synchronizData:str fatherView:fatherView];
                
                //                    kDownloadCompeted  [self doneWithView:view];
                //4
                [SZDownloadTool downloadUnfinishedItemsWithRequest:[SZDownload_UnfinishedItemsRequest unfinishedItemsRequest] success:^(NSString *str) {
                    [self synchronizData:str fatherView:fatherView];
                    
                    //                        kDownloadCompeted  [self doneWithView:view];
                    //5
                    
                    [SZDownloadTool downloadSafetyItemWithRequest:[SZSafetyItemRequest safetyItemRequest] success:^(NSString *str) {
                        [self synchronizData:str fatherView:fatherView];
                        
                        //                            kDownloadCompeted  [self doneWithView:view];
                    } failure:^(NSError *error) {
                    }];
                    //6
                    
                    [SZDownloadTool downloadYearCheckWithRequest:[SZYearCheckRequest yearCheckRequest] success:^(NSString *str) {
                        [self synchronizData:str fatherView:fatherView];
                        
                        //                            kDownloadCompeted  [self doneWithView:view];
                        //7
                        [SZDownloadTool downloadLaborTypeWithRequest:[SZLaborTypeRequest laborTypeRequest] success:^(NSString *str) {
                            [self synchronizData:str fatherView:fatherView];
                            
                            //                                kDownloadCompeted  [self doneWithView:view];
                            //8
                            
                            [SZDownloadTool downloadUnScanedReasonWithRequest:[SZDownload_UnScanedReasonRequest unScanedReasonRequest] success:^(NSString *str) {
                                [self synchronizData:str fatherView:fatherView];
                                
                                [self doneWithView:view];
                                
                            } failure:^(NSError *error) {
                            }];
                            
                            
                        } failure:^(NSError *error) {
                        }];
                        
                        
                    } failure:^(NSError *error) {
                    }];
                    
                    
                } failure:^(NSError *error) {
                    
                }];
                
                
            } failure:^(NSError *error) {
            }];
            
            
        } failure:^(NSError *error) {
            
        }];
        
        
        
        
    } failure:^(NSError *error) {
    }];

    
}

//强制更新
+(void)forceUpdate{
    
    [SZHttpTool post:APIForceUpdate parameters:nil success:^(id obj) {
        NSData *jsonData = [obj dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        SZForceUpdateModel* updateModel=[SZForceUpdateModel mj_objectWithKeyValues:dic[@"AppVerInfo"]];
        NSString *string = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        SZLog(@"===========%@",string);
    } failure:^(NSError *error) {
        SZLog(@"******%@",error);
    }];
}

+(void)compareVersion:(NSString*)currentVersion serverVersion:(NSString*)version{
    
    NSString* currentVersion1=[currentVersion substringFromIndex:0];
    NSArray* versionArray=[currentVersion1 componentsSeparatedByString:@"."];
    NSString* currentVersion2=@"";
    for (NSString* str  in versionArray) {
        currentVersion2=[currentVersion2 stringByAppendingString:str];
    }
   // NSString* currentVersion2=[NSString stringWithFormat:@"%@%@%@",versionArray[0],versionArray[1],versionArray[2]];
    SZLog(@"******%@",currentVersion2);

    NSString* version1=[version substringFromIndex:1];
    NSArray* versionArray1=[version1 componentsSeparatedByString:@"."];
    NSString* version2=@"";
    for (NSString* str  in versionArray1) {
        version2=[version2 stringByAppendingString:str];
    }
    SZLog(@"******%@",version2);
    
    if ([version2 integerValue]>[version1 integerValue]) {
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@"person"
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:SZLocal(@"dialog.title.Find a new version of the update")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"),SZLocal(@"btn.title.cencel"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            [alertView close];
        };
        [alertView show];
    }
}

+(void)synchronizData:(NSString *)str fatherView:(SZSynchronizationView *)veiw{
    if (str.length>2) {
        [veiw.dateArray addObject:str];
        [veiw SynchronizData];
    }
}

+(void)doneWithView:(UIView *)view {

    [hud hide:YES];
    [alertView close];
    
    alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                 dialogContents:SZLocal(@"dialog.title.Synchronized success!")
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        [fatherView removeFromSuperview];
        fatherView = nil;
        [alertView close];
    };
    [alertView show];

    
    [[NSNotificationCenter defaultCenter] postNotificationName:SZNotificationUpdateBadgeViewCount object:self userInfo:nil];

}


+(void)fauilTipView:(UIView *)view {
    
    [hud hide:YES];
    [alertView close];
    
    alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                dialogTitle:SZLocal(@"dialog.title.tip")
                                                             dialogContents:SZLocal(@"dialog.title.Please check to ensure that the network is under normal synchronization data")
                                                              dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        [fatherView removeFromSuperview];
        fatherView = nil;
        [alertView close];
    };
    [alertView show];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SZNotificationUpdateBadgeViewCount object:self userInfo:nil];
    
}



+(void)uploadFauilTipView:(UIView *)view {
    
    [hud hide:YES];
    [alertView close];
    

    
    
    
    alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                dialogTitle:SZLocal(@"dialog.title.tip")
                                                             dialogContents:SZLocal(@"dialog.title.Data synchronization failure!")
                                                              dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.cancelSy"),SZLocal(@"btn.title.ContinueSynchronization"), nil]];
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        
        [fatherView removeFromSuperview];
        fatherView = nil;
        [alertView close];

        if(buttonIndex == 0){
            
        }else if(buttonIndex == 1){
            [self startUploadAndDownloadWithView:view];
        }
        
    };
    [alertView show];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SZNotificationUpdateBadgeViewCount object:self userInfo:nil];
    
}


+(void)startUploadAndDownloadWithView:(UIView *)view{
    
    hud =[MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText =SZLocal(@"dialog.title.Data synchronization");
    hud.mode = MBProgressHUDModeIndeterminate;
    
    fatherView = [[SZSynchronizationView alloc] initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, SCREEN_HEIGHT)];
    fatherView.center = view.center;
    [view addSubview:fatherView];
    [view insertSubview:hud aboveSubview:fatherView];
    

SZLog(@"~~~~~~~~~ startUploadAndDownloadWithView uploade");
    
    
    //1 uploadMaintenanceSuccess
    [SZUploadTool uploadMaintenanceSuccess:^(NSString *str) {
        [self synchronizData:str fatherView:fatherView];
    } failure:^(NSError *error) {
        
    }done:^(NSString *str){
        
//        if ([str isEqualToString:@"失败"]) {
//            [self fauilTipView:view];
//        }
        
        [self synchronizData:str fatherView:fatherView];
        
        //2 uploadMaintenancePicSuccess
        [SZUploadTool uploadMaintenancePicSuccess:^(NSString *str) {
            [self synchronizData:str fatherView:fatherView];
            
        } failure:^(NSError *error) {
            
            
        }done:^(NSString *str){
            [self synchronizData:str fatherView:fatherView];
            //3 uploadSignatureSuccess
            SZLog(@"~~~~~~~~~ uploadSignatureSuccess uploade");
            [SZUploadTool uploadSignatureSuccess:^(NSString *str) {
                [self synchronizData:str fatherView:fatherView];
            } failure:^(NSError *error) {
                
            }done:^(NSString *str){
                [self synchronizData:str fatherView:fatherView];
                //4
                SZLog(@"~~~~~~~~~ fix uploade");
                [SZUploadTool uploadFixSuccess:^(NSString *str) {
                    
                    [self synchronizData:str fatherView:fatherView];
                } failure:^(NSError *error) {
                    
                }done:^(NSString *str){
                    [self synchronizData:str fatherView:fatherView];
                    
                    //5
                    [SZUploadTool uploadYearlyCheckSuccess:^(NSString *str) {
                        [self synchronizData:str fatherView:fatherView];
                        
                    } failure:^(NSError *error) {
                        
                    }done:^(NSString *str){
                        [self synchronizData:str fatherView:fatherView];
                        
                        //6
                        
                        
//                        [SZUploadTool uploadFullLaborHoursSuccess:^(NSString *str) {
//                            [self synchronizData:str fatherView:fatherView];
//                            //7
//                            [self startDownloadWithView:view fatherView:fatherView];
//                            
//                        } failure:^(NSError *error) {
//                            [self startDownloadWithView:view fatherView:fatherView];
//
//                        }];
//

                        
                        [SZUploadTool mdUploadAutomSuccess:^(NSString * str) {
                            [self synchronizData:str fatherView:fatherView];
                            [self startDownloadWithView:view fatherView:fatherView];
                            //                            //7
                        } failure:^(NSError *error) {
                            [self synchronizData:str fatherView:fatherView];

                        } done:^(NSString *str) {
                        }];
                        
//
                    }];
                    
                }];
                
                
            }];
            
            
            
        }];
        
        
        
    }];

}






+(void)startUploadAndDownloadFirstTimeWithView:(UIView *)view{
    
    hud =[MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = SZLocal(@"dialog.title.Data synchronization");
    hud.mode = MBProgressHUDModeIndeterminate;
    
    fatherView = [[SZSynchronizationView alloc] initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, SCREEN_HEIGHT)];
    fatherView.center = view.center;
    [view addSubview:fatherView];
    [view insertSubview:hud aboveSubview:fatherView];
    
    //1uploadMaintenanceSuccess
    [SZUploadTool uploadMaintenanceSuccess:^(NSString *str) {
        [self synchronizData:str fatherView:fatherView];
    } failure:^(NSError *error) {
        
    }done:^(NSString *str){
        [self synchronizData:str fatherView:fatherView];
      
        //2uploadMaintenanceSuccess
        [SZUploadTool uploadMaintenancePicSuccess:^(NSString *str) {
            [self synchronizData:str fatherView:fatherView];
            
        } failure:^(NSError *error) {
        
            
        }done:^(NSString *str){
            [self synchronizData:str fatherView:fatherView];
        //3
            [SZUploadTool uploadSignatureSuccess:^(NSString *str) {
                [self synchronizData:str fatherView:fatherView];
            } failure:^(NSError *error) {
                
            }done:^(NSString *str){
                [self synchronizData:str fatherView:fatherView];
               //4
                [SZUploadTool uploadFixSuccess:^(NSString *str) {
                    [self synchronizData:str fatherView:fatherView];
                } failure:^(NSError *error) {
                    
                }done:^(NSString *str){
                    [self synchronizData:str fatherView:fatherView];
                    
                    //5
                    [SZUploadTool uploadYearlyCheckSuccess:^(NSString *str) {
                        [self synchronizData:str fatherView:fatherView];
                        
                    } failure:^(NSError *error) {
                        
                    }done:^(NSString *str){
                        [self synchronizData:str fatherView:fatherView];
       
                        //6
                        [SZUploadTool uploadFullLaborHoursSuccess:^(NSString *str) {
                            [self synchronizData:str fatherView:fatherView];
                            //7
                            [self startFirstTimeDownloadWithView:view fatherView:fatherView];
                            
                        } failure:^(NSError *error) {
                           
                            [self startFirstTimeDownloadWithView:view fatherView:fatherView];

                        }];
                        
                        
                    }];

                }];

                
            }];

            
            
        }];

        
        
    }];
    
    
}

+(void)startFirstTimeDownloadWithView:(UIView *)view fatherView:(SZSynchronizationView *)veiw{
    
    
    
    
    [SZDownloadTool downloadSchedulesWithRequest:[SZDownload_V4Request v4Request] success:^(NSString *str) {
        [self synchronizData:str fatherView:fatherView];
        
        
        //2
        [SZDownloadTool downloadUnitsWithRequest:[SZDownload_UnitsRequest unitsRequest] success:^(NSString *str) {
            [self synchronizData:str fatherView:fatherView];
            
            //                kDownloadCompeted  [self doneWithView:view];
            //3
            [SZDownloadTool downloadScheduleCardsWithRequest:[SZDownload_CardsRequest cardsRequest] success:^(NSString *str) {
                [self synchronizData:str fatherView:fatherView];
                
                //                    kDownloadCompeted  [self doneWithView:view];
                //4
                [SZDownloadTool downloadUnfinishedItemsWithRequest:[SZDownload_UnfinishedItemsRequest unfinishedItemsRequest] success:^(NSString *str) {
                    [self synchronizData:str fatherView:fatherView];
                    
                    //                        kDownloadCompeted  [self doneWithView:view];
                    //5
                    
                    [SZDownloadTool downloadSafetyItemWithRequest:[SZSafetyItemRequest safetyItemRequest] success:^(NSString *str) {
                        [self synchronizData:str fatherView:fatherView];
                        
                        //                            kDownloadCompeted  [self doneWithView:view];
                    } failure:^(NSError *error) {
                    }];
                    //6
                    
                    [SZDownloadTool downloadYearCheckWithRequest:[SZYearCheckRequest yearCheckRequest] success:^(NSString *str) {
                        [self synchronizData:str fatherView:fatherView];
                        
                        //                            kDownloadCompeted  [self doneWithView:view];
                        //7
                        [SZDownloadTool downloadLaborTypeWithRequest:[SZLaborTypeRequest laborTypeRequest] success:^(NSString *str) {
                            [self synchronizData:str fatherView:fatherView];
                            
                            //                                kDownloadCompeted  [self doneWithView:view];
                            //8
                            
                            [SZDownloadTool downloadUnScanedReasonWithRequest:[SZDownload_UnScanedReasonRequest unScanedReasonRequest] success:^(NSString *str) {
                                [self synchronizData:str fatherView:fatherView];
                                
                                 [self doneFirstTimeWithView:view];
                                
                            } failure:^(NSError *error) {
                            }];
                            
                            
                        } failure:^(NSError *error) {
                        }];
                        
                        
                    } failure:^(NSError *error) {
                    }];
                    
                    
                } failure:^(NSError *error) {
                    
                }];
                
                
            } failure:^(NSError *error) {
            }];
            
            
        } failure:^(NSError *error) {
            
        }];
        
        
        
        
    } failure:^(NSError *error) {
    }];
    
}


+(void)doneFirstTimeWithView:(UIView *)view {
    
    [hud hide:YES];
    [alertView close];
    
    alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                dialogTitle:SZLocal(@"dialog.title.tip")
                                                             dialogContents:SZLocal(@"dialog.title.Synchronized success!")
                                                              dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        [fatherView removeFromSuperview];
        fatherView = nil;
        [alertView close];
        SZTipVIew *tipView =  [SZTipVIew loadSZTipVIew];
        tipView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        tipView.confirmActBlock = ^{
            
        };
        [view addSubview:tipView];
    };
    [alertView show];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SZNotificationUpdateBadgeViewCount object:self userInfo:nil];
    
}

+(void)localloginWithView:(UIView *)view {
    
    SZTipVIew *tipView =  [SZTipVIew loadSZTipVIew];
    tipView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    tipView.confirmActBlock = ^{
        
    };
    [view addSubview:tipView];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SZNotificationUpdateBadgeViewCount object:self userInfo:nil];
    
}

@end
