//
//  NSString+Extention.h
//  01-QQ聊天
//
//  Created by 武镇涛 on 15/4/12.
//  Copyright (c) 2015年 武镇涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Extention)
/**
 *  返回字符串的SIZE
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
- (CGSize)sizeWithfont:(UIFont*)font MaxX:(CGFloat)maxx;
- (CGSize)sizeWithfont:(UIFont*)font;
- (NSInteger)Filesize;

+(float)floatWithString:(NSString *)str;
+(float)floatWithString1:(NSString *)str;

+(float)floatNoSiSHeWUru:(float)floatValue;

+(NSString *)stringValueWithFloat:(float)floatValue;


+(NSString *)stringValuepingfenWithCount:(int)count totalTime:(NSString *)totalTime;
+(NSString *)stringValueShengxiaWithCount:(int)count totalTime:(NSString *)totalTime;


+(NSString *)perfenzhongWithString:(NSString *)strFenzhong andCount:(int)count;

+(NSString *)shengyufenzhongstrWithString:(NSString *)strFenzhong andCount:(int)count;

@end
