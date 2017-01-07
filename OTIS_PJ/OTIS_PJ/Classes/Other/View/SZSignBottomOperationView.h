//
//  SZSignBottomOperationView.h
//  OTIS_PJ
//
//  Created by sunze on 16/6/12.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZSignBottomOperationView : UIView

@property (weak, nonatomic) IBOutlet UIButton *querenBtn;
@property (weak, nonatomic) IBOutlet UIButton *preBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (copy, nonatomic) void (^confirmActBlock)(UIButton *sender) ;

- (IBAction)querenAct:(UIButton *)sender;
- (IBAction)preAct:(UIButton *)sender;
- (IBAction)nextAct:(UIButton *)sender;


+(instancetype) loadSZSignBottomOperationView;

@end
