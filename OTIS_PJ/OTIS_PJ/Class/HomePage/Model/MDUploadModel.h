//
//  MDUploadModel.h
//  OTIS_PJ
//
//  Created by 杜亚伟 on 2017/3/9.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDUploadModel : NSObject

@property (nonatomic,copy) NSString* itemCode;

@property (nonatomic,copy) NSString* itemReson;

@property (nonatomic,assign) NSInteger itemState;

@property (nonatomic,assign) NSInteger itemStateAuto;


@end
