//
//  MDSynchronousVC.h
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/10.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import "MDBaseVC.h"
@class SZFinalMaintenanceUnitDetialItem;
@interface MDSynchronousVC : MDBaseVC


-(instancetype)initWithLiftModel:(SZFinalMaintenanceUnitDetialItem*)model;

@property(nonatomic,assign) BOOL isAppJump;

@property (nonatomic,copy) NSString* appString;

@property(nonatomic,strong) void(^appBackBlock)();

@end
