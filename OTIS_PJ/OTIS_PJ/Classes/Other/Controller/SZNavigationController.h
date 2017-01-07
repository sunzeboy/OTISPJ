//
//  SZNavigationController.h
//  OTIS_PJ
//
//  Created by sunze on 16/4/20.
//  Copyright © 2016年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZNavigationController : UINavigationController

/**
 *  区分是否由工时进入到录入工时／传工时类型（维保传0，工时传对应的laborTypeID）
 */
@property (nonatomic , assign) int laborTypeID;
/**
 *  "工时属性。0:维保操作
 1:本公司生产性工时
 2:本公司非生产性工时
 4:非本公司工时"
 */
@property (nonatomic , assign) int laborProperty;
/**
 *  区分录入工时保存后POP的页面
 */
@property (nonatomic , strong) UIViewController *popVc;

/**
 *  在分摊工时时用到,最后置为nil
 */
//@property (nonatomic, strong) NSArray *elevatorInfo;


@end
