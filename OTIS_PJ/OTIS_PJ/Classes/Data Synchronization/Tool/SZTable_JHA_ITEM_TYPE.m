//
//  SZTable_JHA_ITEM_TYPE.m
//  OTIS_PJ
//
//  Created by sunze on 16/5/19.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_JHA_ITEM_TYPE.h"
#import "TablesAndFields.h"
#import "SZJHATitleItem.h"

@implementation SZTable_JHA_ITEM_TYPE

+(void)initialize
{
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        NSString *strCreate = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_JHA_ITEM_TYPE (JhaItemType INTEGER , Name TEXT, JhaTypeId INTEGER);"];
        
        [db executeUpdate:strCreate];
        
    }];
    
}



+(void)storaget_JHA_ITEM_TYPE
{
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_JHA_ITEM_TYPE (JhaItemType, Name, JhaTypeId) VALUES (1,'可能出现下列危险',1),(2,'可能出现的FPA项目',1),(3,'采取的控制方法',1),(4,'可能出现下列危险',2),(5,'可能出现的FPA项目',2),(6,'采取的控制方法',2),(7,'可能出现下列危险',3),(8,'可能出现的FPA项目',3),(9,'采取的控制方法',3);"];
        if (ret) {
            SZLog(@"t_JHA_ITEM_TYPE插入数据成功！！！");
        }else{
            SZLog(@"t_JHA_ITEM_TYPE插入数据失败！！！");
        }
        
    }];
    
}




//+(SZJHATitleItem *)quaryJhaItemTypeWithJHATitleItem:(SZJHATitleItem *)titleItem{
//
//    SZJHATitleItem *jhaItem = [[SZJHATitleItem alloc] init];
//    
//    [OTISDB inDatabase:^(FMDatabase *db) {
//        FMResultSet *set = [db executeQueryWithFormat:@"SELECT *\
//                            FROM   t_JHA_ITEM_TYPE \
//                            WHERE  CardType = %ld AND JhaTypeId = 1;",titleItem.JhaTypeId1];
//        while ([set next]) {
//            
//            jhaItem.title1 = [set stringForColumn:@"Name"];
//            jhaItem.JhaTypeId1 = [set intForColumn:@"JhaTypeId"];
//            
//        }
//        
//    }];
//    [OTISDB inDatabase:^(FMDatabase *db) {
//        FMResultSet *set = [db executeQueryWithFormat:@"SELECT *\
//                            FROM   t_JHA_ITEM_TYPE \
//                            WHERE  CardType = %ld AND JhaTypeId = 2;",(long)cardType];
//        while ([set next]) {
//            
//            jhaItem.title2 = [set stringForColumn:@"Name"];
//            jhaItem.JhaTypeId2 = [set intForColumn:@"JhaTypeId"];
//            
//        }
//        
//    }];
//    [OTISDB inDatabase:^(FMDatabase *db) {
//        FMResultSet *set = [db executeQueryWithFormat:@"SELECT *\
//                            FROM   t_JHA_ITEM_TYPE \
//                            WHERE  CardType = %ld AND JhaTypeId = 3;",(long)cardType];
//        while ([set next]) {
//            
//            jhaItem.title3 = [set stringForColumn:@"Name"];
//            jhaItem.JhaTypeId3 = [set intForColumn:@"JhaTypeId"];
//            
//        }
//        
//    }];
//    
//    return jhaItem;
//
//}


@end
