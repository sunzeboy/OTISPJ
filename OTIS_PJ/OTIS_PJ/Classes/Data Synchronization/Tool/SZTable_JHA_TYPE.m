//
//  SZTable_JHA_TYPE.m
//  OTIS_PJ
//
//  Created by sunze on 16/5/19.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_JHA_TYPE.h"
#import "TablesAndFields.h"

#import "SZJHATitleItem.h"

@implementation SZTable_JHA_TYPE


+(void)storaget_JHA_TYPE
{

    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_JHA_TYPE (JhaTypeId, Name, CardType) VALUES (1, '机房', 0),(2, '轿顶和井道', 0),(3, '底坑', 0),(1, '扶梯上机舱', 4),(1, '扶梯上机舱', 5),(1, '扶梯上机舱', 6),(1, '扶梯上机舱', 20),(1, '扶梯上机舱', 21),(1, '扶梯上机舱', 22),(1, '扶梯上机舱', 33),(2, '扶梯倾斜段', 4),(3, '扶梯倾斜段', 5),(2, '扶梯倾斜段', 6),(2, '扶梯倾斜段', 20),(2, '扶梯倾斜段', 21),(2, '扶梯倾斜段', 22),(2, '扶梯倾斜段', 33),(3, '扶梯下机舱', 4),(3, '扶梯下机舱', 5),(3, '扶梯下机舱', 6),(3, '扶梯下机舱', 20),(3, '扶梯下机舱', 21),(3, '扶梯下机舱', 22),(3, '扶梯下机舱', 33);"];
        if (ret) {
            SZLog(@"t_JHA_TYPE插入数据成功！！！");
        }else{
            SZLog(@"t_JHA_TYPE插入数据失败！！！");
        }
        
    }];
    
}


@end
