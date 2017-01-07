//
//  SZUserInfo.h
//  OTIS_PJ
//
//  Created by sunze on 16/5/4.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZUserInfo : NSObject


@property (nonatomic , copy) NSString *EmployeeID;

@property (nonatomic , copy) NSString *Name;

@property (nonatomic , copy) NSString *Phone;

@property (nonatomic , copy) NSString *UserNo;

@property (nonatomic , copy) NSString *Password;

@property (nonatomic , copy) NSString *BeltLevel;

@property (nonatomic , strong) NSArray *Routes;

@property (nonatomic , strong) NSArray *Supervisors;

@property (nonatomic , assign) BOOL IsLocked;

@property (nonatomic , assign) long LastLoginDate;

@property (nonatomic , assign) long LastConnectDate;


@end
