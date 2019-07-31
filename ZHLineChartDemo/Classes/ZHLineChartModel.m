//
//  ZHLineChartModel.m
//  Pods
//
//  Created by Huiz on 2019/7/30.
//	
//

#import "ZHLineChartModel.h"

#import "ZHLineChartConst.h"

@interface ZHLineChartModel ()

@property (nonatomic, strong, readwrite) NSString *date;
@property (nonatomic, strong, readwrite) NSString *score;
@property (nonatomic, assign, readwrite) CGFloat yPoint;

@end

@implementation ZHLineChartModel

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - YYModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    [self setupYPoint];
    
    return YES;
}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
        @"score" : @"totalScore",
    };
}

#pragma mark - Helper

- (void)setupYPoint {
    CGFloat score = [self.score intValue];
    CGFloat point = kItemTopMargin + kItemHeight / 2.f;
    
    /**
     高度计算，100-60分，按比例计算，小于 60 分时，小于 60 的区域按比例计算
     */
    CGFloat height = 4 * (kItemHeight + kItemSpace); // 60 - 100 的总高度
    if (score >= 60.f && score < 100) {
        height = (100.f - score) / 40.f * height; // 按比例下降高度
        point += height;
    } else if (score < 60) {
        // 小于 60 分，最后一段按比例计算 Y 值
        CGFloat tempH = kItemHeight / 2.f + kItemSpace;
        tempH = (60.f - score) / 60.f * tempH;
        point += tempH + height;
    }
    
    self.yPoint = point;
}


#pragma mark - Test

+ (NSArray <ZHLineChartModel *>*)testDataArray {
    NSArray *dateArr = @[@"08-29",@"08-30",@"08-31",@"09-01",@"09-02",@"09-03",@"09-04",@"09-05",@"09-06",@"09-07",@"09-08",@"09-09"];
    NSArray *scoreArr = @[@"20",@"60",@"40",@"55",@"100",@"80",@"90",@"70",@"77",@"30",@"80",@"88"];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSInteger i = 0; i < dateArr.count; i++) {
        ZHLineChartModel *model = [[ZHLineChartModel alloc] init];
        model.score = scoreArr[i];
        model.date = dateArr[i];
        [model setupYPoint];
        
        [arr addObject:model];
    }
    
    return arr.copy;
}


@end
