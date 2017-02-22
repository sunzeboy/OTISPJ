//
//  MDHalfYearVC.h
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/15.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import "MDBaseVC.h"
@class MDMatainModel;
@interface MDHalfYearVC : MDBaseVC

@property(nonatomic,assign) BOOL isRefresh;
@property(nonatomic,strong) NSMutableArray<MDMatainModel*>* dataArray;
-(instancetype)init;
@end
