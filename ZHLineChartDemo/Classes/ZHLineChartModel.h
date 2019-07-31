//
//  ZHLineChartModel.h
//  Pods
//
//  Created by Huiz on 2019/7/30.
//	
//

#import <Foundation/Foundation.h>

@interface ZHLineChartModel : NSObject

/// 日期
@property (nonatomic, strong, readonly) NSString *date;

/// 分数
@property (nonatomic, strong, readonly) NSString *score;

/// 计算所得的 y 坐标
@property (nonatomic, assign, readonly) CGFloat yPoint;

/// 测试数据
+ (NSArray <ZHLineChartModel *>*)testDataArray;

@end
