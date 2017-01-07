//
//  SZAddWorkingHoursView.h
//  OTIS_PJ
//
//  Created by sunze on 16/7/5.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "JCRBlurView.h"
#import "SZLabor.h"

@interface SZAddWorkingHoursView : JCRBlurView

@property (copy, nonatomic) void (^selectedBlock)(SZLabor *labor) ;

@property (nonatomic, strong) NSMutableArray *selectedTypes;

@property (nonatomic , assign) BOOL zhongduan;

@end
