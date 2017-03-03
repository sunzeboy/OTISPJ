//
//  SZHttpTool.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZImageUploadParam : NSObject

@property (nonatomic, strong) NSData *data;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *paramName;
@property (nonatomic, copy) NSString *mineType;

@end


@interface SZHttpTool : NSObject

/**
 *  POST
 *
 *  @param URLString  接口地址
 *  @param parameters 参数
 *  @param success    成功
 *  @param failure    失败
 */
+(void)loginPost:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure;
+(void)post:(NSString *)URLString parameters:(id)parameters success:(void (^)(id obj))success failure:(void (^)(NSError *error))failure;



+(void)upload:(NSString*)urlpath param:(id)parameters uploadParam:(SZImageUploadParam *)uploadParam success:(void (^)(id))success failure:(void (^)(NSError *))failure;



+(void)noPasswordpost:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure;

@end
