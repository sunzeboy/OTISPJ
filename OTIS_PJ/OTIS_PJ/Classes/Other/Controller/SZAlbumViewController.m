//
//  Example7ViewController.m
//  ZLAssetsPickerDemo
//
//  Created by sunzeboy on 15-4-3.
//  Copyright (c) 2015年 com.zixue101.www. All rights reserved.
//

#import "SZAlbumViewController.h"
#import "UIImage+ZLPhotoLib.h"
#import "ZLPhoto.h"
//#import "UIButton+WebCache.h"
#import "NSDate+Extention.h"


@interface SZAlbumViewController () <ZLPhotoPickerBrowserViewControllerDelegate>

@property (nonatomic , strong) NSMutableArray *assets;
@property (nonatomic , strong) NSMutableArray *photos;
@property (weak,nonatomic) UIScrollView *scrollView;

@property (nonatomic , copy) NSString  *fileName;

@end

@implementation SZAlbumViewController
- (BOOL)shouldAutorotate{
    
    return NO;
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(void)createDirectory{

    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:PicDataDir(self.fileName) isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:PicDataDir(self.fileName) withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

-(NSString *)fileName{
    if (_fileName == nil) {
        _fileName = [NSString stringWithFormat:@"%@_%d",[OTISConfig EmployeeID],(int)self.item.ScheduleID];
    }
    return _fileName;
}
-(NSMutableArray *)photos{
    if (_photos == nil) {
        _photos = [NSMutableArray array];
        [_photos addObjectsFromArray:self.assets];

    }
    return _photos;
}

-(NSMutableArray *)assets{

    if (!_assets) {
        
        NSString *path=PicDataDir(self.fileName); // 要列出来的目录
        
        NSFileManager *myFileManager=[NSFileManager defaultManager];
        
        NSDirectoryEnumerator *myDirectoryEnumerator;
        
        myDirectoryEnumerator=[myFileManager enumeratorAtPath:path];
        
        NSLog(@"用enumeratorAtPath:显示目录%@的内容：",path);
        _assets = [NSMutableArray array];
        
        while((path=[myDirectoryEnumerator nextObject])!=nil)
            
        {
            ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
            ZLPhotoAssets *assets = [[ZLPhotoAssets alloc] init];
            NSString *imagePath = [PicDataDir(self.fileName) stringByAppendingPathComponent:path];
            assets.thumbImage = [UIImage imageWithContentsOfFile:imagePath];
            photo.asset = assets;
            photo.url = imagePath;
            [_assets addObject:photo];
        }
    }
    return _assets;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createDirectory];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 这个属性不能少
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    [self.view addSubview:scrollView];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView = scrollView;
    
    // 属性scrollView
    [self reloadScrollView];
}

- (void)reloadScrollView{
    
    // 先移除，后添加
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSUInteger column = 3;
    // 加一是为了有个添加button
    NSUInteger assetCount = self.assets.count + 1;
    
    CGFloat width = self.view.frame.size.width / column;
    for (NSInteger i = 0; i < assetCount; i++) {
        
        NSInteger row = i / column;
        NSInteger col = i % column;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.frame = CGRectMake(width * col, row * width, width, width);
        
        // UIButton
        if (i == self.assets.count){
            // 最后一个Button
            [btn setImage:[UIImage ml_imageFromBundleNamed:@"iconfont-tianjia"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(photoSelecte) forControlEvents:UIControlEventTouchUpInside];
        }else{
            // 如果是本地ZLPhotoAssets就从本地取，否则从网络取
            ZLPhotoPickerBrowserPhoto *photo = [self.assets objectAtIndex:i];
            
            if (photo != nil && [photo.asset isKindOfClass:[ZLPhotoAssets class]]) {
                [btn setImage:[photo.asset thumbImage] forState:UIControlStateNormal];
            }else if(photo != nil && [photo.asset isKindOfClass:[ZLCamera class]]){
                [btn setImage:[photo.asset thumbImage] forState:UIControlStateNormal];
            }
            photo.toView = btn.imageView;
            btn.tag = i;
            [btn addTarget:self action:@selector(tapBrowser:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.scrollView addSubview:btn];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY([[self.scrollView.subviews lastObject] frame]));
}
- (void)reloadScrollView2{
    
    // 先移除，后添加
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSUInteger column = 3;
    // 加一是为了有个添加button
    NSUInteger assetCount = self.photos.count + 1;
    
    CGFloat width = self.view.frame.size.width / column;
    for (NSInteger i = 0; i < assetCount; i++) {
        
        NSInteger row = i / column;
        NSInteger col = i % column;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.frame = CGRectMake(width * col, row * width, width, width);
        
        // UIButton
        if (i == self.photos.count){
            // 最后一个Button
            [btn setImage:[UIImage ml_imageFromBundleNamed:@"iconfont-tianjia"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(photoSelecte) forControlEvents:UIControlEventTouchUpInside];
        }else{
            // 如果是本地ZLPhotoAssets就从本地取，否则从网络取
            ZLPhotoPickerBrowserPhoto *photo = [self.photos objectAtIndex:i];
            
            if (photo != nil && [photo.asset isKindOfClass:[ZLPhotoAssets class]]) {
                [btn setImage:[photo.asset thumbImage] forState:UIControlStateNormal];
            }else if(photo != nil && [photo.asset isKindOfClass:[ZLCamera class]]){
                [btn setImage:[photo.asset thumbImage] forState:UIControlStateNormal];
                //                [btn sd_setImageWithURL:photo.photoURL forState:UIControlStateNormal];
            }
            photo.toView = btn.imageView;
            btn.tag = i;
            [btn addTarget:self action:@selector(tapBrowser:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self.scrollView addSubview:btn];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY([[self.scrollView.subviews lastObject] frame]));
}
#pragma mark - 选择图片
- (void)photoSelecte{
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    pickerVc.maxCount = 10-self.photos.count;
    // Jump AssetsVc
    pickerVc.status = PickerViewShowStatusCameraRoll;
    // Recoder Select Assets
//    pickerVc.selectPickers = self.photos;
    // Filter: PickerPhotoStatusAllVideoAndPhotos, PickerPhotoStatusVideos, PickerPhotoStatusPhotos.
//    pickerVc.photoStatus = PickerPhotoStatusPhotos;
    // Desc Show Photos, And Suppor Camera
    pickerVc.topShowPhotoPicker = YES;
    pickerVc.isShowCamera = YES;
    // CallBack
    __weak typeof(self)weakSelf = self;
    pickerVc.callBack = ^(NSArray<ZLPhotoAssets *> *status){
  
        for (int i=1; i<status.count+1; i++) {
            ZLPhotoAssets *asset = status[i-1];
            
            ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
            photo.photoImage = asset.thumbImage;
            photo.asset = asset;
            NSString *imagePath = [PicDataDir(self.fileName) stringByAppendingPathComponent:[NSString stringWithFormat:@"ITEM%d%@_%d_%@_%@.jpg",i,self.item.UnitNo,(int)self.item.Times,[NSDate currentTimeNOMaohao],[OTISConfig username]]];
            photo.url = imagePath;
            [weakSelf.photos addObject:photo];
            NSString *strName = [NSString stringWithFormat:@"ITEM%d%@_%d_%@_%@.jpg",i,self.item.UnitNo,(int)self.item.Times,[NSDate currentTimeNOMaohao],[OTISConfig username]];
            [self saveImage:photo.photoImage WithName:strName];

        }


        [weakSelf reloadScrollView2];
    };
    [pickerVc showPickerVc:self];
}

- (void)tapBrowser:(UIButton *)btn{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 淡入淡出效果
    // pickerBrowser.status = UIViewAnimationAnimationStatusFade;
    // 数据源/delegate
    pickerBrowser.editing = YES;
    pickerBrowser.photos = self.photos.count>self.assets.count?self.photos:self.assets;
    // 能够删除
    pickerBrowser.delegate = self;
    // 当前选中的值
    pickerBrowser.currentIndex = indexPath.row;
    // 展示控制器
    [pickerBrowser showPickerVc:self];
}

- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSInteger)index{
    if (photoBrowser.photos.count > index) {
        ZLPhotoPickerBrowserPhoto *photo = photoBrowser.photos[index];
        [[NSFileManager defaultManager] removeItemAtPath:photo.url error:nil];
        if (self.photos.count>self.assets.count) {
            [self.photos removeObjectAtIndex:index];
            [self reloadScrollView2];
//            [self reloadScrollView];
            
        }else{
            [self.assets removeObjectAtIndex:index];
//            [self reloadScrollView2];

        }

        self.photos = nil;
        self.assets = nil;
        [self reloadScrollView];
    }
}

//保存图片
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(tempImage, 0.07);
    //图片数据保存到 document
    BOOL ret=[imageData writeToFile:[PicDataDir(self.fileName) stringByAppendingPathComponent:imageName] atomically:NO];
    if (ret) {

    }else{
        SZLog(@"保存图片失败!");
    }
}

@end
