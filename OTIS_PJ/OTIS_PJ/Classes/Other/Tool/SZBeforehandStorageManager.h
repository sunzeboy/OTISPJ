//
//  SZBeforehandStorageManager.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/19.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZBeforehandStorageManager : NSObject


/**
 *  预先存储一些JHA信息(当应用程序第一次安装或版本升级的时候才执行)
 */
+(void)beforehandStorage;

@end
