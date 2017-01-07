//
//  SZCustomerSignElevatorItem.m
//  OTIS_PJ
//
//  Created by jQ on 16/5/4.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZCustomerSignElevatorItem.h"

@implementation SZCustomerSignElevatorItem
- (instancetype)initWithDic:(NSDictionary *)dic
{
    if(self = [super init]){
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)signElevatorItemWithDic:(NSDictionary *)dic{
    return [[self alloc] initWithDic:dic];
}

//自适应高度
- (CGFloat)textHeight{
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH-70, MAXFLOAT);
    //
    return [self.itemName boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize: 14.0f]} context:nil].size.height;
}

+(NSArray *)elevatorItemList{
    //加载plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"elevatorItem" ofType:@"plist"];
    NSArray *dicArray = [NSArray arrayWithContentsOfFile:path];
    
    //字典转模型
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSDictionary *dic in dicArray) {
        SZCustomerSignElevatorItem *szcustomersign = [SZCustomerSignElevatorItem signElevatorItemWithDic:dic];
        [tmpArray addObject:szcustomersign];
    }
    return tmpArray;
}
@end
