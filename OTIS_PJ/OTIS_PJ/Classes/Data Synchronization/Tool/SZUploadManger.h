//
//  SZUploadManger.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/30.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZUploadManger : NSObject

/**
 *  上传
 */
+(void)startUploadWithView:(UIView *)view success:(void(^)())success;
/**
 *  上传及下载
 */
+(void)startUploadAndDownloadWithView:(UIView *)view;
/**
 *   上传及下载(登录成功后)
 */
+(void)startUploadAndDownloadFirstTimeWithView:(UIView *)view;

/**
 *  本地登录
 */
+(void)localloginWithView:(UIView *)view ;


+(void)fauilTipView:(UIView *)view;

+(void)uploadFauilTipView:(UIView *)view;

@end
