//
//  SZBottomSaveOperationView.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/12.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZBottomSaveOperationView : UIView

@property (copy, nonatomic) void (^confirmActBlock)(UIButton *sender) ;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;



+ (instancetype) loadSZBottomSaveOperationView;
@end
