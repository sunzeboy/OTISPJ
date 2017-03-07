//
//  MDSVTModel.m
//  OTIS_PJ
//
//  Created by 杜亚伟 on 2017/2/28.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

#import "MDSVTModel.h"
#import "MJExtension.h"
@implementation MDSVTModel


@end


@implementation MDSVTModelDetail


@end


@implementation MDSVTLastModel

+(NSDictionary *)mj_objectClassInArray{
    return @{
             @"DriveEvents" : @"MDSVTEventModel",
             @"SavedDriveEvents" : @"MDSVTEventModel",// @"statuses" : [MJStatus class],
             };
}
@end




@implementation MDSVTEventModel



@end


@implementation MDSVTErrorData



@end
