//
//  SubLBXScanViewController.h
//
//  github:https://github.com/MxABC/LBXScan
//  Created by lbxia on 15/10/21.
//  Copyright © 2015年 lbxia. All rights reserved.
//


#import "LBXScanViewController.h"

@interface SZQRCodeProcotolitem : NSObject

@property (nonatomic , copy) NSString *rCode;

@property (nonatomic , copy) NSString *UNIT_NO;

@property (nonatomic , copy) NSString *REG_CODE;

@property (nonatomic , strong) NSMutableArray *strArray;

@end

//继承LBXScanViewController,在界面上绘制想要的按钮，提示语等
@interface SubLBXScanViewController : LBXScanViewController

@property (nonatomic , copy) void (^SuccessBlock) (SZQRCodeProcotolitem *item);

@end
