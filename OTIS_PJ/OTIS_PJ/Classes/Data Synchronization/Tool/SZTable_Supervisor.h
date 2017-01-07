//
//  SZTable_Supervisor.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/13.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZTable_Supervisor : NSObject

/**
 *  获取电梯版本号
 */
+(NSString *)unitUpdateVer;


/**
 *  存储电梯版本号到Supervisor
 *
 *  @param dic 参数
 */
+(void)updateTabSupervisorWithUnitVer:(NSInteger)unitVer;



@end
