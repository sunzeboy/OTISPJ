//
//  SZFMDB.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/28.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZFMDB.h"

static NSString * const dirName           = @"downdata";
#define DataDir [NSString stringWithFormat:@"%@/%@", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0], dirName]

@implementation SZFMDB

//-(id) init
//{
//    self = [super init];
//    @synchronized(self){
//    if(self){
//        BOOL isDir = NO;
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        BOOL existed = [fileManager fileExistsAtPath:DataDir isDirectory:&isDir];
//        if ( !(isDir == YES && existed == YES) )
//        {
//            [fileManager createDirectoryAtPath:DataDir withIntermediateDirectories:YES attributes:nil error:nil];
//        }
//        
//        // 1.打开数据库
//        NSString *path = [DataDir stringByAppendingPathComponent:@"statuses.sqlite"];
//        self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
//        SZLog(@"%@",path);
//    }
//    }
//    return self;
//}
//
//+(instancetype)sharedSZFMDB
//{
//    static dispatch_once_t pred = 0;
//    __strong static id _sharedObject = nil;
//    dispatch_once(&pred, ^{
//        _sharedObject = [[self alloc] init];
//    });
//    return _sharedObject;
//}




SZSingletonM(SZFMDB)



-(FMDatabaseQueue *)dbQueue{

    if (_db == nil) {
        BOOL isDir = NO;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL existed = [fileManager fileExistsAtPath:DataDir isDirectory:&isDir];
        if ( !(isDir == YES && existed == YES) )
        {
            [fileManager createDirectoryAtPath:DataDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        // 1.打开数据库
        NSString *path = [DataDir stringByAppendingPathComponent:@"statuses.sqlite"];
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
        SZLog(@"%@",path);

    }
    return _dbQueue;
}


@end
