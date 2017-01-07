
//

//  SZDownloadManger.m

//  OTIS_PJ

//

//  Created by sunze on 16/4/22.

//  Copyright © 2016年 sunzeboy. All rights reserved.

//



#import "SZDownloadManger.h"

#import "SZDownload_UnitsRequest.h"

#import "SZDownload_V4Request.h"

#import "SZDownload_CardsRequest.h"

#import "SZDownload_UnfinishedItemsRequest.h"

#import "SZDownloadTool.h"



#import "SZDownload_ReservedSubjectRequest.h"

#import "SZDownload_ReservedSubjectResponse.h"

#import "SZYearCheckRequest.h"
#import "SZYearCheckResponse.h"
#import "SZSafetyItemRequest.h"
#import "SZSafetyItemResponse.h"


#import "TablesAndFields.h"

#import "SZLaborTypeRequest.h"

#import "SZSynchronizationView.h"
#import <MBProgressHUD.h>

typedef NS_ENUM(NSInteger,OTISResultType){
    
    OTISResultTypeSuccess      = 0,//0：年度保养，可以再任何次数保养但每年仅限一次
    
    OTISResultTypeFailure   = 1,//1：一年
    
};



@implementation SZDownloadManger






static MBProgressHUD *hud;
static SZSynchronizationView *fatherView;

+(void)startDownloadWithView:(UIView *)view Success:(void(^)())success failure:(void(^)(NSError *error))failure
{
    SZLog(@"view:%@",NSStringFromCGRect(view.frame));
    hud =[MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = @"数据同步中...";
    hud.mode = MBProgressHUDModeIndeterminate;
    
    fatherView = [[SZSynchronizationView alloc] initWithFrame:CGRectMake(10, 20, view.frame.size.width-2*10, view.frame.size.height-2*20)];
    fatherView.center = view.center;
    [view addSubview:fatherView];
    [view insertSubview:hud aboveSubview:fatherView];
    SZLog(@"fatherView:%@",NSStringFromCGRect(fatherView.frame));

    
    __block BOOL ret1 = NO;
    __block BOOL ret2 = NO;
    __block BOOL ret3 = NO;
    __block BOOL ret4 = NO;
    __block BOOL ret5 = NO;
    __block BOOL ret6 = NO;
    __block BOOL ret7 = NO;
    __block BOOL ret8 = NO;
    
    [SZDownloadTool downloadUnitsWithRequest:[SZDownload_UnitsRequest unitsRequest] success:^(NSString *str) {
        [self synchronizData:str fatherView:fatherView];
        ret1 = YES;
        if (ret1&&ret2&&ret3&&ret4&&ret5&&ret6) {
            [self done];
            success();
        }
    } failure:^(NSError *error) {
        
    }];
    
    [SZDownloadTool downloadSchedulesWithRequest:[SZDownload_V4Request v4Request] success:^(NSString *str) {
        [self synchronizData:str fatherView:fatherView];
        ret2 = YES;
        if (ret1&&ret2&&ret3&&ret4&&ret5&&ret6) {
            [self done];
            success();
        }
    } failure:^(NSError *error) {
        
    }];
    
    [SZDownloadTool downloadUnfinishedItemsWithRequest:[SZDownload_UnfinishedItemsRequest unfinishedItemsRequest] success:^(NSString *str) {
        [self synchronizData:str fatherView:fatherView];
        ret3 = YES;
        if (ret1&&ret2&&ret3&&ret4&&ret5&&ret6) {
            [self done];
            success();
        }
    } failure:^(NSError *error) {
        
    }];
    
    [SZDownloadTool downloadYearCheckWithRequest:[SZYearCheckRequest yearCheckRequest] success:^(NSString *str) {
        [self synchronizData:str fatherView:fatherView];
        ret4 = YES;
        if (ret1&&ret2&&ret3&&ret4&&ret5&&ret6) {
            [self done];
            success();
        }
    } failure:^(NSError *error) {
        
    }];
    
    [SZDownloadTool downloadSafetyItemWithRequest:[SZSafetyItemRequest safetyItemRequest] success:^(NSString *str) {
        [self synchronizData:str fatherView:fatherView];
        ret5 = YES;
        if (ret1&&ret2&&ret3&&ret4&&ret5&&ret6) {
            [self done];
            success();
        }
    } failure:^(NSError *error) {
        
    }];
    
    [SZDownloadTool downloadLaborTypeWithRequest:[SZLaborTypeRequest laborTypeRequest] success:^(NSString *str) {
        [self synchronizData:str fatherView:fatherView];
        ret6 = YES;
        if (ret1&&ret2&&ret3&&ret4&&ret5&&ret6) {
            [self done];
            success();
        }
    } failure:^(NSError *error) {
        
    }];
    
    [SZDownloadTool downloadScheduleCardsWithRequest:[SZDownload_CardsRequest cardsRequest] success:^(NSString *str) {
        [self synchronizData:str fatherView:fatherView];
        ret7 = YES;
        if (ret1&&ret2&&ret3&&ret4&&ret5&&ret6) {
            [self done];
        }
    } failure:^(NSError *error) {
        
    }];
    
    [SZDownloadTool downloadUnScanedReasonWithRequest:[SZDownload_UnScanedReasonRequest unScanedReasonRequest] success:^(NSString *str) {
        [self synchronizData:str fatherView:fatherView];
        ret8 = YES;
        if (ret1&&ret2&&ret3&&ret4&&ret5&&ret6) {
            [self done];
            success();
        }
    } failure:^(NSError *error) {
        
    }];
    
}

+(void)synchronizData:(NSString *)str fatherView:(SZSynchronizationView *)veiw{
    if (str.length>2) {
        [veiw.dateArray addObject:str];
        [veiw SynchronizData];
    }
    
}

+(void)done{
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    // Looks a bit nicer if we make it square.
    hud.square = YES;
    // Optional label text.
    hud.labelText = @"数据同步完成！";
    [hud hide:YES afterDelay:2];
    
    //    self = nil;
    [fatherView removeFromSuperview];
    
}

@end

