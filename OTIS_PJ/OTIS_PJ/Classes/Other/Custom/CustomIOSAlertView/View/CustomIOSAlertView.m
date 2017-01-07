//
//  CustomIOSAlertView.m
//  CustomIOSAlertView
//
//  Created by Richard on 20/09/2013.
//  Copyright (c) 2013-2015 Wimagguc.
//
//  Lincesed under The MIT License (MIT)
//  http://opensource.org/licenses/MIT
//

#import "CustomIOSAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "SZBaseLineViewCell.h"

const static CGFloat kCustomIOSAlertViewDefaultButtonHeight       = 50;
const static CGFloat kCustomIOSAlertViewDefaultButtonSpacerHeight = 28;
const static CGFloat kCustomIOSAlertViewCornerRadius              = 7;
const static CGFloat kCustomIOS7MotionEffectExtent                = 10.0;


@implementation CustomIOSAlertView

CGFloat buttonHeight = 0;
CGFloat buttonSpacerHeight = 0;

@synthesize parentView, containerView, dialogView, onButtonTouchUpInside;
@synthesize buttonTitles;
@synthesize useMotionEffects;

- (id)initWithParentView: (UIView *)_parentView
{
    self = [self init];
    if (_parentView) {
        self.frame = _parentView.frame;
        self.parentView = _parentView;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

        useMotionEffects = false;
        buttonTitles = @[@"Close"];
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}


-(id)initAlertDialogVieWithImageName: (NSString *)imageName dialogTitle:(NSString *)title dialogContents:(NSString *)contents dialogButtons: (NSMutableArray *)btns {


    self = [self init];
    UIView *dlgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 125)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 125)];
    if (imageName) {
        [imageView setImage:[UIImage imageNamed:imageName]];
    }
    [dlgView addSubview:imageView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH - 50, 30)];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.font =[UIFont fontWithName:@"Microsoft YaHei" size:20];
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 70, SCREEN_WIDTH - 100, 50)];
    contentLabel.text = contents;
    if ([contents isEqualToString:SZLocal(@"dialog.title.Data synchronization failure!")]) {
        contentLabel.textColor = [UIColor redColor];
    }
    contentLabel.font =[UIFont fontWithName:@"Microsoft YaHei" size:14];
    if (contents.length > 12) {
        contentLabel.textAlignment = NSTextAlignmentLeft;
    } else {
        contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [imageView addSubview:titleLabel];
    [imageView addSubview:contentLabel];
    // Add some custom content to the alert view
    [self setContainerView:dlgView];
    
    // Modify the parameters
    [self setButtonTitles:btns];
    
    // You may use a Block, rather than a delegate.
    [self setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        [alertView close];
    }];
    
    [self setUseMotionEffects:true];

    return self;


}


-(id)initAlertDialog2VieWithImageName: (NSString *)imageName dialogTitle:(NSString *)title dialogContents:(NSString *)contents dialogButtons: (NSMutableArray *)btns {
    
    
    self = [self init];
    UIView *dlgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT - 30, 125)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT - 30, 125)];
    if (imageName) {
        [imageView setImage:[UIImage imageNamed:imageName]];
    }
    [dlgView addSubview:imageView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, SCREEN_HEIGHT - 50, 30)];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.font =[UIFont fontWithName:@"Microsoft YaHei" size:20];
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 70, SCREEN_HEIGHT - 100, 50)];
    contentLabel.text = contents;
    contentLabel.font =[UIFont fontWithName:@"Microsoft YaHei" size:14];
    if (contents.length > 12) {
        contentLabel.textAlignment = NSTextAlignmentLeft;
    } else {
        contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [imageView addSubview:titleLabel];
    [imageView addSubview:contentLabel];
    // Add some custom content to the alert view
    [self setContainerView:dlgView];
    
    // Modify the parameters
    [self setButtonTitles:btns];
    
    // You may use a Block, rather than a delegate.
    [self setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        [alertView close];
    }];
    
    [self setUseMotionEffects:true];
    
    return self;
    
    
}



// 选择提示框
-(id)initSelectDialogVieWithImageName: (NSString *)imageName dialogTitle:(NSString *)title dialogContents:(NSMutableArray *)contents dialogButtons: (NSMutableArray *)btns {
    self = [self init];
    self.records = contents;
    unsigned long boxHeight = 72 + 50 * contents.count;
    // 图片高度 72
    UIView *dlgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, boxHeight)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 72)];
    if (imageName) {
        [imageView setImage:[UIImage imageNamed:imageName]];
    }
    [dlgView addSubview:imageView];
    // 将文字写到图片上
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, SCREEN_WIDTH - 70, 30)];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font =[UIFont fontWithName:@"Microsoft YaHei" size:20];
    [imageView addSubview:titleLabel];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 72, SCREEN_WIDTH - 30, 50 * contents.count)];
    tableView.delegate = self;
    tableView.dataSource =self;
    tableView.rowHeight = 50;
    [dlgView addSubview:tableView];
    
    // Add some custom content to the alert view
    [self setContainerView:dlgView];
    
    // Modify the parameters
    [self setButtonTitles:btns];
    
    // You may use a Block, rather than a delegate.
    [self setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        [alertView close];
    }];
    
    [self setUseMotionEffects:true];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    
    
    if ([tableView.delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
        
        [tableView.delegate tableView:tableView willSelectRowAtIndexPath:indexPath];
        
    }
    
    
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition: UITableViewScrollPositionNone];
    
    
    
    if ([tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        
        [tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
        
    }
    
    return self;
}
//返回每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.records.count;
}
//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 从可重用表格行的队列中取出一个表格行
    SZBaseLineViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil) {
        cell = [[SZBaseLineViewCell alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 50)];
        cell.lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 1)];
        cell.lineLabel.backgroundColor = [UIColor colorWithRed:216.0f/255.0f green:216.0f/255.0f blue:216.0f/255.0f alpha:1.0f];
        
        cell.checkboxView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 14, 22, 22)];
        [cell.checkboxView setImage:[UIImage imageNamed:@"check_off"]];
        cell.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH - 80, 50)];
        cell.contentLabel.text = [self.records objectAtIndex:indexPath.row];
        cell.contentLabel.textColor = [UIColor colorWithHexString:@"5A5A5A"];
        cell.contentLabel.numberOfLines = 0;
        cell.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        if ([SZLocal(@"dialog.content.noBarcodeButExist") isEqualToString:cell.contentLabel.text]) {
            cell.userInteractionEnabled = NO;
            cell.contentLabel.textColor = [UIColor colorWithHexString:@"909090"];
        }
        cell.contentLabel.font =[UIFont fontWithName:@"Microsoft YaHei" size:14];
        cell.contentLabel.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:cell.lineLabel];
        [cell addSubview:cell.checkboxView];
        [cell addSubview:cell.contentLabel];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SZBaseLineViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.checkboxView setImage:[UIImage imageNamed:@"check_on"]];
    if (self.onTableViewSelect) {
        self.onTableViewSelect(cell, indexPath.row);
    }
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0) {
    SZBaseLineViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.checkboxView setImage:[UIImage imageNamed:@"check_off"]];
}


// Create the dialog view, and animate opening the dialog
- (void)show
{
    dialogView = [self createContainerView];
  
    dialogView.layer.shouldRasterize = YES;
    dialogView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
  
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];

#if (defined(__IPHONE_7_0))
    if (useMotionEffects) {
        [self applyMotionEffects];
    }
#endif

    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    [self addSubview:dialogView];

    // Can be attached to a view or to the top most window
    // Attached to a view:
    if (parentView != NULL) {
        [parentView addSubview:self];

    // Attached to the top most window
    } else {

        // On iOS7, calculate with orientation
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
            
            UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
            switch (interfaceOrientation) {
                case UIInterfaceOrientationLandscapeLeft:
                    self.transform = CGAffineTransformMakeRotation(M_PI * 270.0 / 180.0);
                    break;
                    
                case UIInterfaceOrientationLandscapeRight:
                    self.transform = CGAffineTransformMakeRotation(M_PI * 90.0 / 180.0);
                    break;
                    
                case UIInterfaceOrientationPortraitUpsideDown:
                    self.transform = CGAffineTransformMakeRotation(M_PI * 180.0 / 180.0);
                    break;
                    
                default:
                    break;
            }
            
            [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];

        // On iOS8, just place the dialog in the middle
        } else {

            CGSize screenSize = [self countScreenSize];
            CGSize dialogSize = [self countDialogSize];
            CGSize keyboardSize = CGSizeMake(0, 0);

            dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);

        }

        [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    }

    dialogView.layer.opacity = 0.5f;
    dialogView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                         dialogView.layer.opacity = 1.0f;
                         dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1);
					 }
					 completion:NULL
     ];

}

// Button has been touched
- (IBAction)customIOS7dialogButtonTouchUpInside:(id)sender
{
    if (onButtonTouchUpInside != NULL) {
        onButtonTouchUpInside(self, (int)[sender tag]);
    }
}

// Default button behaviour
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Clicked! %d, %d", (int)buttonIndex, (int)[alertView tag]);
    [self close];
}

// Dialog close animation then cleaning and removing the view from the parent
- (void)close
{
    CATransform3D currentTransform = dialogView.layer.transform;

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        CGFloat startRotation = [[dialogView valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
        CATransform3D rotation = CATransform3DMakeRotation(-startRotation + M_PI * 270.0 / 180.0, 0.0f, 0.0f, 0.0f);

        dialogView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
    }

    dialogView.layer.opacity = 1.0f;

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
					 animations:^{
						 self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                         dialogView.layer.opacity = 0.0f;
					 }
					 completion:^(BOOL finished) {
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
					 }
	 ];
}

- (void)setSubView: (UIView *)subView
{
    containerView = subView;
}

// Creates the container view here: create the dialog, then add the custom content and buttons
- (UIView *)createContainerView
{
    if (containerView == NULL) {
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
    }

    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];

    // For the black background
    [self setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];

    // This is the dialog's container; we attach the custom content and the buttons to this one
    UIView *dialogContainer = [[UIView alloc] initWithFrame:CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height)];

    // First, we style the dialog to match the iOS7 UIAlertView >>>
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = dialogContainer.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f] CGColor],
                       nil];

    CGFloat cornerRadius = kCustomIOSAlertViewCornerRadius;
    gradient.cornerRadius = cornerRadius;
    [dialogContainer.layer insertSublayer:gradient atIndex:0];

    dialogContainer.layer.cornerRadius = cornerRadius;
    dialogContainer.layer.borderColor = [[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f] CGColor];
    dialogContainer.layer.borderWidth = 1;
    dialogContainer.layer.shadowRadius = cornerRadius + 5;
    dialogContainer.layer.shadowOpacity = 0.1f;
    dialogContainer.layer.shadowOffset = CGSizeMake(0 - (cornerRadius+5)/2, 0 - (cornerRadius+5)/2);
    dialogContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    dialogContainer.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:dialogContainer.bounds cornerRadius:dialogContainer.layer.cornerRadius].CGPath;
    dialogContainer.clipsToBounds = YES;

    // There is a line above the button
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, dialogContainer.bounds.size.height - buttonHeight - buttonSpacerHeight, dialogContainer.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0f];
    [dialogContainer addSubview:lineView];
    // ^^^

    // Add the custom container if there is any
    [dialogContainer addSubview:containerView];

    // Add the buttons too
    [self addButtonsToView:dialogContainer];

    return dialogContainer;
}

// Helper function: add buttons to container
- (void)addButtonsToView: (UIView *)container
{
    if (buttonTitles==NULL) { return; }
    CGFloat blankWidth = 20;
    CGFloat buttonWidth = (container.bounds.size.width - blankWidth * ([buttonTitles count] + 1)) / [buttonTitles count];

    for (int i=0; i<[buttonTitles count]; i++) {

        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];

        [closeButton setFrame:CGRectMake(i * buttonWidth + blankWidth * (i + 1), container.bounds.size.height - buttonHeight-(kCustomIOSAlertViewDefaultButtonSpacerHeight/2), buttonWidth, buttonHeight)];
        [closeButton addTarget:self action:@selector(customIOS7dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setTag:i];
        [closeButton setTitle:[buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
        
        closeButton.titleLabel.font =[UIFont fontWithName:@"Microsoft YaHei" size:14];
        [closeButton setTitleColor:[UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.5f] forState:UIControlStateHighlighted];

        
        if (i == 0) {
            [closeButton setTitleColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f] forState:UIControlStateNormal];
            closeButton.backgroundColor = [UIColor colorWithRed:0.0f green:121.0/255.0f blue:1.0f alpha:1.0f];
        }
        [closeButton.layer setBorderColor:[UIColor colorWithRed:210.0/255.0f green:210.0/255.0f blue:210.0/255.0f alpha:1.0f].CGColor];
        [closeButton.layer setBorderWidth:1];
        [closeButton.layer setMasksToBounds:YES];
        [closeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [closeButton.layer setCornerRadius:kCustomIOSAlertViewCornerRadius];

        [container addSubview:closeButton];
    }
}

// Helper function: count and return the dialog's size
- (CGSize)countDialogSize
{
    CGFloat dialogWidth = containerView.frame.size.width;
    CGFloat dialogHeight = containerView.frame.size.height + buttonHeight + buttonSpacerHeight;

    return CGSizeMake(dialogWidth, dialogHeight);
}

// Helper function: count and return the screen's size
- (CGSize)countScreenSize
{
    if (buttonTitles!=NULL && [buttonTitles count] > 0) {
        buttonHeight       = kCustomIOSAlertViewDefaultButtonHeight;
        buttonSpacerHeight = kCustomIOSAlertViewDefaultButtonSpacerHeight;
    } else {
        buttonHeight = 0;
        buttonSpacerHeight = 0;
    }

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;

    // On iOS7, screen width and height doesn't automatically follow orientation
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            CGFloat tmp = screenWidth;
            screenWidth = screenHeight;
            screenHeight = tmp;
        }
    }
    
    return CGSizeMake(screenWidth, screenHeight);
}

#if (defined(__IPHONE_7_0))
// Add motion effects
- (void)applyMotionEffects {

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        return;
    }

    UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                    type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalEffect.minimumRelativeValue = @(-kCustomIOS7MotionEffectExtent);
    horizontalEffect.maximumRelativeValue = @( kCustomIOS7MotionEffectExtent);

    UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                                  type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalEffect.minimumRelativeValue = @(-kCustomIOS7MotionEffectExtent);
    verticalEffect.maximumRelativeValue = @( kCustomIOS7MotionEffectExtent);

    UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects = @[horizontalEffect, verticalEffect];

    [dialogView addMotionEffect:motionEffectGroup];
}
#endif

- (void)dealloc
{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

// Rotation changed, on iOS7
- (void)changeOrientationForIOS7 {

    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGFloat startRotation = [[self valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    CGAffineTransform rotation;
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 270.0 / 180.0);
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 90.0 / 180.0);
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 180.0 / 180.0);
            break;
            
        default:
            rotation = CGAffineTransformMakeRotation(-startRotation + 0.0);
            break;
    }

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         dialogView.transform = rotation;
                         
                     }
                     completion:nil
     ];
    
}

// Rotation changed, on iOS8
- (void)changeOrientationForIOS8: (NSNotification *)notification {

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         CGSize dialogSize = [self countDialogSize];
                         CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
                         self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
                         dialogView.frame = CGRectMake((screenWidth - dialogSize.width) / 2, (screenHeight - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
                     }
                     completion:nil
     ];
    

}

// Handle device orientation changes
- (void)deviceOrientationDidChange: (NSNotification *)notification
{
    // If dialog is attached to the parent view, it probably wants to handle the orientation change itself
    if (parentView != NULL) {
        return;
    }

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        [self changeOrientationForIOS7];
    } else {
        [self changeOrientationForIOS8:notification];
    }
}

// Handle keyboard show/hide changes
- (void)keyboardWillShow: (NSNotification *)notification
{
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        CGFloat tmp = keyboardSize.height;
        keyboardSize.height = keyboardSize.width;
        keyboardSize.width = tmp;
    }

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
					 animations:^{
                         dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
					 }
					 completion:nil
	 ];
}

- (void)keyboardWillHide: (NSNotification *)notification
{
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
					 animations:^{
                         dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
					 }
					 completion:nil
	 ];
}

@end
