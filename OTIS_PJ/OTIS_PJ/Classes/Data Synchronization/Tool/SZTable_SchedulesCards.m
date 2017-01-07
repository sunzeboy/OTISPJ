//
//  SZTable_SchedulesCards.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/28.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_SchedulesCards.h"
#import "TablesAndFields.h"

@implementation SZTable_SchedulesCards

+(void)initialize{

    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSString *strCreateScheduleCards = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER PRIMARY KEY autoincrement, %@ INTEGER NOT NULL,%@ INTEGER,%@ TEXT NOT NULL);",t_ScheduleCards,
                                            ItemScheduleId,
                                            Times,
                                            CardType,
                                            ItemCode];
        BOOL ret = [db executeUpdate:strCreateScheduleCards];
        if (ret) {
            SZLog(@"计划卡表创建成功！！！");
        }else{
            SZLog(@"计划卡表创建失败！！！");
        }

    }];
}

#pragma mark - 计划卡表

/**
 *  存储到ScheduleCardsDB
 *
 *  @param params
 */
+(void)storageScheduleCards:(NSArray *)cards
{
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        SZLog(@"保养卡存储中。。。%@",[NSThread currentThread]);
        
        for (SZCard *card in cards) {
            
            /**
             *  如果有一样的UnitNo，先删除再存储
             */
            [db executeUpdateWithFormat:@"delete from t_ScheduleCards WHERE ItemCode = %@;",card.ItemCode];
            
            BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_ScheduleCards(Times,CardType, ItemCode) VALUES (\
                        %d,\
                        %ld,\
                        %@);",
                        9,
                        card.CardType,
                        card.ItemCode];
            //        if (ret) {
            //            SZLog(@"计划卡表插入数据成功！！！");
            //        }else{
            //            SZLog(@"计划卡表插入数据失败！！！");
            //        }
        }
        
        SZLog(@"保养卡存储成功！%@",[NSThread currentThread]);
        
    }];
    
}


/**
 *  根据请求参数去沙盒中加载缓存的ScheduleCards数据
 *
 *  @param params 请求参数
 */
+(NSArray *)readScheduleCardsWithParams:(NSDictionary *)params{
    
    return nil;
    
    
}


@end
