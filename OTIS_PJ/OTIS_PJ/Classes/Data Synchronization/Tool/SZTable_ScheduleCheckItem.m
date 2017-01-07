//
//  SZTable_MaintenanceItems.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/29.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_ScheduleCheckItem.h"
#import "TablesAndFields.h"
#import "SZScheduleCheckItem.h"

@implementation SZTable_ScheduleCheckItem




///**
// *  存储到MaintenanceItemsDB
// *
// *  @param params
// */
//+(void)storageScheduleCheckItems:(NSArray *)scheduleCheckItems{
//    [OTISDB inTransaction:^(FMDatabase *db,BOOL *rollback ) {
//        
//        /**
//         *  先删除再存储
//         */
//        [db executeUpdateWithFormat:@"delete from t_ScheduleCheckItem;"];
//        
//        SZLog(@"计划保养项存储中。。。%@",[NSThread currentThread]);
//        
//        
//        for (SZScheduleCheckItem *item in scheduleCheckItems) {
//          
//            
//            BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_ScheduleCheckItem(ItemCode,\
//                        CardType,\
//                        Times) VALUES (\
//                        %@,\
//                        %d,\
//                        %d);",
//                        item.ItemCode,
//                        item.CardType,
//                        item.Times];
////            if (ret) {
////                SZLog(@"计划保养项表插入数据成功！！！");
////            }else{
////                SZLog(@"计划保养项表插入数据失败！！！");
////            }
//            
//            
//            
//        }
//        
//        
//        
//        
//        
//        
//        
//        SZLog(@"计划保养项存储成功！%@",[NSThread currentThread]);
//        
//    }];
//
//
//}



/**
 *  存储到MaintenanceItemsDB
 *
 *  @param params
 */
+(void)storageScheduleCheckItems:(NSArray *)scheduleCheckItems{
    
    if (scheduleCheckItems.count == 0)return;

    [OTISDB inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        /**
         *  先删除再存储
         */
        [db executeUpdateWithFormat:@"delete from t_ScheduleCheckItem;"];
        
        SZLog(@"计划保养项存储中。。。%@",[NSThread currentThread]);
        
        
        NSInteger cal = scheduleCheckItems.count%kNumberOfEachDeposit;
        NSInteger frequency = scheduleCheckItems.count/kNumberOfEachDeposit;
        
        for (NSInteger fre = 0; fre<frequency; fre++){
            
            NSMutableString *sql = [NSMutableString stringWithFormat:@"%@", @"INSERT INTO t_ScheduleCheckItem (ItemCode,CardType,Times) VALUES "];
            
            for (NSInteger i =kNumberOfEachDeposit*fre; i<kNumberOfEachDeposit*(fre +1); i++) {
                SZScheduleCheckItem *item = scheduleCheckItems[i];
                NSString *itemCode = item.ItemCode;
                int cardType = item.CardType;
                int Times = item.Times;
                NSString *strSqlSuffix = [NSString stringWithFormat:@"('%@',%d,%d),",itemCode,cardType,Times];
                [sql appendString:strSqlSuffix];
                
            }
            

            [sql deleteCharactersInRange:NSMakeRange([sql length]-1, 1)];
            BOOL a = [db executeUpdate:sql];
            if (!a) {
                NSLog(@"错误：t_ScheduleCheckItem 插入失败1");
            }

            
        }
        
        NSMutableString *sql = [NSMutableString stringWithFormat:@"%@", @"INSERT INTO t_ScheduleCheckItem (ItemCode,CardType,Times) VALUES "];

        for (NSInteger i =kNumberOfEachDeposit*frequency; i<kNumberOfEachDeposit*frequency +cal; i++) {
            SZScheduleCheckItem *item = scheduleCheckItems[i];
            NSString *itemCode = item.ItemCode;
            int cardType = item.CardType;
            int Times = item.Times;
            NSString *strSqlSuffix = [NSString stringWithFormat:@"('%@',%d,%d),",itemCode,cardType,Times];
            [sql appendString:strSqlSuffix];
            
        }
        
        [sql deleteCharactersInRange:NSMakeRange([sql length]-1, 1)];
        BOOL a = [db executeUpdate:sql];
        if (!a) {
            NSLog(@"错误：t_ScheduleCheckItem 插入失败2");
        }

        
        
        }];
    
    
}




@end
