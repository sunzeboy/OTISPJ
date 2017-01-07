//
//  SZTable_SchedulesCards.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/28.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_CheckItem.h"
#import "TablesAndFields.h"

@implementation SZTable_CheckItem


#pragma mark - 计划卡表

///**
// *  存储到ScheduleCardsDB
// *
// *  @param params
// */
//+(void)storageScheduleCards:(NSArray *)cards
//{
//    
//    
//    [OTISDB inDatabase:^(FMDatabase *db) {
//        
//        SZLog(@"保养项存储中。。。%@",[NSThread currentThread]);
//        /**
//         *  先删除再存储
//         */
//        [db executeUpdateWithFormat:@"delete from t_CheckItem;"];
//        
//        for (SZCard *card in cards) {
//            
//            BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_CheckItem(ItemCode,\
//                        CardType,\
//                        ItemName,\
//                        Description,\
//                        Type,\
//                        IsStandard) VALUES (\
//                        %@,\
//                        %d,\
//                        %@,\
//                        %@,\
//                        %d,\
//                        %d);",
//                        card.ItemCode,
//                        card.CardType,
//                        card.ItemName,
//                        card.Description,
//                        card.Type,
//                        card.IsStandard];
////                    if (ret) {
////                        SZLog(@"保养项表插入数据成功！！！");
////                    }else{
////                        SZLog(@"保养项表插入数据失败！！！");
////                    }
//            
//            
//
//        }
//        
//        SZLog(@"保养项存储成功！%@",[NSThread currentThread]);
//        
//    }];
//    
//}



/**
 *  存储到ScheduleCardsDB
 *
 *  @param params
 */
+(void)storageScheduleCards:(NSArray *)cards
{
    if (cards.count == 0)return;

    
    [OTISDB inDatabase:^(FMDatabase *db) {
        /**
         *  先删除再存储
         */
        [db executeUpdateWithFormat:@"delete from t_CheckItem;"];
        
        SZLog(@"保养项存储中。。。%@",[NSThread currentThread]);
        


        
        NSInteger cal = cards.count%kNumberOfEachDeposit;
        NSInteger frequency = cards.count/kNumberOfEachDeposit;


        for (NSInteger fre = 0; fre<frequency+1; fre++) {
            
            NSMutableString *sql = [NSMutableString stringWithFormat:@"%@", @"INSERT INTO t_CheckItem (ItemCode,CardType,ItemName,Description,Type,IsStandard) VALUES "];

            if (cal==0) {
                for (NSInteger i =kNumberOfEachDeposit*fre; i<kNumberOfEachDeposit*(fre +1); i++) {
                    SZCard *card = cards[i];
                    NSString *itemCode = card.ItemCode;
                    int cardType = card.CardType;
                    NSString *itemName = card.ItemName;
                    NSString *Desc = card.Description;
                    int type = card.Type;
                    int isStandard = card.IsStandard;
                    NSString *strSqlSuffix = [NSString stringWithFormat:@"('%@',%d,'%@','%@',%d,%d),",itemCode,cardType,itemName,Desc,type,isStandard];
                    [sql appendString:strSqlSuffix];
                    
                }

                [sql deleteCharactersInRange:NSMakeRange([sql length]-1, 1)];
                BOOL a = [db executeUpdate:sql];
                if (!a) {
                    NSLog(@"错误：初始化t_CheckItem插入失败1");
                }
                
            }else{
            
                if (fre == frequency) {
                    for (NSInteger i =kNumberOfEachDeposit*fre; i<kNumberOfEachDeposit*fre +cal; i++) {
                        SZCard *card = cards[i];
                        NSString *itemCode = card.ItemCode;
                        int cardType = card.CardType;
                        NSString *itemName = card.ItemName;
                        NSString *Desc = card.Description;
                        int type = card.Type;
                        int isStandard = card.IsStandard;
                        NSString *strSqlSuffix = [NSString stringWithFormat:@"('%@',%d,'%@','%@',%d,%d),",itemCode,cardType,itemName,Desc,type,isStandard];
                        [sql appendString:strSqlSuffix];
                       
                    }
                    [sql deleteCharactersInRange:NSMakeRange([sql length]-1, 1)];
                    BOOL a = [db executeUpdate:sql];
                    if (!a) {
                        NSLog(@"错误：初始化t_CheckItem插入失败2");
                    }

                    
                }else{
                
                    for (NSInteger i =kNumberOfEachDeposit*fre; i<kNumberOfEachDeposit*(fre +1); i++) {
                        SZCard *card = cards[i];
                        NSString *itemCode = card.ItemCode;
                        int cardType = card.CardType;
                        NSString *itemName = card.ItemName;
                        NSString *Desc = card.Description;
                        int type = card.Type;
                        int isStandard = card.IsStandard;
                        NSString *strSqlSuffix = [NSString stringWithFormat:@"('%@',%d,'%@','%@',%d,%d),",itemCode,cardType,itemName,Desc,type,isStandard];
                        [sql appendString:strSqlSuffix];
                        
                    }
                    [sql deleteCharactersInRange:NSMakeRange([sql length]-1, 1)];
                    BOOL a = [db executeUpdate:sql];
                    if (!a) {
                        NSLog(@"错误：初始化t_CheckItem插入失败3");
                    }

                
                }

            
            }
            
            
            
        }

        [db executeUpdateWithFormat:@"UPDATE t_CheckItem SET IsSafetyItem=0 ;"];
        
        
        [db executeUpdateWithFormat:@"UPDATE t_CheckItem SET IsSafetyItem=1 \
         WHERE EXISTS ( SELECT 1 FROM t_SafetyItem WHERE t_CheckItem.ItemCode=t_SafetyItem.ItemCode);"];

        
        SZLog(@"保养项存储成功！%@",[NSThread currentThread]);
        
    }];
    
}


+(void)updateScheduleCards:(NSArray *)cards{

    [OTISDB inDatabase:^(FMDatabase *db) {
        
        NSString *sqlDelet = [NSString stringWithFormat:@"DELETE  FROM t_SafetyItem ;"];
        BOOL ret1 = [db executeUpdate:sqlDelet];
        if (ret1) {
            SZLog(@"删除t_SafetyItem成功");
        }else{
            SZLog(@"错误：删除t_SafetyItem失败");
        }
        
        
        NSInteger cal = cards.count%kNumberOfEachDeposit;
        NSInteger frequency = cards.count/kNumberOfEachDeposit;
        
        for (NSInteger fre = 0; fre<frequency; fre++){
            
            NSMutableString *sql = [NSMutableString stringWithFormat:@"%@", @"INSERT INTO t_SafetyItem (ItemCode) VALUES "];
            
            for (NSInteger i =kNumberOfEachDeposit*fre; i<kNumberOfEachDeposit*(fre +1); i++) {
                SZCard *card = cards[i];
                NSString *strSqlSuffix = [NSString stringWithFormat:@"('%@'),",card.ItemCode];
                [sql appendString:strSqlSuffix];
                
            }
            
            
            [sql deleteCharactersInRange:NSMakeRange([sql length]-1, 1)];
            BOOL a = [db executeUpdate:sql];
            if (!a) {
                NSLog(@"错误：插入t_SafetyItem失败1");
            }
            
            
        }
        
        NSMutableString *sql = [NSMutableString stringWithFormat:@"%@", @"INSERT INTO t_SafetyItem (ItemCode) VALUES "];
        
        for (NSInteger i =kNumberOfEachDeposit*frequency; i<kNumberOfEachDeposit*frequency +cal; i++) {
            SZCard *card = cards[i];
            NSString *strSqlSuffix = [NSString stringWithFormat:@"('%@'),",card.ItemCode];
            [sql appendString:strSqlSuffix];
        }
        
        [sql deleteCharactersInRange:NSMakeRange([sql length]-1, 1)];
        BOOL a = [db executeUpdate:sql];
        if (!a) {
            NSLog(@"错误：插入t_SafetyItem失败2");
        }

        
        
        
        [db executeUpdateWithFormat:@"UPDATE t_CheckItem SET IsSafetyItem=0 ;"];
        
        
        [db executeUpdateWithFormat:@"UPDATE t_CheckItem SET IsSafetyItem=1 \
             WHERE EXISTS ( SELECT 1 FROM t_SafetyItem WHERE t_CheckItem.ItemCode=t_SafetyItem.ItemCode);"];

        
        
    }];


}


@end
