//
//  SZScanErrorViewController.m
//  OTIS_PJ
//
//  Created by zhangyang on 16/6/3.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZScanErrorViewController.h"
#import <INTULocationManager/INTULocationManager.h>



@interface SZScanErrorViewController ()
@property (weak, nonatomic) IBOutlet UILabel *latitude;

@property (weak, nonatomic) IBOutlet UILabel *longitude;
@property (weak, nonatomic) IBOutlet UILabel *currentLocationLabel;

@end

@implementation SZScanErrorViewController
- (BOOL)shouldAutorotate{
    
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tip.text  =self.tips;
    self.tip2.text  =self.tips2;
    self.rCode.text = self.code;
    self.planDate.text = self.planDateStr;
    
}
- (IBAction)confirmClickBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    NSString*lat=[[NSUserDefaults standardUserDefaults] objectForKey:@"userLastLocationLat"];
    NSString*lon=[[NSUserDefaults standardUserDefaults] objectForKey:@"userLastLocationLon"];
    self.currentLocationLabel.text=[NSString stringWithFormat:SZLocal(@"dialog.content.locationing")];
    self.navigationController.toolbarHidden = YES;
    self.currentLocationLabel.text=SZLocal(@"dialog.content.locationing");
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    WEAKSELF;
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock
                                       timeout:10.0
                          delayUntilAuthorized:YES  // This parameter is optional, defaults to NO if omitted
                                         block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                             if (status == INTULocationStatusSuccess) {
                                                 // Request succeeded, meaning achievedAccuracy is at least the requested accuracy, and
                                                 // currentLocation contains the device's current location.
                                                 
                                                 NSNumber *numlongitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
                                                 NSNumber *numlatitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
                                                 
                                                 weakSelf.latitude.text = [NSString stringWithFormat:@"%@:%@",SZLocal(@"dialog.content.longitude"),[numlongitude stringValue]];
                                                 weakSelf.longitude.text = [NSString stringWithFormat:@"%@:%@",SZLocal(@"dialog.content.latitude"),[numlatitude stringValue]];
                                                 self.currentLocationLabel.text=SZLocal(@"dialog.content.Success of the current position coordinates");
                                                 [[NSUserDefaults standardUserDefaults] setObject:self.latitude.text forKey:@"userLastLocationLon"];
                                                 [[NSUserDefaults standardUserDefaults] setObject:self.longitude.text forKey:@"userLastLocationLat"];
                                                 [[NSUserDefaults standardUserDefaults] synchronize];
                                             }
                                             else if (status == INTULocationStatusTimedOut) {
                                                 self.currentLocationLabel.text=SZLocal(@"dialog.content.Gets the GPS position over 10s, using the last acquired location");
                                                 if (lat!=nil&&lon!=nil) {
                                                     weakSelf.latitude.text=lat;
                                                     weakSelf.longitude.text=lon;
                                                 }else{
                                                     self.currentLocationLabel.text=[NSString stringWithFormat:SZLocal(@"dialog.content.Failed to obtain location")];
                                                     weakSelf.latitude.text=SZLocal(@"dialog.content.NOlatitude");
                                                     weakSelf.longitude.text=SZLocal(@"dialog.content.NOlongitude");
                                                 }
                                             }
                                             else {
                                                 self.currentLocationLabel.text=SZLocal(@"dialog.content.Gets the GPS position over 10s, using the last acquired location");
                                                 if (lat!=nil&&lon!=nil) {
                                                     weakSelf.latitude.text=lat;
                                                     weakSelf.longitude.text=lon;
                                                 }else{
                                                     self.currentLocationLabel.text=[NSString stringWithFormat:SZLocal(@"dialog.content.Failed to obtain location")];
                                                     weakSelf.latitude.text=SZLocal(@"dialog.content.NOlatitude");
                                                     weakSelf.longitude.text=SZLocal(@"dialog.content.NOlongitude");
                                                 }
                                             }
                                         }];
}

@end
