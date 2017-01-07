//
//  SZManHourFillViewController.m
//  OTIS_PJ
//
//  Created by zhangyang on 16/5/27.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZManHourFillViewController.h"
#import "SZNormalWorkHoursTableViewCell.h"
#import "SZPuiWorkHoursTableViewCell.h"

@interface SZManHourFillViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation SZManHourFillViewController
- (BOOL)shouldAutorotate{
    
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SZLocal(@"title.WorkingHoursViewController");
    [self setSubTitleViewWithName:SZLocal(@"dialog.content.SpaceRecall") subTitleDate:@"2016-05-11" totalHour:@"0"];
    [self setDateViewWithDate:@"2016/05/11"];
    [self setManHourTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
// Height 80
- (void) setSubTitleViewWithName : (NSString *)subTitleName subTitleDate :(NSString *)subTitleDate  totalHour : (NSString *)totalHour {
    UIView *subTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 80)];
    subTitleView.backgroundColor = [UIColor colorWithRed:3.0f/255.0f green:96.0f/255.0f blue:169.0f/255.0f alpha:1.0f];
    // 设置副标题
    UILabel *subTitleText = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, SCREEN_WIDTH, 20)];
    subTitleText.text =subTitleName;
    subTitleText.font =[UIFont fontWithName:@"Microsoft YaHei" size:30.0f];
    subTitleText.textAlignment = NSTextAlignmentLeft;
    subTitleText.textColor = [UIColor whiteColor];
    // 设置日期
    UILabel *subDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 80, 20)];
    subDateLabel.text =[NSString stringWithFormat:@"%@：",SZLocal(@"btn.title.SpaceDate")];
    subDateLabel.font =[UIFont fontWithName:@"Microsoft YaHei" size:12.0f];
    [subDateLabel  setFont:[UIFont fontWithName:@"Microsoft YaHei" size:2.0f]];
    subDateLabel.textAlignment = NSTextAlignmentLeft;
    subDateLabel.textColor = [UIColor whiteColor];
    // 日期内容
    UILabel *subDateText = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, SCREEN_WIDTH - 80, 20)];
    subDateText.text =subTitleDate;
    subDateText.font =[UIFont fontWithName:@"Microsoft YaHei" size:13];
    subDateText.textAlignment = NSTextAlignmentLeft;
    subDateText.textColor = [UIColor whiteColor];
    
    // 总工时控件
    UILabel *totalHourLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 55, 80, 20)];
    totalHourLabel.text =[NSString stringWithFormat:@"%@：",SZLocal(@"time.Total working hours")];
    totalHourLabel.font =[UIFont fontWithName:@"Microsoft YaHei" size:13];
    totalHourLabel.textAlignment = NSTextAlignmentLeft;
    totalHourLabel.textColor = [UIColor whiteColor];
    // 总工时内容
    UILabel *totalHourText = [[UILabel alloc] initWithFrame:CGRectMake(100, 55, SCREEN_WIDTH - 80, 20)];
    totalHourText.text =totalHour;
    totalHourText.font =[UIFont fontWithName:@"Microsoft YaHei" size:13];
    totalHourText.textAlignment = NSTextAlignmentLeft;
    totalHourText.textColor = [UIColor colorWithRed:243.0f/255.0f green:172.0f/255.0f blue:0.0f alpha:1.0f];
    
    [subTitleView addSubview:subTitleText];
    [subTitleView addSubview:subDateLabel];
    [subTitleView addSubview:subDateText];
    [subTitleView addSubview:totalHourLabel];
    [subTitleView addSubview:totalHourText];
    
    [self.view addSubview:subTitleView];
}
// 设置可选日期View 50
- (void) setDateViewWithDate : (NSString *)date {
    UIView *dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 144, SCREEN_WIDTH, 50)];
    dateView.backgroundColor = [UIColor colorWithRed:244.0f/255.0f green:249.0f/255.0f blue:254.0f/255.0f alpha:1.0f];
    
    // 时间图片
    UIImage* image = [UIImage imageNamed:@"date.png"];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(15, 15, 20, 20);
    
    // 竖线
    UILabel * lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 35, 3, 15)];
    lineLabel.backgroundColor = [UIColor grayColor];
    
    // 时间
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, 100, 20)];
    dateLabel.text = date;
    [dateView addSubview:imageView];
    [dateView addSubview:lineLabel];
    [dateView addSubview:dateLabel];
    
    [self.view addSubview:dateView];
}
// 设置TableView
- (void) setManHourTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 194, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 80 -50)];
    tableView.delegate = self;
    tableView.dataSource = self;
    // tableView.rowHeight = 108;
    [self.view addSubview:tableView];
    
}
//返回每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1 创建可重用的自定义的cell
    SZNormalWorkHoursTableViewCell *cell = [SZNormalWorkHoursTableViewCell cellWithTableView:tableView];
    if (indexPath.row == 2) {
        SZPuiWorkHoursTableViewCell *cell =[SZPuiWorkHoursTableViewCell cellWithTableView:tableView];
        return cell;
    }
    //3 返回
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        return 147;
    }
    return 108;
}
@end
