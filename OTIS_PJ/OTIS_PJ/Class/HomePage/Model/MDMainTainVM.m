//
//  MDMainTainVM.m
//  MDProject
//
//  Created by 杜亚伟 on 2017/2/15.
//  Copyright © 2017年 杜亚伟. All rights reserved.
//

#import "MDMainTainVM.h"
#import "MDMatainModel.h"
@implementation MDMainTainVM


-(instancetype)init{
    
    if (self=[super init]) {
        self.dataArray=[NSMutableArray array];
    }
    return self;
}



-(void)setTableRowHeight:(NSMutableArray*)dataArray{
    
    for (MDMatainModel* model in dataArray) {
        
        NSDictionary *attrDict1 = @{ NSFontAttributeName: [UIFont systemFontOfSize:16.0],
                                     NSForegroundColorAttributeName: [UIColor whiteColor] };
        CGRect rect1=[model.subTitle boundingRectWithSize:CGSizeMake(MDScreenW-155, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrDict1 context:nil];
        
        NSDictionary *attrDict2 = @{ NSFontAttributeName: [UIFont systemFontOfSize:16.0],
                                     NSForegroundColorAttributeName: [UIColor whiteColor] };
        CGRect rect2=[model.content boundingRectWithSize:CGSizeMake(MDScreenW-90, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrDict2 context:nil];
        
        CGFloat maxTopHeight=MAX(20, rect1.size.height);
        model.rowHeight=5+5+maxTopHeight+rect2.size.height;
//        NSLog(@"%f-----%@------%f",maxTopHeight,model.title,rect1.size.height);
    }
}




@end
