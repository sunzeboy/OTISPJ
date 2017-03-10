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
#import "MDSVTModel.h"
#import "SZMaintenanceCheckItem.h"
@interface SZTableViewController ()<UISearchBarDelegate>

@property (nonatomic , strong) UIImageView *iView;


/**
 MD 属性
 */



//MD需要测试的controller的三个维保项
@property(nonatomic,strong) NSArray* controllerProjectArray;

//Drive 包含这个数组中的元素时打❌
@property(nonatomic,strong) NSArray* driveErrorCodeArray;

//GECB=controller  包含这个数组中的元素时 打❌
@property(nonatomic,strong) NSArray* controllerErrorCodeArray;


@end

@implementation SZTableViewController

-(NSArray*)driveProjectArray{
    
    if (!_driveProjectArray) {
        _driveProjectArray = [NSArray arrayWithObjects:@"A-1_6",@"A-2_5",@"A-3_4", nil];
    }
    return _driveProjectArray;
}


-(NSArray*)controllerProjectArray{
    
    if (!_controllerProjectArray) {
        _controllerProjectArray = [NSArray arrayWithObjects:@"A-1_18",@"A-1_19",@"A-1_25", nil];
    }
    return _controllerProjectArray;
}


-(NSArray*)driveErrorCodeArray{
    
    if (!_driveErrorCodeArray) {
        _driveErrorCodeArray = [NSArray arrayWithObjects:@[@"524",@"504",@"529",@"530",@"502",@"507",@"508",@"509",@"510",@"514"],@[@"32",@"33",@"34",@"37",@"38",@"728",@"526"],@[@"400",@"401",@"408",@"409",@"418",@"419"], nil];
    }
    return _driveErrorCodeArray;
}

-(NSArray*)controllerErrorCodeArray{
    if (!_controllerErrorCodeArray) {
        _controllerErrorCodeArray = [NSArray arrayWithObjects:@[@"0211",@"0212"],@[@"0301",@"0304",@"307",@"0102", @"0103",@"0312",@"0313"],@[@"0102",@"0237",@"0238",@"0302",@"0306"], nil];
    }
    return _controllerErrorCodeArray;
}

-(NSString*)setControllerMdsvtModel:(NSInteger)index{
    
    NSArray* tempArray = self.controllerErrorCodeArray[index];
    if ([self.svtModel.controllerModel.IsEventLogComplete isEqualToString:@"True"]) {
        for (MDcontrollerDetail* model in self.svtModel.controllerModel.ControllerEvents) {
            if ([tempArray containsObject:model.EventNumber]) {
                return @"1";
            }
        }
        return @"0";
    }else{
        for (MDcontrollerDetail* model in self.svtModel.controllerModel.ControllerEvents) {
            if ([tempArray containsObject:model.EventNumber]) {
                return @"1";
            }
        }
        return @"-1";
    }
}

-(NSString*)setDriveMdsvtModel:(NSInteger)index{
    
    NSArray* tempArray = self.driveErrorCodeArray[index];
    
    if ([self.svtModel.Drive.IsEventLogComplete isEqualToString:@"True"]) {
        
        for (MDSVTEventModel* model in self.svtModel.Drive.SavedDriveEvents) {
            if ([tempArray containsObject:model.EventNumber]) {
                return @"1";
            }
        }
        
        for (MDSVTEventModel* model in self.svtModel.Drive.DriveEvents) {
            if ([tempArray containsObject:model.EventNumber]) {
                return @"1";
            }
        }
        return @"0";
    }else{
        for (MDSVTEventModel* model in self.svtModel.Drive.SavedDriveEvents) {
            if ([tempArray containsObject:model.EventNumber]) {
                return @"1";
            }
        }
        for (MDSVTEventModel* model in self.svtModel.Drive.DriveEvents) {
            if ([tempArray containsObject:model.EventNumber]) {
                return @"1";
            }
        }
        return @"-1";
    }
}


-(void)operateControllerAutom:(SZMaintenanceCheckItem *)itemAll{
    
    if ([self.controllerProjectArray containsObject:itemAll.ItemCode]) {
        
        NSInteger index = [self.controllerProjectArray indexOfObject:itemAll.ItemCode];
        NSLog(@"%@=================********%@",itemAll.ItemCode,[self setControllerMdsvtModel:index]);
        NSString* result = [self setControllerMdsvtModel:index];
        
        switch (result.integerValue) {
            case 0:
            {
                itemAll.automType = 1;
                itemAll.isHiden = NO;
            }
                break;
            case 1:
            {
                itemAll.automType = 2;
                itemAll.isHiden = NO;
            }
                break;
            case -1:
            {
                itemAll.automType = 3;
                itemAll.isHiden = NO;
            }
                break;
                
            default:
                break;
        }
    }else{
        itemAll.isHiden = YES;
    }
}

-(void)operateDriveAutom:(SZMaintenanceCheckItem *)itemAll{
    
    if ([self.driveProjectArray containsObject:itemAll.ItemCode]) {
        
        NSInteger index = [self.driveProjectArray indexOfObject:itemAll.ItemCode];
        NSLog(@"-------------********%@",[self setDriveMdsvtModel:index]);
        NSString* result = [self setDriveMdsvtModel:index];
        
        switch (result.integerValue) {
            case 0:
            {
                itemAll.automType = 1;
                itemAll.isHiden = NO;
            }
                break;
            case 1:
            {
                itemAll.automType = 2;
                itemAll.isHiden = NO;
            }
                break;
            case -1:
            {
                itemAll.automType = 3;
                itemAll.isHiden = NO;
            }
                break;
                
            default:
                break;
        }
    }else{
        itemAll.isHiden = YES;
    }
    
}



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
