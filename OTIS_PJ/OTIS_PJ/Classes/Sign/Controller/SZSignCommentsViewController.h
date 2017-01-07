//
//  SZSignCommentsViewController.h
//  OTIS_PJ
//
//  Created by jQ on 16/6/14.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZSignCommentsViewController : UIViewController

@property(strong,nonatomic)NSString * maintenanceComments;
@property(nonatomic,strong) UITextView * commentTextDetail;
@property(nonatomic,assign)BOOL needReplace;
@property(nonatomic,assign)BOOL needReform;

@property (copy, nonatomic) void (^commentTextDetailBlock)(NSString *question) ;

@end
