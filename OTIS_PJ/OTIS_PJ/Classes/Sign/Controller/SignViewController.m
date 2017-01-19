//
//  SignViewController.m
//  OTIS_PJ
//
//  Created by ousingi on 16/4/26.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import "SignViewController.h"
#import "SZCustomerSignElevatorItemViewController.h"
#import "CustomIOSAlertView.h"
#import "SZModuleQueryTool.h"
#import "SZBottomOperationView.h"
#import "UIView+Extension.h"

@interface SignViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (strong,nonatomic) UITableView *tableView;

@property(strong,nonatomic) NSMutableArray *array;

@property(strong,nonatomic) NSMutableArray *signArray;

@property(assign,nonatomic) BOOL clicked;

@property(assign,nonatomic) NSInteger selectCount;
// 计算相同buildingNo电梯的个数。
@property(assign,nonatomic) NSInteger buildingNoCount;

@property(nonatomic,strong) UILabel * subLabel;

@property (nonatomic , strong)  SZBottomOperationView *operationView;

@property (nonatomic , strong) UISearchBar *bar;

@property (nonatomic , assign) BOOL isHidden;

@property (nonatomic, strong) NSMutableArray *sousuoArray;

@property(nonatomic,weak)UIImageView* backImageView;
//@property (nonatomic , strong) UIImageView *iView;


@end

@implementation SignViewController
// 设定一次最多可以签字的电梯个数
CGFloat const MaxSignElevatorNum = 20;

- (BOOL)shouldAutorotate{
    
    return NO;
}
-(UISearchBar *)bar{
    if (!_bar) {
        _bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _bar.placeholder = [NSString stringWithFormat:@"%@/%@",SZLocal(@"dialog.title.Site name"),SZLocal(@"dialog.title.Elevator number")];
        _bar.delegate = self;
    }
    return _bar;
}
- (NSMutableArray *)sousuoArray
{
    if (_sousuoArray ==nil) {
        _sousuoArray = [NSMutableArray array];
    }
    
    return _sousuoArray;
}


-(SZBottomOperationView *)operationView{
    
    if(_operationView ==nil){
        _operationView =[SZBottomOperationView loadSZBottomOperationView];
        _operationView.frame = CGRectMake(0,SCREEN_HEIGHT-OTIS_BottomOperationH-5, SCREEN_WIDTH, OTIS_BottomOperationH+5);
        [_operationView.confirmBtn setTitle:SZLocal(@"btn.title.confirm") forState:0];
        //[_operationView.confirmBtn setBackgroundColor:[UIColor lightGrayColor]];
        [self.view addSubview:_operationView];
    }
    return _operationView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sousuoArray = [NSMutableArray arrayWithArray:self.array];
    
    self.title = SZLocal(@"title.signViewController");
    self.view.backgroundColor =[UIColor whiteColor];
    [self setUpTableView];
    [self setSubTitle];
    [self initNav];
    [self iView];
    
    [self operationView];
    //unexpected footer line hidden
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    WEAKSELF
    self.operationView.confirmActBlock = ^(UIButton *btn){
        [weakSelf selectMum];
        if (weakSelf.selectCount) {
            [weakSelf confirm];
        }else{
            CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                            dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                         dialogContents:SZLocal(@"dialog.content.selectOne")
                                                                                          dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
            alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
                [alertView close];
            };
            [alertView show];
        }
    };
    self.operationView.allSelectActBlock = ^(UIButton *btn){
        if (self.sousuoArray.count==0) {
            btn.enabled = NO;
        }else{
            btn.enabled = YES;
            [weakSelf selectAll];
        }
    };
    self.operationView.searchActBlock = ^(UIButton * scanBtn) {
        [weakSelf search];
    };
}

-(void)viewWillAppear:(BOOL)animated{
    _buildingNoCount = 0;
    if(self.clicked){
        _clicked = NO;
        self.operationView.allSelectBtn.selected = NO;
    }
    [self.operationView.confirmBtn setTitle:SZLocal(@"btn.title.confirm") forState:UIControlStateNormal];
    [self.operationView.allSelectBtn setTitle:SZLocal(@"btn.title.allSelect") forState:UIControlStateNormal];

    _array = nil;
    self.sousuoArray = [NSMutableArray arrayWithArray:[SZModuleQueryTool querySignList]];
    [self.tableView reloadData];
}

-(void)setUpTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+CXTitilesViewH+40-5, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource =self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 150, 0);
}

//设置数据（from plist）
-(NSMutableArray *)array
{
    if(_array ==nil){
        _array =[NSMutableArray arrayWithArray:[SZModuleQueryTool querySignList]];
        //        if(_array.count == 0){
        //            [self iView];
        //        }
    }
    self.selectCount = 0;
    return _array;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.sousuoArray.count!=0) {
        self.backImageView.hidden=YES;
        self.operationView.allSelectBtn.userInteractionEnabled = YES;
        self.operationView.confirmBtn.userInteractionEnabled = YES;
        self.operationView.searchBtn.userInteractionEnabled = YES;
        [self.operationView.allSelectBtn setImage:[UIImage imageNamed:@"btn_allSelect_blue"] forState:0];
        [self.operationView.confirmBtn setImage:[UIImage imageNamed:@"btn_confirm"] forState:0];
        [self.operationView.searchBtn setImage:[UIImage imageNamed:@"btn_find"] forState:0];
    }else{
        self.backImageView.hidden=NO;
        self.operationView.allSelectBtn.userInteractionEnabled = NO;
        self.operationView.confirmBtn.userInteractionEnabled = NO;
        self.operationView.searchBtn.userInteractionEnabled = NO;
        [self.operationView.allSelectBtn setImage:[UIImage imageNamed:@"btn_allSelect_gray"] forState:0];
        [self.operationView.confirmBtn setImage:[UIImage imageNamed:@"btn_confirm_gray"] forState:0];
        [self.operationView.searchBtn setImage:[UIImage imageNamed:@"btn_find_gray"] forState:0];
        
    }
    return self.sousuoArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SZSignTableViewCell *cell;
    cell = [SZSignTableViewCell cellWithTableView:tableView];
    cell.szsign = self.sousuoArray[indexPath.row];
    //设置代理
    cell.delegate = self;
    //
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 81;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell点击响应，按钮显示选择状态
    SZSignTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell btnClick:cell.signView];
}

// 设置副标题
- (void) setSubTitle{
    UIView *subTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+CXTitilesViewH-5, SCREEN_WIDTH, 40)];
    subTitleView.backgroundColor = [UIColor colorWithRed:3.0f/255.0f green:96.0f/255.0f blue:169.0f/255.0f alpha:1.0f];
    UIImageView *signListImage =[[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 20, 25)];
    signListImage.image = [UIImage imageNamed:@"lbl_list"];
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 8, 150, 25)];
    NSString * laber1 = SZLocal(@"title.unSignElevatorList");
    subTitleLabel.text =laber1;
    subTitleLabel.textColor = [UIColor lightGrayColor];
    subTitleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    //
    [subTitleView addSubview:signListImage];
    [subTitleView addSubview:subTitleLabel];
    subTitleView.backgroundColor =[UIColor colorWithRed:0.96470588235294119 green:0.95686274509803926 blue:0.92549019607843142 alpha:1];
    [self.view addSubview:subTitleView];
}

//设置title右侧按钮
-(void)initNav{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"查找框内图标"] landscapeImagePhone:[UIImage imageNamed:@"查找框内图标"] style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    
    self.navigationItem.rightBarButtonItem = item;
}



//选择条数计算方法
- (void)selectMum {
    _selectCount = 0;
    for (SZFinalMaintenanceUnitItem *sa in self.sousuoArray){
        if(sa.selected){
            _selectCount +=1;
        }
    }
    
    if (self.selectCount) {
        [self.operationView.confirmBtn setTitle:[NSString stringWithFormat:@"%@(%ld)",SZLocal(@"btn.title.confirm"), (long)self.selectCount]  forState:0];
        //[self.operationView.confirmBtn setBackgroundColor:RGB(45, 122, 255)];
        self.operationView.confirmBtn.enabled = YES;
        
    }else{
        [self.operationView.confirmBtn setTitle:SZLocal(@"btn.title.confirm") forState:0];
        //[self.operationView.confirmBtn setBackgroundColor:[UIColor lightGrayColor]];
        // self.operationView.confirmBtn.enabled = NO;
        self.operationView.confirmBtn.enabled = YES;
    }
    
}

//全选方法
-(void)selectAll{

    // 可签字电梯的个数
    NSInteger iSelect = 0;
    // 取得未签字电梯列表中第一部电梯的BuildingNo
    SZFinalMaintenanceUnitItem * s1 = self.sousuoArray[0];
    NSInteger buildingNo = s1.BuildingNo;
    //循环判断是否有选中的电梯，如果有将buildiingNo改为选中的。
    for(SZFinalMaintenanceUnitItem *sa in self.sousuoArray){
        if (sa.selected) {
            buildingNo = sa.BuildingNo;
            break;
        }
    }
    // 取得相同BuildingNo的电梯的个数
    for(SZFinalMaintenanceUnitItem *sa in self.sousuoArray){
        if(buildingNo == sa.BuildingNo){
            iSelect++;
        }
    }
    
    if(self.clicked){
        _clicked = NO;
        for(SZFinalMaintenanceUnitItem *gb in self.sousuoArray){
            gb.selected = NO;
        }
        self.selectCount = 0;
        _buildingNoCount = 0;
        [self.operationView.allSelectBtn setTitle:SZLocal(@"btn.title.allSelect") forState:0];
    }else{
        if (iSelect > MaxSignElevatorNum) {
            [self alertShowMaxElevator];
        }
        _clicked = YES;
        for(SZFinalMaintenanceUnitItem *gb in self.sousuoArray){
            if(buildingNo == gb.BuildingNo && _buildingNoCount < MaxSignElevatorNum){
                if (!gb.selected) {
                    gb.selected = YES;
                    _buildingNoCount++;
                }
            }
        }
        SZLog(@"_buildingNoCount:=%ld", (long)_buildingNoCount);
        self.selectCount = self.sousuoArray.count;
        [self.operationView.allSelectBtn setTitle:SZLocal(@"btn.title.noSelect") forState:0];
    }
    //选中条数重显示
    [self selectMum];
    [self.tableView reloadData];
}
//确认方法
-(void)confirm{
    //编辑被选中签字对象数组
    _signArray = [NSMutableArray arrayWithCapacity:1];
    for(SZFinalMaintenanceUnitItem *sa in self.sousuoArray){
        if (sa.selected){
            [_signArray addObject:sa];
        }
    }
    if (self.signArray.count > 0) {
        SZCustomerSignElevatorItemViewController *controller =[[SZCustomerSignElevatorItemViewController alloc] initWithNSArray:self.signArray index:0];
        controller.signArray = _signArray;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        //至少选择一个电梯
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                        dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                     dialogContents:SZLocal(@"dialog.content.selectOne")
                                                                                      dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
        alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
            [alertView close];
        };
        [alertView show];
    }
}
-(void)search{
    self.isHidden = !self.isHidden;
}



-(void)setIsHidden:(BOOL)isHidden{
    _isHidden = isHidden;
    if (!isHidden) {
        self.tableView.tableHeaderView = nil;
    }else{
        self.bar.text = @"";
        self.tableView.tableHeaderView = self.bar;
        // self.bar.placeholder = @"工地名／地址名";
        self.bar.placeholder = [NSString stringWithFormat:@"%@/%@",SZLocal(@"dialog.title.Site name"),SZLocal(@"dialog.title.Elevator number")];

        CGPoint offect = self.tableView.contentOffset;
        offect.y = - self.tableView.contentInset.top;
        [self.tableView setContentOffset:offect animated:YES];
    }
    
}
//点击cell，判断是否与已选电梯为同用户
-(BOOL) selectCheak:(SZFinalMaintenanceUnitItem *)item
{
    NSInteger  noSelected = 0;
    
    for(SZFinalMaintenanceUnitItem *sa in self.sousuoArray){
        if (sa.selected){
            noSelected = sa.BuildingNo;
            break;
        }
    }
    BOOL isSame = false;
    if(noSelected == item.BuildingNo){
        // 相同BuidingNo时
        isSame = true;
        if (!item.selected) {
            _buildingNoCount++;
        } else {
            _buildingNoCount--;
            _clicked = NO;
            [self.operationView.allSelectBtn setTitle:SZLocal(@"btn.title.allSelect") forState:0];
            
        }
        if (_buildingNoCount > MaxSignElevatorNum) {
            _buildingNoCount--;
            [self alertShowMaxElevator];
            SZLog(@"_buildingNoCount:=%ld", (long)_buildingNoCount);
            return false;
        }
    }else if( noSelected == 0){
        //初次选中时
        isSame = true;
        _buildingNoCount++;
    }else {
        [self alertShow];
        SZLog(@"_buildingNoCount:=%ld", (long)_buildingNoCount);
        return false;
    }
    SZLog(@"_buildingNoCount:=%ld", (long)_buildingNoCount);
    return isSame;
}
//不同用户弹出信息
-(void)alertShow{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                 dialogContents:SZLocal(@"dialog.content.notSameUser")
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        [alertView close];
    };
    [alertView show];
    [_bar resignFirstResponder];
}
-(void)alertShowMaxElevator {
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initAlertDialogVieWithImageName:@""
                                                                                    dialogTitle:SZLocal(@"dialog.title.tip")
                                                                                 dialogContents:SZLocal(@"dialog.content.One time batch sign up to 20 sets of elevators")
                                                                                  dialogButtons:[NSMutableArray arrayWithObjects:SZLocal(@"btn.title.confirm"), nil]];
    alertView.onButtonTouchUpInside = ^(CustomIOSAlertView *alertView, int buttonIndex){
        [alertView close];
    };
    [alertView show];
    [_bar resignFirstResponder];
}
//选中条数重显示
- (void)calcSelected{
    //全选状态时，把全选状态关闭
    if(self.clicked){
        _clicked = NO;
        self.operationView.allSelectBtn.selected = NO;
        _buildingNoCount = 0;
    }
    [self selectMum];
}
//无数据
-(void)iView{
    UIImageView *iView = [[UIImageView alloc] initWithImage:ImageNamed(@"defult")];
    iView.size = iView.image.size;
    iView.contentMode = UIViewContentModeScaleAspectFit;
    iView.center = self.view.center;
    iView.hidden=YES;
    self.backImageView=iView;
    [self.view addSubview:self.backImageView];
    
}


#pragma mark - UISearchBarDelegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self.sousuoArray removeAllObjects];
    
    NSString *studentUp  = [searchText uppercaseString];
    if ([searchText isEqualToString: @""]) self.sousuoArray = [NSMutableArray arrayWithArray:self.array];
    for (SZFinalMaintenanceUnitItem *unitItem in self.array) {
        if ([unitItem.BuildingName containsString:searchText]||[unitItem.UnitNo containsString:searchText]||[unitItem.UnitNo containsString:studentUp]) {
            [self.sousuoArray addObject:unitItem];
        }
    }
    [self.tableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}


@end
