//
//  SZhelp.h
//  OTIS_PJ
//
//  Created by jQ on 16/5/11.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZHelp : NSObject
// 项目图标
@property (nonatomic,copy) NSString *iconImage;
// 项目名
@property (nonatomic,copy) NSString *iconName;
// sectionNO
@property (nonatomic,copy) NSString *titleNo;
//
@property (nonatomic,copy) NSString *gotoImage;
- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)helpWithDic:(NSDictionary *)dic;
+ (NSArray *)helpList;
@end
