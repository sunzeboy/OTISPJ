//
//  SZHttpTool.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/22.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZHttpTool.h"
#import "AFNetworking.h"
#import "NSData+AES256.h"
#import "SZUploadMaintenancePicRequest.h"
#define YYEncode(str) [str dataUsingEncoding:NSUTF8StringEncoding]


@implementation SZImageUploadParam


@end

@implementation SZHttpTool

///**
// *  POST
// *
// *  @param URLString  接口地址
// *  @param parameters 参数
// *  @param success    成功
// *  @param failure    失败
// */
//+(void)post:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
//{
//    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
//    
//    
//    [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        success(responseObject);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        SZLog(@"%@",error);
//        failure(error);
//    }];
//    
//
//    
//}


/**
 *  POST
 *
 *  @param URLString  接口地址
 *  @param parameters 参数
 *  @param success    成功
 *  @param failure    失败
 */
+(void)loginPost:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
    
    //加密
    NSMutableDictionary *finalParameter = parameters;
    
    for (NSString *strKey in finalParameter.allKeys) {
        NSString *value = finalParameter[strKey];
        finalParameter[strKey] = [NSData AES256EncryptWithPlainText:value];
    }
    
    //SZLog(@"====%@",finalParameter);
    
    [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *strDecrypt = [NSData AES256DecryptWithCiphertext:[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]];
//                SZLog(@"%@",strDecrypt);
        
        success(strDecrypt);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SZLog(@"%@",error);
        
        failure(error);

    }];
    
    
    
}


/**
 *  POST
 *
 *  @param URLString  接口地址
 *  @param parameters 参数
 *  @param success    成功
 *  @param failure    失败
 */
+(void)post:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];

    //加密
    NSMutableDictionary *finalParameter = parameters;

    for (NSString *strKey in finalParameter.allKeys) {
        NSString *value = finalParameter[strKey];
        finalParameter[strKey] = [NSData AES256EncryptWithPlainText:value];
    }
    
    //SZLog(@"====%@",finalParameter);

    [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSString *strDecrypt = [NSData AES256DecryptWithCiphertext:[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]];
//        SZLog(@"%@",strDecrypt);

        success(strDecrypt);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SZLog(@"%@",error);
        

        failure(error);
        
        if (error.code == -1009) {
            [[NSNotificationCenter defaultCenter] postNotificationName:SZNotificationNoNetwork object:self userInfo:nil];

        }else if (error.code == -1011){
        
        }
        
    }];
    
    
    
}

+(void)upload:(NSString*)urlpath param:(id)parameters uploadParam:(SZImageUploadParam *)uploadParam success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"charset=utf-8",nil];
//    [manager.requestSerializer setValue:@"multipart/form-data;" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
    

    //加密
    NSMutableDictionary *finalParameter = parameters;
    for (NSString *strKey in finalParameter.allKeys) {
        NSString *value = finalParameter[strKey];
        finalParameter[strKey] = [NSData AES256EncryptWithPlainText:value];
    }

    SZLog(@"\\\\\%@",parameters);
    
    [manager POST:urlpath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if ([uploadParam.data isValidjpgByImageData:uploadParam.data]) {
            SZLog(@"uploadParam.data:%@",uploadParam.data);
            [formData appendPartWithFileData:uploadParam.data name:@"PicName" fileName:@"" mimeType:@"image/jpg"];
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *strDecrypt = [NSData AES256DecryptWithCiphertext:[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]];
        SZLog(@"++++++++%@",strDecrypt);
        success(strDecrypt);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SZLog(@"--------%@",error);
        [[NSNotificationCenter defaultCenter] postNotificationName:SZNotificationNoNetwork object:self userInfo:nil];

    }];
}



@end
