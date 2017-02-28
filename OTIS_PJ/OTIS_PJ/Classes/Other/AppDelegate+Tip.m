//
//  AppDelegate+Tip.m
//  aosima
//
//  Created by sunze on 2016/10/28.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "AppDelegate+Tip.h"
#import <objc/runtime.h>
#import "NSDate+Format.h"
#import "CustomIOSAlertView.h"
#import "SZTable_LaborHours.h"

@implementation AppDelegate (Tip)

static NSString *timerKey = @"timerKey";
static NSTimeInterval kTipDeltTime = 60;


-(void)setTimer:(NSTimer *)timer
{
    objc_setAssociatedObject(self, &timerKey, timer, OBJC_ASSOCIATION_RETAIN);
}

-(NSTimer *)timer
{
    return objc_getAssociatedObject(self, &timerKey);
}

-(void)Tip{
    //主动更新是否做过工时的状态
    [SZTable_LaborHours isLaborHoursed];
    BOOL haveWritedgongshi = [[[NSUserDefaults standardUserDefaults] objectForKey:SZIsLaborHoursed] integerValue];
    if (self.timer == nil&& haveWritedgongshi== NO) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:kTipDeltTime target:self selector:@selector(checkCurrentTime) userInfo:nil repeats:YES];
    }
}

-(void)checkCurrentTime{
    NSDate *date = [NSDate date];
    //SZLog(@"%s %@",__func__,[NSThread currentThread]);
    if (date.hour>=17) {
        
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:@"您还未录入过工时，请及时录入工时！"
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            [alertView close];
        };
        [alertView show];
        [self.timer invalidate];
        self.timer = nil;
    }

}


//-(void)tipLocalNotification{
//
//    // 1.创建本地通知
//    UILocalNotification *localNote = [[UILocalNotification alloc] init];
//    
//    // 2.设置本地通知的内容
//    // 2.1.设置通知发出的时间
//    localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:3.0];
//    // 2.2.设置通知的内容
//    localNote.alertBody = @"在干吗?";
//    // 2.3.设置滑块的文字（锁屏状态下：滑动来“解锁”）
//    localNote.alertAction = @"解锁";
//    // 2.4.决定alertAction是否生效
//    localNote.hasAction = NO;
//    // 2.5.设置点击通知的启动图片
//    localNote.alertLaunchImage = @"123Abc";
//    // 2.6.设置alertTitle
//    localNote.alertTitle = @"你有一条新通知";
//    // 2.7.设置有通知时的音效
//    localNote.soundName = @"buyao.wav";
//    // 2.8.设置应用程序图标右上角的数字
//    localNote.applicationIconBadgeNumber = 999;
//    
//    // 2.9.设置额外信息
//    localNote.userInfo = @{@"type" : @1};
//    
//    
//    //主动更新是否做过工时的状态
//    [SZTable_LaborHours isLaborHoursed];
//    BOOL haveWritedgongshi = [[USER_DEFAULT objectForKey:SZIsLaborHoursed] integerValue];
//    if (haveWritedgongshi == YES && [[NSDate date] hour]>=17) {
//        // 3.调用通知
//        [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
//    }
//}


@end
