//
//  Macro.h
//  CarLifeStyle
//
//  Created by sunze on 16/1/7.
//  Copyright © 2016年 mijia. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#pragma mark - 打印日志

#ifdef DEBUG
#define SZLog(...) NSLog(@"%s\n %@ \n\n",__func__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define SZLog(...) NSLog(@"%@",[NSString stringWithFormat:__VA_ARGS__]) 
#endif

#define VisibleVC ((AppDelegate *)[UIApplication sharedApplication].delegate).nav

#define PicDataDir(fileName) [NSString stringWithFormat:@"%@/images/%@", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0],fileName]
#define PicImageDir [NSString stringWithFormat:@"%@/images", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]]
#define kSignature [NSString stringWithFormat:@"%@/signature", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]]
#define kHeadImage [NSString stringWithFormat:@"%@/headImage", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]]
#define kCurrentCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]


#pragma mark - 获取设备大小

//NavBar高度
#define NavigationBar_HEIGHT 44
//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define SZNotificationCenter  [NSNotificationCenter defaultCenter]


#pragma mark - 系统
//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]

//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//判断是否 Retina屏、设备是否%fhone 5、是否是iPad
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)



// block self
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;



#pragma mark - 图片

//读取本地图片
#define LOADIMAGE(file) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:@"png"]]

//定义UIImage对象
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

//定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:_pointer]
//建议使用前两种宏定义,性能高于后者




#pragma mark - 颜色类
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

//背景色
#define BACKGROUND_COLOR [UIColor colorWithRed:242.0/255.0 green:236.0/255.0 blue:231.0/255.0 alpha:1.0]

//清除背景色
#define CLEARCOLOR [UIColor clearColor]

#pragma mark - color functions
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]





#pragma mark - 其他类

//方正黑体简体字体定义
#define FONT(F) [UIFont fontWithName:@"FZHTJW--GB1-0" size:F]




//设置View的tag属性
#define VIEWWITHTAG(_OBJECT, _TAG)    [_OBJECT viewWithTag : _TAG]
//程序的本地化,引用国际化的文件
#define SZLocal(x, ...) NSLocalizedString(x, nil)

//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

//NSUserDefaults 实例化
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]


//由角度获取弧度 有弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)

//.h
#define SZSingletonH(name) +(instancetype)shared##name;


//.m
#define SZSingletonM(name)\
static id _instance = nil;\
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (instancetype)shared##name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
}


#define SZAccountPath(file) [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:file]

////#define SZOuterNetwork    @"http://ochcsprdweb.cloudapp.net:22281/"
//
////#define SZOuterNetwork    @"http://192.168.30.84:22282/"
////#define SZOuterNetwork      @"http://192.168.30.62/LBS_Mobile/"
//#define SZOuterNetwork    @"http://ochcsprdweb.cloudapp.net/MobileTest/"
//#define SZOuterNetwork    @"http://192.168.30.61/LBS_Mobile/"
//
//#define SZNetwork    SZOuterNetwork
//
//#define APIVersion        @"LBS_V8.0.0"
////登陆API
//#define APILogin                            [SZNetwork stringByAppendingString:@"Terminal/Logon"]
////电梯离线下载API
//#define APIUnitsForOffline                  [SZNetwork stringByAppendingString:@"Terminal/UnitsForOfflineV7"]
////计划离线下载API
//#define APISchedulesForOffline              [SZNetwork stringByAppendingString:@"Terminal/SchedulesForOfflineV4"]
////保养卡离线下载API
//#define APIScheduleCardsForOffline          [SZNetwork stringByAppendingString:@"Terminal/ScheduleCardsForOffline"]
////未完成项离线下载API
//#define APIUnfinishedItemsForOffline        [SZNetwork stringByAppendingString:@"Terminal/UnfinishedItemsForOffline"]
////预留科目离线下载API
//#define APIReservedSubjectForOffline        [SZNetwork stringByAppendingString:@"Terminal/LaborTypeForOffline"]
////安全项离线下载API
//#define APISafetyItemForOffline             [SZNetwork stringByAppendingString:@"Terminal/SafetyItemForOffline"]
////年检项离线下载API
//#define APIYCheckForOffline                 [SZNetwork stringByAppendingString:@"Terminal/YCheckForOffline"]
////电梯未扫描原因离线下载API
//#define APIUnScanedReasonForOffline         [SZNetwork stringByAppendingString:@"Terminal/UnScanedReasonForOffline"]
////LaborType(工时)API
//#define APILaborType                        [SZNetwork stringByAppendingString:@"Terminal/GetLaborType"]
////修改新密码API
//#define APIChangeNewPassword                [SZNetwork stringByAppendingString:@"Terminal/ChangePassword"]
//
////上传保养报告
//#define APIUploadSaveReportV7               [SZNetwork stringByAppendingString:@"Terminal/SaveReportV7"]
////上传保养照片
//#define APIUploadImageV3                    [SZNetwork stringByAppendingString:@"Terminal/UploadImageForIOS"]
////上传维修换件报告
//#define APISaveFixV4                        [SZNetwork stringByAppendingString:@"Terminal/SaveFixV4"]
////上传批量中断
//#define APISaveReportInBatchesV2            [SZNetwork stringByAppendingString:@"Terminal/SaveReportInBatchesV2"]
////上传签字数据
//#define APIESignatureV5                     [SZNetwork stringByAppendingString:@"Terminal/ESignatureV5"]
////上传年检记录
//#define APISaveYearlyCheck                  [SZNetwork stringByAppendingString:@"Terminal/SaveYearlyCheck"]
////上传全工时数据
//#define APISaveFullLaborHours               [SZNetwork stringByAppendingString:@"Terminal/SaveFullLaborHours"]
////上传日志
//#define APILog                              [SZNetwork stringByAppendingString:@"Terminal/Log"]
//
////忘记密码
//
//#define APIValidationCode                   [SZNetwork stringByAppendingString:@"Terminal/SendValidationCode?810"]
//
//#define APICheckValidationCode              [SZNetwork stringByAppendingString:@"Terminal/CheckValidationCode?810"]
//
//#define APIForgetPassWord                   [SZNetwork stringByAppendingString:@"Terminal/ValidationCodeChangePassword"]
//
//#define APIExitLogin                        [SZNetwork stringByAppendingString:@"Terminal/Logout"]


#define kNumberOfEachDeposit                500


#define SZQRCodeProtocal                   @"http://ochcsprdoeweb.cloudapp.net/qr/elevator"

#define APIForceUpdate                     [SZNetwork stringByAppendingString:@"Terminal/TerminalVersionValidationV7"]

#define kMaxLength 20  


#define SZNotificationUpdateBadgeViewCount                    @"UpdateBadgeViewCount"
#define SZNotificationNoNetwork                               @"NoNetwork"
#define SZNotificationUploadFailed                            @"UploadFailed"
#define SZNotificationLocation                                @"location"

#define SZIsLaborHoursed                                      [NSString stringWithFormat:@"%@isLaborHoursed",[OTISConfig EmployeeID]]
#define SZLaborHoursDay                                       [NSString stringWithFormat:@"%@LaborHoursDay",[OTISConfig EmployeeID]]

#endif /* Macro_h */
