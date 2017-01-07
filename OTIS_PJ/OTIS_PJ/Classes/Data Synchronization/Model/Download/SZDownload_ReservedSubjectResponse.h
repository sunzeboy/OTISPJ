//
//  SZDownload_ReservedSubjectResponse.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/9.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZDownload_ReservedSubjectResponse : NSObject

/**
 * 下载是否成功标志位 0-成功  1-失败
 */
@property (nonatomic , copy) NSString *Result;

/**
 *  工时JSON
 */
@property (nonatomic, strong) NSArray * Labor;

@end
