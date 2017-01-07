//
//  SZSignatureBoardViewController.h
//  OTIS_PJ
//
//  Created by jQ on 16/5/9.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  signDetailDelegate<NSObject>
-(void) sendSignatureImage:(UIImage *)image;
@end
@interface SZSignatureBoardViewController : UIViewController
@property (nonatomic, weak) id<signDetailDelegate> delegate;
@end
