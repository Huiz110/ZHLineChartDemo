//
//  ZHChartView.h
//  Pods
//
//  Created by Huiz on 2019/7/31.
//	
//

#import <UIKit/UIKit.h>

#import "ZHLineChartConst.h"

#import "ZHLineChartModel.h"

@interface ZHChartView : UIView

@property (nonatomic, copy) void (^selectedIndex)(NSInteger index);

@property (nonatomic, strong) NSArray <ZHLineChartModel *>*dataModels;

@end
