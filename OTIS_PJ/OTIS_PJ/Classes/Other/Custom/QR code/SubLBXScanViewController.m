//
//
//
//
//  Created by lbxia on 15/10/21.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "SubLBXScanViewController.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"

@implementation SZQRCodeProcotolitem

@end


@interface SubLBXScanViewController ()

@end

@implementation SubLBXScanViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor blackColor];
    
}


- (void)showError:(NSString*)str
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"标题" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];

    [self presentViewController:alertController animated:YES completion:nil];
}



- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    
    if (array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
     
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array) {
        
        NSLog(@"scanResult:%@",result.strScanned);
    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //震动提醒
   // [LBXScanWrapper systemVibrate];
    //声音提醒
    //[LBXScanWrapper systemSound];
    
    [self showNextVCWithScanResult:scanResult];
   
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
        
        strResult = @"识别失败";
    }
    
    __weak __typeof(self) weakSelf = self;

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"标题" message:strResult preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //点击完，继续扫码
        [weakSelf reStartDevice];
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
    
//    ScanResultViewController *vc = [ScanResultViewController new];
//    vc.imgScan = strResult.imgScanned;
//    
//    vc.strScan = strResult.strScanned;
//    
//    vc.strCodeType = strResult.strBarCodeType;
//
    NSString *rCode = strResult.strScanned;
    
    NSMutableArray *arrayCode = [NSMutableArray array];
    SZQRCodeProcotolitem *item = [[SZQRCodeProcotolitem alloc] init];
    item.rCode = rCode;

    if ([rCode containsString:SZQRCodeProtocal]) {
        
        NSArray *arrayData = [rCode componentsSeparatedByString:@"?"];
        NSString *strP = [arrayData lastObject];
        NSArray *arrayT = [strP componentsSeparatedByString:@"&"];
        
        for (NSString *strCode in arrayT) {
            if ([strCode containsString:@"UNIT_NO="]) {
                NSRange range = [strCode rangeOfString:@"UNIT_NO="];
                item.UNIT_NO = [strCode substringFromIndex:range.length];
            }
        }
        for (NSString *strCode in arrayT) {
            if ([strCode containsString:@"REG_CODE="]) {
                NSRange range = [strCode rangeOfString:@"REG_CODE="];
                item.REG_CODE = [strCode substringFromIndex:range.length];
            }
        }
//        if (self.SuccessBlock) {
//            self.SuccessBlock(item);
//        }
        
    }else{
        
        NSRange range = [rCode rangeOfString:@"3"];
        if (range.length!=0) {
            NSString *code = [rCode substringFromIndex:range.location];
            if (code.length>=20) {
                [arrayCode addObject:[code substringToIndex:20]];
            }else{
                [arrayCode addObject:code];
            }
            while (code.length>=20) {
                NSString *tempStr = [code substringFromIndex:1];
                NSRange rangeSub = [tempStr rangeOfString:@"3"];
                
                if (rangeSub.length!=0) {
                    code = [tempStr substringFromIndex:rangeSub.location];
                    if (code.length>=20) {
                        [arrayCode addObject:[code substringToIndex:20]];
                    }else{
                        [arrayCode addObject:code];
                    }
                }else{
                    break;
                }
            }
        }else{
            //[arrayCode addObject:rCode];
        }
    }
    item.strArray = arrayCode;

    [self.navigationController popViewControllerAnimated:YES];
    if (self.SuccessBlock) {
        self.SuccessBlock(item);
    }
}




@end
