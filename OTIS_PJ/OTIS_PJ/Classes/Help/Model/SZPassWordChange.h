//
//  SZPassWordChange.h
//  OTIS_PJ
//
//  Created by jQ on 16/5/12.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZPassWordChange : NSObject
// 当前密码
@property (nonatomic,copy) NSString *currentPassWord;
// 新密码
@property (nonatomic,copy) NSString *imputNewPassWord;
// 再次输入新密码
@property (nonatomic,copy) NSString *reImputNewPassWord;
- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)changePassWordWithDic:(NSDictionary *)dic;
+ (SZPassWordChange *)changePassWord;
@end
