//
//  SZFMDB.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/28.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
@interface SZFMDB : NSObject

@property (nonatomic , strong) FMDatabase *db;
@property (nonatomic , strong) FMDatabaseQueue *dbQueue;


SZSingletonH(SZFMDB)

//+(instancetype)sharedSZFMDB;



@end
