//
//  SZTable_JHA_ITEM.m
//  OTIS_PJ
//
//  Created by sunze on 16/5/19.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTable_JHA_ITEM.h"
#import "TablesAndFields.h"

@implementation SZTable_JHA_ITEM

+(void)initialize
{
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        NSString *strCreate = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_JHA_ITEM (JhaCodeId INTEGER ,JhaItemType INTEGER , JhaCode TEXT, Name TEXT);"];
        [db executeUpdate:strCreate];
        
    }];
    
}



+(void)storaget_JHA_ITEM
{
    
    
    [OTISDB inDatabase:^(FMDatabase *db) {
        
        BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_JHA_ITEM (JhaCodeId, JhaItemType, JhaCode,Name) VALUES (	1,1, 'B1_001' , '1 挤压、夹') ,(	2,1, 'B1_002' , '2 危险能量') ,(	3,1, 'B1_003' , '3 打、撞击') ,(	4,1, 'B1_004' , '4 绊、滑、落' ) ,(	5,1, 'B1_005' , '5 扭／扭伤') ,(	6,1, 'B1_006' , '6 快口／化学品'  ) ,(	7,2, 'C1_001' , '1 坠落' ) ,(	8,2, 'C1_002' , '2 a进出轿顶'  ) ,(	9,2, 'C1_003' , '2b 进出底坑'  ) ,(	10,2,'C1_004' , '3a 电能') ,(	11,2,'C1_005' , '3b 机械') ,(	12,2,'C1_006' , '4a 短接线' ) ,(	13,2,'C1_007' , '4b 索具') ,(	14,2,'C1_Other','其他'  ) ,(	15,3,'D1_001' , '锁闭／警示'  ) ,(	16,3,'D1_002' , '电安全') ,(	17,3,'D1_003' , '轮护罩') ,(	18,3,'D1_004' , '短接程序' ) ,(	19,3,'D1_005' , '坠落保护' ) ,(	20,3,'D1_006' , '手套'  ) ,(	21,3,'D1_007' , '照明'  ) ,(	22,3,'D1_008' , '爬梯安全' ) ,(	23,3,'D1_009' , '物料处理' ) ,(	24,3,'D1_010' , '电气防护' ) ,(	25,3,'D1_011' , '清洁／清理'  ) ,(	26,3,'D1_Other','其他'  ) ,(	27,4,'B2_001' , '1 挤压、夹') ,(	28,4,'B2_002' , '2 危险能量') ,(	29,4,'B2_003' , '3 打、撞击') ,(	30,4,'B2_004' , '4 绊、滑、落' ) ,(	31,4,'B2_005' , '5 扭／扭伤') ,(	32,4,'B2_006' , '6 快口／化学品'  ) ,(	33,5,'C2_001' , '1 坠落' ) ,(	34,5,'C2_002' , '2a 进出轿顶'  ) ,(	35,5,'C2_003' , '2b 进出底坑'  ) ,(	36,5,'C2_004' , '3a 电能') ,(	37,5,'C2_005' , '3b 机械') ,(	38,5,'C2_006' , '4a 短接线' ) ,(	39,5,'C2_007' , '4b 索具') ,(	40,5,'C2_Other','其他') ,(	41,6,'D2_001' , '锁闭／警示'  ) ,(	42,6,'D2_002' , '轿顶程序') ,(	43,6,'D2_003' , '轮护罩') ,(	44,6,'D2_004' , '短接程序' ) ,(	45,6,'D2_005' , '坠落保护' ) ,(	46,6,'D2_006' , '手套'  ) ,(	47,6,'D2_007' , '照明'  ),(	48,6,'D2_008' , '电安全' ),(	49,6,'D2_009' , '安全帽' ),(	50,6,'D2_010' , '轿顶护栏' ),(	51,6,'D2_011' , '隔离网'  ),(	52,6,'D2_Other'  , '其他'  ),(	53,7,'B3_001' , '1 挤压、夹'),(	54,7,'B3_002' , '2 危险能量'),(	55,7,'B3_003' , '3 打、撞击'),(	56,7,'B3_004' , '4 绊、滑、落' ),(	57,7,'B3_005' , '5 扭／扭伤'),(	58,7,'B3_006' , '6 快口／化学品'  ),(	59,8,'C3_001' , '1 坠落' ),(	60,8,'C3_002' , '2a 进出轿顶'  ),(	61,8,'C3_003' , '2b 进出底坑'  ),(	62,8,'C3_004' , '3a 电能'),(	63,8,'C3_005' , '3b 机械'),(	64,8,'C3_006' , '4a 短接线' ),(	65,8,'C3_007' , '4b 索具'),(	66,8,'C3_Other'  , '其他'  ),(	67,9,'D3_001' , '底坑程序'  ),(	68,9,'D3_002' , '坠落保护'),(	69,9,'D3_003' , '轮护罩'),(	70,9,'D3_004' , '锁闭／警示' ),(	71,9,'D3_005' , '电安全' ),(	72,9,'D3_006' , '手套'  ),(	73,9,'D3_007' , '照明'  ),(	74,9,'D3_008' , '轿厢支撑' ),(	75,9,'D3_009' , '安全帽' ),(	76,9,'D3_010' , '对重护网' ),(	77,9,'D3_011' , '隔离网'  ),(	78,9,'D3_Other'  , '其他'  );"];
        if (ret) {
            SZLog(@"t_JHA_ITEM插入数据成功！！！");
        }else{
            SZLog(@"t_JHA_ITEM插入数据失败！！！");
        }
        
    }];
    
}

@end
