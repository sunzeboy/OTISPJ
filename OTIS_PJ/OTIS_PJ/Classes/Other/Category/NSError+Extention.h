//
//  NSError+Extention.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/26.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Extention)

+(instancetype)errorWithUserInfo:(NSString *)desc;

@end
