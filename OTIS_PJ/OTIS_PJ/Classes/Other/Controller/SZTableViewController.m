//
//  SZTableViewController.m
//  OTIS_PJ
//
//  Created by sunze on 16/4/21.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SZTableViewController.h"
#import "SZTableViewCell.h"
#import "UIView+Extension.h"


@interface SZTableViewController ()<UISearchBarDelegate>

@property (nonatomic , strong) UIImageView *iView;

@end

@implementation SZTableViewController
- (BOOL)shouldAutorotate{
    
    return NO;
}
-(UISearchBar *)bar{
    if (!_bar) {
        _bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _bar.placeholder = @"工地名／电梯编号";
        _bar.delegate = self;
    }
    return _bar;
}

-(UIImageView *)iView{
    if (_iView == nil) {
        _iView = [[UIImageView alloc] initWithImage:ImageNamed(@"defult")];
        _iView.size = _iView.image.size;
        _iView.contentMode = UIViewContentModeScaleAspectFit;
        _iView.center =CGPointMake(self.view.center.x, self.view.center.y-_iView.image.size.height);
        [self.view addSubview:_iView];
    }
    return _iView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
    
    
}

-(void)initToolBar{};

-(void)setDataArray:(NSMutableArray *)dataArray{

    if (dataArray == nil) {
        [self iView];
    }else{
        [_iView removeFromSuperview];
        _iView = nil;
    }

}

-(void)setAllSelect:(BOOL)allSelect{
    _allSelect =allSelect;

}

- (void)setupTableView
{
    // 设置内边距
    CGFloat top = CXTitilesViewY + CXTitilesViewH;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, 64, 0);
    // 设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
////    [self.view endEditing:YES];
//}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SZTableViewCell *cell;
    cell = [SZTableViewCell cellWithTableView:tableView];
//    cell.item = self.dataArray[indexPath.row];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
