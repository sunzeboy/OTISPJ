//
//  SZSignDetailBottomOperationView.h
//  OTIS_PJ
//
//  Created by jQ on 16/6/13.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZSignDetailBottomOperationView : UIView
@property (weak, nonatomic) IBOutlet UIButton *resign;
@property (weak, nonatomic) IBOutlet UIButton *confirm;
@property (copy, nonatomic) void (^confirmActBlock)(UIButton *sender) ;

- (IBAction)resignAct:(UIButton *)sender;
- (IBAction)confirmAct:(UIButton *)sender;
+ (instancetype) loadSZSignDetailBottomOperationView;
@end
