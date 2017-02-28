//
//  MDSVTModel.m
//  OTIS_PJ
//
//  Created by 杜亚伟 on 2017/2/28.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

#import "MDSVTModel.h"

@implementation MDSVTModel

/*
 
 @property(nonatomic,strong) NSArray* ElapsedMinutes;
 
 @property(nonatomic,strong) NSArray* NumberOfRuns;
 
 @property(nonatomic,strong) NSArray* SCN;
 
 @property(nonatomic,strong) NSArray* SoftwareBaselineVersion;
 
 */

+(instancetype)mdSvtModelWithDic:(NSDictionary*)dic{
    
    MDSVTModel* model = [[MDSVTModel alloc] init];
    
    model.ElapsedMinutes=dic[@"ElapsedMinutes"];
    model.NumberOfRuns=dic[@"NumberOfRuns"];
    model.SCN=dic[@"SCN"];
    model.SoftwareBaselineVersion=dic[@"SoftwareBaselineVersion"];
    model.ControllerEvents=dic[@"ControllerEvents"];
    
    model.detailModelArray=[NSMutableArray array];
    
    for (int i =0; i< model.ControllerEvents.count;i++) {
        
        NSDictionary* dic = model.ControllerEvents[i];
        
        if (i==(model.ControllerEvents.count-1)) {
            [MDSVTLastModel mdSvtLastModelWithDic:dic];
        }else{
            
            MDSVTModelDetail* detailModel = [MDSVTModelDetail mdSvtModelDetailWithDic:dic];
            if (detailModel) {
                [model.detailModelArray addObject:detailModel];
            }
        }
    }
    return model;
}



@end


@implementation MDSVTModelDetail

+(instancetype)mdSvtModelDetailWithDic:(NSDictionary*)dic{
    MDSVTModelDetail* detailModel=[[MDSVTModelDetail alloc] init];
    [detailModel setValuesForKeysWithDictionary:dic];
    return detailModel;
}

@end


/*
 @property (nonatomic,copy) NSString* CarPosition;
 @property (nonatomic,copy) NSString* Counter;
 @property (nonatomic,copy) NSString* ElapsedTime;
 @property (nonatomic,strong) NSArray* EventNumber;
 @property (nonatomic,copy) NSString* EventSubcode;
 @property (nonatomic,copy) NSString* TextOfEvent;
 
 @property (nonatomic,copy) NSString* IsEventLogComplete;
 @property (nonatomic,strong) NSArray* ErrorData;
 
 @property(nonatomic,strong)MDSVTModelDetail* detailModel;
 
 */

@implementation MDSVTLastModel

+(instancetype)mdSvtLastModelWithDic:(NSDictionary*)dic{
    
    MDSVTLastModel* lastModelDetail=[[MDSVTLastModel alloc] init];
    lastModelDetail.CarPosition=dic[@"CarPosition"];
    lastModelDetail.detailModel = [MDSVTModelDetail mdSvtModelDetailWithDic:dic[@"ControllerEvents"]];
    lastModelDetail.Counter=dic[@"Counter"];
    lastModelDetail.ElapsedTime=dic[@"ElapsedTime"];
    lastModelDetail.ErrorData=dic[@"ErrorData"];
    lastModelDetail.EventNumber=dic[@"EventNumber"];
    lastModelDetail.EventSubcode=dic[@"EventSubcode"];
    lastModelDetail.IsEventLogComplete=dic[@"IsEventLogComplete"];
    lastModelDetail.TextOfEvent=dic[@"TextOfEvent"];
    return lastModelDetail;
}

@end
