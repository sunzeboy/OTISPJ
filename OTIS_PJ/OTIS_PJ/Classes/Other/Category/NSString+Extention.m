//
//  NSString+Extention.m
//  01-QQ聊天
//
//  Created by 武镇涛 on 15/4/12.
//  Copyright (c) 2015年 武镇涛. All rights reserved.
//

#import "NSString+Extention.h"

@implementation NSString (Extention)
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesDeviceMetrics|NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    
    
}
- (CGSize)sizeWithfont:(UIFont*)font MaxX:(CGFloat)maxx
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxx, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
}
- (CGSize)sizeWithfont:(UIFont*)font
{
    return [self sizeWithfont:font MaxX:MAXFLOAT];
}

- (NSInteger)Filesize
{
    NSFileManager *mgr = [NSFileManager defaultManager];
    BOOL dir;
    BOOL exist =  [mgr fileExistsAtPath:self isDirectory:&dir];
    if (exist == NO) return 0;
    if (dir) {//self是一个文件夹
        //找出文件夹中的文件名
        NSArray *subpaths = [mgr subpathsAtPath:self];
        //获得全路径
        NSInteger totalByteSize = 0;
        for (NSString *subpath in subpaths)
        {
            NSString *fullpath = [self stringByAppendingPathComponent:subpath];
            //遍历文件
            BOOL dir = NO;
            [mgr fileExistsAtPath:fullpath isDirectory:&dir];
            if (dir == NO) {
                totalByteSize +=[[mgr attributesOfItemAtPath:fullpath error:nil][NSFileSize]integerValue];
            }
            
        }
        return totalByteSize;
        
    }else
    {
        return [[mgr attributesOfItemAtPath:self error:nil][NSFileSize]integerValue];
    }
    
    
}


+(float)floatWithString:(NSString *)str{

    float a = [str stringByReplacingOccurrencesOfString:@":"withString:@"."].floatValue;
    return ((int)a)+((a-(int)a)*100.00)/60.00;
    
}

+(NSString *)stringValueWithFloat:(float)floatValue{
    
    return [NSString stringWithFormat:@"%02d:%02d",(int)floatValue,(int)((floatValue-(int)floatValue)*60)];
    
}

+(float)floatWithString1:(NSString *)str{
    
    NSString *str2 = [NSString stringWithFormat:@"%f",[self floatWithString:str]];
    NSRange range = [str2 rangeOfString:@"."];
    NSString *str11 = [str2 substringToIndex:range.location+3];
    return str11.floatValue;
    
}
+(float)floatNoSiSHeWUru:(float)floatValue{
    
    NSString *str2 = [NSString stringWithFormat:@"%f",floatValue];
    NSRange range = [str2 rangeOfString:@"."];
    NSString *str11 = [str2 substringToIndex:range.location+3];
    return str11.floatValue;
    
}


+(NSString *)stringValuepingfenWithCount:(int)count totalTime:(NSString *)totalTime
{
    float per = [self floatNoSiSHeWUru:totalTime.floatValue/count];

    NSString *str2 = [NSString stringWithFormat:@"%f",per];
    NSRange range = [str2 rangeOfString:@"."];
    NSString *str11 = [str2 substringToIndex:range.location+3];
    return str11;
}

+(NSString *)stringValueShengxiaWithCount:(int)count totalTime:(NSString *)totalTime{

    float shengxia = totalTime.floatValue -([self stringValuepingfenWithCount:count totalTime:totalTime].floatValue)*count;
    NSString *str2 = [NSString stringWithFormat:@"%f",shengxia];
    NSRange range = [str2 rangeOfString:@"."];
    NSString *str11 = [str2 substringToIndex:range.location+3];
    return str11;

}


+(int)fenzhongWithString:(NSString *)strFenzhong{
//    NSString *str = [strFenzhong stringByReplacingOccurrencesOfString:@":"withString:@"."];
    NSArray *array =[strFenzhong componentsSeparatedByString:@":"];
    int xiaoshi = [array[0] intValue];
    int fenzhong = [array[1] intValue];

//    float fenzhong = str.floatValue;
//    return ((int)fenzhong )*60+(fenzhong-((int)fenzhong))*100;
    return (xiaoshi*60)+fenzhong;
}

+(BOOL)nengfouzhengchuWithString:(NSString *)strFenzhong andCount:(int)count {

    NSArray *array =[strFenzhong componentsSeparatedByString:@":"];
    int xiaoshi = [array[0] intValue];
    int fenzhong = [array[1] intValue];
    int total = (xiaoshi*60)+fenzhong;
    if (total == 0) {
        return YES;
    }
    if (total % count>0) {
        return NO;
    }
    return YES;
}



//+(int)shengyufenzhongWithString:(NSString *)strFenzhong andCount:(int)count{
//    
//    int total = [self fenzhongWithString:strFenzhong];
//    if ([self nengfouzhengchuWithString:strFenzhong andCount:count]) {
//        return total/count;
//    }else{
//        
//        return total-((count-1)*(total/count));
//    }
//
////    return 0;
//}




+(NSString *)perfenzhongWithString:(NSString *)strFenzhong andCount:(int)count{
    
    NSArray *array =[strFenzhong componentsSeparatedByString:@":"];
    int xiaoshi = [array[0] intValue];
    int fenzhong = [array[1] intValue];
    int total = (xiaoshi*60)+fenzhong;
    return [self strValueWithInt:total/count];
    
}

+(NSString *)shengyufenzhongstrWithString:(NSString *)strFenzhong andCount:(int)count{
    
    NSArray *array =[strFenzhong componentsSeparatedByString:@":"];
    int xiaoshi = [array[0] intValue];
    int fenzhong = [array[1] intValue];
    int total = (xiaoshi*60)+fenzhong;
    if (total % count == 0) {
        return [self strValueWithInt:total/count];
    }else{

        return [self strValueWithInt:total-((count-1)*(total/count))];
    }
    
    //    return 0;
}

+(NSString *)strValueWithInt:(int)intValue{

    return [NSString stringWithFormat:@"%02d:%02d",intValue/60,intValue%60];

}



@end
