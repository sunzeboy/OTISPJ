//
//  WorkingHoursViewController.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/21.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "WorkingHoursViewController.h"

#import "ProductiveViewController.h"
#import "NonProductiveViewController.h"
#import "CheckWorkHourViewController.h"


@interface WorkingHoursViewController ()


@end

@implementation WorkingHoursViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CheckWorkHourViewController *checkVC = [self.childViewControllers objectAtIndex:2];
    [checkVC viewWillAppear:YES];
    
}
-(void)viewDidLoad
{
    [super viewDidLoad];
//    [self setSubTitleView];
    self.title = SZLocal(@"title.WorkingHoursViewController");
}

-(void)setupChildVces
{
    ProductiveViewController *productive = [[ProductiveViewController alloc] init];
    productive.title = SZLocal(@"title.ProductiveViewController");
    [self addChildViewController:productive];
    
    NonProductiveViewController *nonProductive = [[NonProductiveViewController alloc] init];
    nonProductive.title = SZLocal(@"title.NonProductiveViewController");
    [self addChildViewController:nonProductive];
    
    CheckWorkHourViewController *check = [[CheckWorkHourViewController alloc] init];
    check.title = SZLocal(@"title.CheckWorkHourViewController");
    SZLog(@"---%p",check);
    [self addChildViewController:check];
}

- (void) setSubTitleView {
    UIView *subTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 80)];
    subTitleView.backgroundColor = [UIColor colorWithRed:3.0f/255.0f green:96.0f/255.0f blue:169.0f/255.0f alpha:1];
    // 计划日期
    UILabel *plannedDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 80, 20)];
    plannedDateLabel.textColor = [UIColor whiteColor];
    plannedDateLabel.text =[NSString stringWithFormat:@"%@:",SZLocal(@"title.planeDate")];
    
    UILabel *plannedDateText =[[UILabel alloc]initWithFrame:CGRectMake(100, 5, 120, 20)];
    plannedDateText.textColor = [UIColor whiteColor];
    plannedDateText.text = @"2016-04-28";
    // 生产性
    UILabel *productiveLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, 80, 20)];
    productiveLabel.textColor = [UIColor whiteColor];
    productiveLabel.text = [NSString stringWithFormat:@"%@:",SZLocal(@"title.SpaceProductiveViewController")];
    UILabel *productiveText =[[UILabel alloc]initWithFrame:CGRectMake(100, 30, 60, 20)];
    productiveText.textColor = [UIColor colorWithRed:243.0f/255.0f green:172.0f/255.0f blue:0.0f alpha:1.0f];
    productiveText.text = @"12.56";
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 30, 50, 20)];
    unitLabel.textColor = [UIColor whiteColor];
    unitLabel.text = [NSString stringWithFormat:@"(%@)",SZLocal(@"time.hour")];
    // 非生产性
    UILabel *nonProductiveLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 55, 80, 20)];
    nonProductiveLabel.textColor = [UIColor whiteColor];
    nonProductiveLabel.text = [NSString stringWithFormat:@"%@:",SZLocal(@"title.NonProductiveViewController")];
    UILabel *nonProductiveText =[[UILabel alloc]initWithFrame:CGRectMake(100, 55, 60, 20)];
    nonProductiveText.textColor = [UIColor colorWithRed:243.0f/255.0f green:172.0f/255.0f blue:0.0f alpha:1.0f];
    nonProductiveText.text = @"12.56";
    UILabel *unitLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(150, 55, 50, 20)];
    unitLabel2.textColor = [UIColor whiteColor];
    unitLabel2.text = [NSString stringWithFormat:@"(%@)",SZLocal(@"time.hour")];
    
    [subTitleView addSubview:plannedDateLabel];
    [subTitleView addSubview:plannedDateText];
    [subTitleView addSubview:productiveLabel];
    [subTitleView addSubview:productiveText];
    [subTitleView addSubview:unitLabel];
    [subTitleView addSubview:nonProductiveLabel];
    [subTitleView addSubview:nonProductiveText];
    [subTitleView addSubview:unitLabel2];
    [self.view addSubview:subTitleView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
     [super scrollViewDidEndDecelerating:scrollView];
     [self refreshCheckVC];
}

- (void)titleClick:(UIButton *)button{
    [super titleClick:button];
    [self refreshCheckVC];
 
}

-(void)refreshCheckVC{
    for (UIViewController* vc in self.childViewControllers) {
        if ([vc isKindOfClass:[CheckWorkHourViewController class]]) {
            CheckWorkHourViewController* check=(CheckWorkHourViewController*)vc;
            check.sectionRows = nil;
            [check.tableView reloadData];
        }
    }
}

@end
