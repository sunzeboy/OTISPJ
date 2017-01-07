//
//  SZSynchronizationView.h
//  OTIS_PJ
//
//  Created by sunze on 16/7/4.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "JCRBlurView.h"


@interface SZSynchronizationView : JCRBlurView

@property (nonatomic , strong) NSMutableArray *dateArray;

-(void)SynchronizData;


@end
