//
//  SZCustomerSignDetail.h
//  OTIS_PJ
//
//  Created by jQ on 16/5/16.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZCustomerSignDetail : NSObject
@property(nonatomic,copy)NSString * serviceAutitude;
@property(nonatomic,copy)NSString * maintenanceQuality;
@property(nonatomic,copy)NSString * customerAbsence;
@property(nonatomic,copy)NSString * customerName;
@property(nonatomic,copy)NSString * sendEmail;
@property(nonatomic,copy)NSString * emailAddress;
@property(nonatomic,copy)UIImage * signatureImage;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)signDetailWithDic:(NSDictionary *)dic;
+ (SZCustomerSignDetail *)signDetail;
@end
