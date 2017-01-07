//
//  CustomIOSAlertView.h
//  CustomIOSAlertView
//
//  Created by Richard on 20/09/2013.
//  Copyright (c) 2013-2015 Wimagguc.
//
//  Lincesed under The MIT License (MIT)
//  http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>
#import "SZBaseLineViewCell.h"

@interface CustomIOSAlertView : UIView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UIView *parentView;    // The parent view this 'dialog' is attached to
@property (nonatomic, retain) UIView *dialogView;    // Dialog's container view
@property (nonatomic, retain) UIView *containerView; // Container within the dialog (place your ui elements here)

@property (nonatomic, retain) NSArray *buttonTitles;
@property (nonatomic, assign) BOOL useMotionEffects;
@property (nonatomic, strong) NSArray *records;
@property (copy) void (^onButtonTouchUpInside)(CustomIOSAlertView *alertView, int buttonIndex) ;
//--------------附加

@property (copy) void (^onTableViewSelect)(SZBaseLineViewCell *cell, NSInteger cellIndex) ;


- (id)init;

/*!
 DEPRECATED: Use the [CustomIOSAlertView init] method without passing a parent view.
 */
- (id)initWithParentView: (UIView *)_parentView __attribute__ ((deprecated));

- (void)show;
- (void)close;

- (IBAction)customIOS7dialogButtonTouchUpInside:(id)sender;
- (void)setOnButtonTouchUpInside:(void (^)(CustomIOSAlertView *alertView, int buttonIndex))onButtonTouchUpInside;

- (void)deviceOrientationDidChange: (NSNotification *)notification;
- (void)dealloc;
//--------------附加
// 普通提示框
-(id)initAlertDialogVieWithImageName: (NSString *)imageName dialogTitle:(NSString *)title dialogContents:(NSString *)contents dialogButtons: (NSMutableArray *)btns;
// 选择提示框
-(id)initSelectDialogVieWithImageName: (NSString *)imageName dialogTitle:(NSString *)title dialogContents:(NSMutableArray *)contents dialogButtons: (NSMutableArray *)btns;


-(id)initAlertDialog2VieWithImageName: (NSString *)imageName dialogTitle:(NSString *)title dialogContents:(NSString *)contents dialogButtons: (NSMutableArray *)btns;
@end
