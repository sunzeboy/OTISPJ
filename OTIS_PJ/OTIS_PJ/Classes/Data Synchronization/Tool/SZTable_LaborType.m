//
//  SZTable_LaborType.m
//  OTIS_PJ
//
//  Created by sunze on 16/6/15.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_LaborType.h"
#import "TablesAndFields.h"

@implementation SZTable_LaborType

+(void)initialize
{
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
       
        
    }];
    
}
+(void)storagWithLaborTypeResponse:(NSArray *)Labors{
    
    if (Labors.count == 0) return;
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        BOOL ret = [db executeUpdateWithFormat:@"DELETE from t_LaborType;"];
        if (ret) {
            SZLog(@"t_LaborType清除数据成功！！！");
        }else{
            SZLog(@"t_LaborType清除数据失败！！！");
        }
        
        NSInteger cal = Labors.count%kNumberOfEachDeposit;
        NSInteger frequency = Labors.count/kNumberOfEachDeposit;
        
        NSMutableString *sql = [NSMutableString stringWithFormat:@"%@", @"INSERT INTO t_LaborType (LaborTypeID, LaborType, LaborName,ProductiveType,RelationID,EffectiveDate,ExpiryDate,IsSpecialLabor) VALUES"];
        
        for (NSInteger i =kNumberOfEachDeposit*frequency; i<kNumberOfEachDeposit*frequency +cal; i++) {
            SZLabor *labor= Labors[i];
            NSString *strSqlSuffix = [NSString stringWithFormat:@"(%d,'%@','%@',%d,%d,'%@','%@',%d),",
                                      labor.LaborTypeID,
                                      labor.LaborType,
                                      labor.LaborName,
                                      labor.ProductiveType,
                                      labor.RelationID,
                                      labor.EffectiveDate,
                                      labor.ExpiryDate,
                                      labor.IsSpecialLabor];
            [sql appendString:strSqlSuffix];
        }
        
        [sql deleteCharactersInRange:NSMakeRange([sql length]-1, 1)];
        BOOL a = [db executeUpdate:sql];
        if (!a) {
            NSLog(@"错误：插入t_LaborType失败");
        }
        
    }];
    
}


/**
 *  统计全部生产性工时列表
 */
+(NSArray *)quaryProductive{
    
    NSMutableArray *arrayData = [NSMutableArray array];
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT LaborTypeID,LaborType,LaborName\
                            FROM t_LaborType \
                            WHERE ProductiveType=1 AND RelationID=LaborTypeID AND LaborTypeID>2;"];
        while ([set next]) {
            SZLabor *labor = [[SZLabor alloc] init];
            labor.LaborTypeID = [set intForColumn:@"LaborTypeID"];
            labor.LaborType = [set stringForColumn:@"LaborType"];
            labor.LaborName = [set stringForColumn:@"LaborName"];

            [arrayData  addObject:labor];
            
        }
        
    }];
    
    return [NSArray arrayWithArray:arrayData];
}

/**
 *  统计全部生产性工时列表
 */
+(NSArray *)quaryNonProductive{
    
    NSMutableArray *arrayData = [NSMutableArray array];
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT LaborTypeID,LaborType,LaborName\
                            FROM t_LaborType \
                            WHERE ProductiveType=0 AND RelationID=LaborTypeID AND LaborTypeID>2;"];
        while ([set next]) {
            SZLabor *labor = [[SZLabor alloc] init];
            labor.LaborTypeID = [set intForColumn:@"LaborTypeID"];
            labor.LaborType = [set stringForColumn:@"LaborType"];
            labor.LaborName = [set stringForColumn:@"LaborName"];
            
            [arrayData  addObject:labor];
            
        }
        
    }];
    
    return [NSArray arrayWithArray:arrayData];
}
/**
 *  根据LaborTypeID查找SZLabor
 */
+(SZLabor *)quaryLaborWithLaborTypeID:(int)laborTypeID{
    
    SZLabor *labor = [[SZLabor alloc] init];
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT LaborTypeID,LaborType,LaborName,RelationID\
                            FROM t_LaborType \
                            WHERE  RelationID=LaborTypeID AND LaborTypeID = %d;",laborTypeID];
        while ([set next]) {
            labor.LaborTypeID = [set intForColumn:@"LaborTypeID"];
            labor.LaborType = [set stringForColumn:@"LaborType"];
            labor.LaborName = [set stringForColumn:@"LaborName"];
            labor.RelationID = [set intForColumn:@"RelationID"];

        }
        
    }];
    
    return labor;
}

+(SZLabor *)quaryLutuLaborWithLaborTypeID:(int)laborTypeID{
    SZLabor *labor = [[SZLabor alloc] init];
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT LaborTypeID,LaborType,LaborName,RelationID\
                            FROM t_LaborType \
                            WHERE  RelationID!=LaborTypeID AND LaborTypeID = %d;",laborTypeID];
        while ([set next]) {
            labor.LaborTypeID = [set intForColumn:@"LaborTypeID"];
            labor.LaborType = [set stringForColumn:@"LaborType"];
            labor.LaborName = [set stringForColumn:@"LaborName"];
            labor.RelationID = [set intForColumn:@"RelationID"];
            
        }
        
    }];
    
    return labor;

}


/**
 *  添加工时列表
 */
+(NSArray *)quaryaddWHTypeWithArray:(NSMutableArray *)arr{
    
    NSMutableArray *arrayData = [NSMutableArray array];
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        NSString *sql;
        if (arr.count>0) {
            sql = [NSString stringWithFormat:@"SELECT * \
                   FROM t_LaborType \
                   WHERE ProductiveType=1 AND RelationID=LaborTypeID AND LaborTypeID not in (%@) AND LaborTypeID<21 AND LaborTypeID>2;",[arr componentsJoinedByString:@","]];

        }else{
            sql = @"SELECT * \
                   FROM t_LaborType \
                   WHERE ProductiveType=1 AND RelationID=LaborTypeID AND LaborTypeID<21 AND LaborTypeID>2;";
        }
        FMResultSet *set = [db executeQuery:sql];
            while ([set next]) {
            SZLabor *labor = [[SZLabor alloc] init];
            labor.LaborTypeID = [set intForColumn:@"LaborTypeID"];
            labor.LaborType = [set stringForColumn:@"LaborType"];
            labor.LaborName = [set stringForColumn:@"LaborName"];
            labor.RelationID = [set intForColumn:@"RelationID"];
            labor.item1 = [[SZLaborHoursItem alloc] init];
            labor.item1.LaborTypeId =labor.LaborTypeID;
            labor.item2.LaborTypeId =[SZTable_LaborType quaryLuTuLaborTypeIDWithLaborTypeID:labor.LaborTypeID];

            [arrayData  addObject:labor];
            
        }
        
    }];
    
    return [NSArray arrayWithArray:arrayData];
}

/**
 *  添加工时列表(非本公司)
 */
+(NSArray *)quaryAddWHTypeWithArray:(NSMutableArray *)arr{
    
    NSMutableArray *arrayData = [NSMutableArray array];

    
    [OTISDB inDatabase:^(FMDatabase *db) {
        NSString *sql;
        if (arr.count>0) {
            sql = [NSString stringWithFormat:@"SELECT * \
                   FROM t_LaborType \
                   WHERE ProductiveType=1 AND RelationID=LaborTypeID AND LaborTypeID not in (%@) AND (LaborTypeID=3 OR LaborTypeID=4 OR LaborTypeID=8);",[arr componentsJoinedByString:@","]];
            
        }else{
            sql = @"SELECT * \
            FROM t_LaborType \
            WHERE ProductiveType=1 AND RelationID=LaborTypeID AND (LaborTypeID=3 OR LaborTypeID=4 OR LaborTypeID=8);";
        }
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            SZLabor *labor = [[SZLabor alloc] init];
            labor.LaborTypeID = [set intForColumn:@"LaborTypeID"];
            labor.LaborType = [set stringForColumn:@"LaborType"];
            labor.LaborName = [set stringForColumn:@"LaborName"];
            labor.RelationID = [set intForColumn:@"RelationID"];
            
            [arrayData  addObject:labor];
            
        }
        
    }];
    
    return [NSArray arrayWithArray:arrayData];
}


/**
 *  添加工时列表（中断工作调整原因）
 */
+(NSArray *)quaryaddZhongDuan{
    
    NSMutableArray *arrayData = [NSMutableArray array];

    NSArray *arrayLaborName = @[SZLocal(@"dialog.content.Recall"),
                                SZLocal(@"dialog.content.Repair"),
                                SZLocal(@"dialog.content.Trepair"),
                                SZLocal(@"dialog.content.Compulsory rectification"),
                                SZLocal(@"dialog.content.Annual inspection"),
                                SZLocal(@"dialog.content.Paid vacation"),
                                SZLocal(@"dialog.content.Compassionate leave"),
                                SZLocal(@"dialog.content.Meeting"),
                                SZLocal(@"dialog.content.press for money"),
                                SZLocal(@"dialog.content.Overtime call"),
                                SZLocal(@"dialog.content.Overtime repair"),
                                SZLocal(@"dialog.content.Overtime T repair"),
                                SZLocal(@"dialog.content.New ladder quality rectification"),
                                SZLocal(@"dialog.content.sick leave"),
                                SZLocal(@"dialog.content.Train"),
                                SZLocal(@"dialog.content.Material feeding"),
                                SZLocal(@"dialog.content.Be on duty"),
                                SZLocal(@"dialog.content.Other production hours"),
                                SZLocal(@"dialog.content.Other non productive hours")];
    
//    NSArray *arrayLaborName = @[@"召修",@"修理",@"T修理",@"强制整改",@"年检／陪检",@"有薪假期",@"事假",@"会议",@"催款",@"加班召修",@"加班修理",@"加班T修理",@"新梯质量整改",@"病假",@"培训",@"领料送料",@"值班",@"其它生产工时",@"其它非生产工时"];
    NSArray *arrayLaborType = @[@"CB",@"R",@"T",@"MC",@"AE",@"HL",@"PL",@"MT",@"CP",@"OTCB",@"OTR",@"OT",@"NIS fix",@"SL",@"TR",@"AD",@"SB",@"OPH",@"ONPH"];
    
    for (int i=0; i<arrayLaborName.count; i++) {
        SZLabor *labor = [[SZLabor alloc] init];
        labor.LaborType = arrayLaborType[i];
        labor.LaborName = arrayLaborName[i];
        [arrayData  addObject:labor];
    }
    
//    [OTISDB inDatabase:^(FMDatabase *db) {
//        NSString *sql;
//       
//        sql = @"SELECT * \
//        FROM t_LaborType \
//        WHERE  RelationID=LaborTypeID AND LaborTypeID<21 AND LaborTypeID>2;";
//
//        FMResultSet *set = [db executeQuery:sql];
//        while ([set next]) {
//            SZLabor *labor = [[SZLabor alloc] init];
//            labor.LaborTypeID = [set intForColumn:@"LaborTypeID"];
//            labor.LaborType = [set stringForColumn:@"LaborType"];
//            labor.LaborName = [set stringForColumn:@"LaborName"];
//            labor.RelationID = [set intForColumn:@"RelationID"];
//            [arrayData  addObject:labor];
//
//        }
//        
//    }];
    
    return [NSArray arrayWithArray:arrayData];
}


/**
 *  查询路途工时项是否存在
 */
+(BOOL)quaryIsLutuWithRelationID:(int)relationID{
    
    
    __block BOOL ret = NO;
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT *\
                            FROM t_LaborType \
                            WHERE  RelationID!=LaborTypeID AND RelationID= %d;",relationID];
        while ([set next]) {
            ret = YES;
            
        }
        
    }];
    
    return ret;
}


/**
 *  查询路途工时项是否存在
 */
+(NSString *)quaryLaborNameWithLaborTypeID:(int)laborTypeID{
    
    if (!laborTypeID) {
        return @"";
    }
   __block NSString * laborName = @"";
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT LaborName\
                            FROM t_LaborType \
                            WHERE  LaborTypeID= %d;",laborTypeID];
        while ([set next]) {
            if ([set stringForColumn:@"LaborName"]) {
                laborName = [set stringForColumn:@"LaborName"];
            }
        }
        
    }];
    
    return laborName;
}

/**
 *  查询LuTuLaborTypeID
 */
+(int)quaryLuTuLaborTypeIDWithLaborTypeID:(int)laborTypeID {
    
    
    __block int relationID = 0;
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT LaborTypeID\
                            FROM t_LaborType \
                            WHERE  RelationID!=LaborTypeID AND RelationID= %d;",laborTypeID];
        while ([set next]) {
            relationID = [set intForColumn:@"LaborTypeID"];
        }
        
    }];
    
    return relationID;
}


+(int)quaryOtherLaborTypeIDWithLaborTypeID:(int)laborTypeID {
    
    
    __block int relationID = 0;
    __block int otherLaborTypeID = 0;

    [OTISDB inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQueryWithFormat:@"SELECT RelationID\
                            FROM t_LaborType \
                            WHERE  LaborTypeID = %d;",laborTypeID];
        while ([set next]) {
            relationID = [set intForColumn:@"RelationID"];
            FMResultSet *set2 = [db executeQueryWithFormat:@"SELECT LaborTypeID\
                                FROM t_LaborType \
                                WHERE  RelationID = %d AND LaborTypeID != %d ;",relationID,laborTypeID];
            while ([set2 next]) {
                otherLaborTypeID = [set2 intForColumn:@"LaborTypeID"];

            }
        }
        
    }];
    
    return otherLaborTypeID;
}


@end
