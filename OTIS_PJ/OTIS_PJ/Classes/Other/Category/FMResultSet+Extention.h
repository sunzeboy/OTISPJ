//
//  FMResultSet+Extention.h
//  OTIS_PJ
//
//  Created by sunze on 16/7/8.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <FMDB/FMDB.h>

@interface FMResultSet (Extention)
- (float)floatForColumn:(NSString*)columnName;
@end
