//
//  MDMainTainVM.h
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/15.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDMainTainVM : NSObject

@property(nonatomic,strong) NSMutableArray* dataArray;

-(void)setTableRowHeight:(NSMutableArray*)dataArray;
@end
