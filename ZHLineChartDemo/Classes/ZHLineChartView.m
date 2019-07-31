//
//  ZHLineChartView.m
//  Pods
//
//  Created by Huiz on 2019/7/30.
//	
//

#import "ZHLineChartView.h"

#import "ZHLineChartConst.h"
#import "ZHLineChartModel.h"

@interface ZHLineChartView ()

@end


@implementation ZHLineChartView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.zPosition = -1.f;
    }
    return self;
}

#pragma mark - Load Subviews

- (void)makeDraw {
    CGFloat moveStartY = kChartViewH;
    
    UIBezierPath *aPath = [UIBezierPath bezierPath];//填充镀层
    UIBezierPath *aPathLine = [UIBezierPath bezierPath];//线
    
    //所有经过的坐标点，画线
    //    NSInteger startI = 0;
    
    BOOL ignoreZeroPoint = YES;
    for (int i = 0; i < _dataModels.count; i++) {
        CGFloat yPoint = _dataModels[i].yPoint;
        if (ignoreZeroPoint && yPoint == kInvaildYPoint) { //忽略前面为0的点
            continue;
        }
        CGFloat xPoint = kLineChartMoveStartX + i * kLineChartMoveW;
        if (ignoreZeroPoint) {
            //设置开始的坐标点
            //            startI = i;
            [aPath moveToPoint:CGPointMake(xPoint, moveStartY)]; //镀层要从 x 轴开始画，再添加第一个点坐标
            [aPath addLineToPoint:CGPointMake(xPoint, yPoint)];
            [aPathLine moveToPoint:CGPointMake(xPoint, yPoint)];
            ignoreZeroPoint = NO; //开始画点，不再忽略为0的点
        } else {
            [aPath addLineToPoint:CGPointMake(xPoint, yPoint)];
            [aPathLine addLineToPoint:CGPointMake(xPoint, yPoint)];
        }
    }
    
    //收边
    CGFloat lineW = kLineChartMoveStartX + (_dataModels.count - 1) * kLineChartMoveW;
    [aPath addLineToPoint:CGPointMake(lineW, moveStartY)];
    [aPath closePath];
    
    // 前面为 0 的点灰色蒙层
    //    CAGradientLayer *grayLayer = [CAGradientLayer layer];
    //    grayLayer.colors = @[(__bridge id)[[UIColor yx_grayAssistContentColor] alpha:0.f].CGColor, (__bridge id)[[UIColor yx_colorWithHexString:@"D1D1D1"] alpha:0.4f].CGColor];
    //    grayLayer.frame = CGRectMake(kServiceScoreMoveStartX, 0.f, startI * kServiceScoreMoveW, moveStartY);
    //    grayLayer.startPoint = CGPointZero;
    //    grayLayer.endPoint = CGPointMake(1.f, 1.f);
    //    [self.layer addSublayer:grayLayer];
    
    
    [self addGradientLayerWithPath:aPath];
    [self addLineLayerWithPath:aPathLine];
    [self addXLineLayer];
}

- (void)addXLineLayer {
    CGFloat lineW = kLineChartMoveStartX + (_dataModels.count - 1) * kLineChartMoveW;
    //x 轴
    UIBezierPath *xLinePath = [UIBezierPath bezierPath];
    [xLinePath moveToPoint:CGPointMake(kLineChartMoveStartX - kLineChartMoveW / 2.f, kChartViewH)];
    [xLinePath addLineToPoint:CGPointMake(kLineChartMoveStartX + lineW, kChartViewH)];
    
    CAShapeLayer *xLineLayer = [CAShapeLayer layer];
    xLineLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    xLineLayer.lineWidth = 0.5f;
    xLineLayer.path = xLinePath.CGPath;
    xLineLayer.zPosition = -2;
    [self.layer addSublayer:xLineLayer];
}

- (void)addLineLayerWithPath:(UIBezierPath *)path {
    //折线
    CAShapeLayer *shapelayerLine = [CAShapeLayer layer];
    //设置边框颜色，就是上边画的，线的颜色
    shapelayerLine.strokeColor = [[UIColor orangeColor] CGColor];
    //设置填充颜色 如果不需要[UIColor clearColor]
    shapelayerLine.fillColor = [[UIColor clearColor] CGColor];
    //就是这句话在关联彼此（UIBezierPath和CAShapeLayer）：
    shapelayerLine.path = path.CGPath;
    [self.layer addSublayer:shapelayerLine];
}

- (void)addGradientLayerWithPath:(UIBezierPath *)path {
    //获取总共的长度
    CGFloat lineW = kLineChartMoveStartX + (_dataModels.count - 1) * kLineChartMoveW;
    
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    //设置边框颜色，就是上边画的，线的颜色
    shapelayer.strokeColor = [[UIColor orangeColor] CGColor];
    //设置填充颜色
    shapelayer.fillColor = [[UIColor orangeColor] CGColor];
    //就是这句话在关联彼此（UIBezierPath和CAShapeLayer）：
    shapelayer.path = path.CGPath;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[[UIColor orangeColor] colorWithAlphaComponent:0.4f].CGColor, (__bridge id)[[UIColor orangeColor] colorWithAlphaComponent:0.f].CGColor];
    //    gradientLayer.locations = @[@0.f, @0.5f];
    gradientLayer.startPoint = CGPointMake(0.5, 0.f);
    gradientLayer.endPoint = CGPointMake(0.5, 1.f);
    gradientLayer.shadowPath = path.CGPath;
    gradientLayer.frame = CGRectMake(0, 0, lineW, kChartViewH);
    gradientLayer.mask = shapelayer;
    [self.layer addSublayer:gradientLayer];
}

#pragma mark - Setter

- (void)setDataModels:(NSArray<ZHLineChartModel *> *)dataModels {
    _dataModels = dataModels;
    
    [self makeDraw];
}


@end
