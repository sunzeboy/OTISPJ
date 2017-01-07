//
//  SZCheckLookIModel.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/21.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZCheckLookModel : NSObject

@property (nonatomic , copy) NSString *unitNo;

@property (nonatomic , copy) NSString *contactNo;

@property (nonatomic , copy) NSString *feishengchanxing;

@property (nonatomic , strong) NSMutableArray *laborHours;

//--------------附加
@property (nonatomic , assign) CGFloat  cellHeight;

@property (nonatomic , assign) int  ScheduleID;

@property (nonatomic , copy) NSString *createDate;
@property (nonatomic , copy) NSString *GenerateDate;

@property (nonatomic , assign) int  LaborTypeID;

@property (nonatomic , assign) float  gongshi;



+(instancetype)modelWithUnitNo:(NSString *)unitNo andLaborHours:(NSMutableArray *)laborHours;

@end
