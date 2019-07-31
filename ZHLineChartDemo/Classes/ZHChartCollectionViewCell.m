//
//  ZHChartCollectionViewCell.m
//  Pods
//
//  Created by Huiz on 2019/7/31.
//	
//

#import "ZHChartCollectionViewCell.h"

#import "ZHLineChartConst.h"

@interface ZHChartCollectionViewCell ()

@property (nonatomic, assign, readwrite) NSInteger index;
@property (nonatomic, assign) CGFloat yPoint;

@property (nonatomic, strong) CAShapeLayer *dashLineLayer;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) CAShapeLayer *pointLayer;

@end


@implementation ZHChartCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadSubviews];
    }
    return self;
}

#pragma mark - Public

- (void)reloadWithDate:(NSString *)date yPoint:(CGFloat)y atIndex:(NSInteger)index {
    self.index = index;
    self.yPoint = y;
    
    self.label.text = date;
    
    [self setNeedsLayout];
}

#pragma mark - Load Subviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.pointLayer.hidden = (self.yPoint == kInvaildYPoint);
    self.label.frame = CGRectMake(0.f, self.bounds.size.height - kLineChartBottomMargin + 10.f, self.bounds.size.width, 17.f);
    
    if (self.pointLayer.hidden) {
        return;
    }
    [CATransaction begin];
    //禁用隐式动画
    [CATransaction setDisableActions:YES];
    self.pointLayer.frame = CGRectMake(self.bounds.size.width / 2 - kPointSize / 2,
                                       _yPoint - kPointSize / 2,
                                       kPointSize,
                                       kPointSize);
    [CATransaction commit];
}

- (void)loadSubviews {
    [self.contentView addSubview:self.label];
    [self addDashLineLayerToView:self.contentView];
    [self.contentView.layer addSublayer:self.pointLayer];
}

#pragma mark - Helper

- (void)addDashLineLayerToView:(UIView *)view {
    if (self.dashLineLayer) {
        [self.dashLineLayer removeFromSuperlayer];
    }
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:CGRectMake(0.f, 0.f, kLineChartMoveW, kChartViewH)];
    [shapeLayer setPosition:CGPointMake(kLineChartMoveW / 2.0, kChartViewH / 2.0)];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //设置虚线颜色
    [shapeLayer setStrokeColor:[UIColor lightGrayColor].CGColor];
    //设置虚线宽度
    [shapeLayer setLineWidth:0.5f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //设置虚线的线宽及间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:2], [NSNumber numberWithInt:2], nil]];
    //创建虚线绘制路径
    CGMutablePathRef path = CGPathCreateMutable();
    //设置虚线绘制路径起点
    CGPathMoveToPoint(path, NULL, kLineChartMoveW / 2.f, 0);
    //设置虚线绘制路径终点
    CGPathAddLineToPoint(path, NULL, kLineChartMoveW / 2.f, kChartViewH);
    //设置虚线绘制路径
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    self.dashLineLayer = shapeLayer;
    //添加虚线，这里用 insert，是因为把虚线放在最底层
    [view.layer insertSublayer:self.dashLineLayer atIndex:0];
}

#pragma mark - Setter、Getter
#pragma mark setter


#pragma mark getter

- (UILabel *)label {
    if (!_label) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12.f];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        _label = label;
    }
    return _label;
}

- (CAShapeLayer *)pointLayer {
    if (!_pointLayer) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.lineWidth = 1.f;
        layer.fillColor = [UIColor orangeColor].CGColor;
        layer.strokeColor = [UIColor whiteColor].CGColor;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(kPointSize / 2.f, kPointSize / 2.f) radius:kPointSize / 2.f startAngle:0.f endAngle:M_PI * 2 clockwise:YES];
        layer.path = path.CGPath;
        
        _pointLayer = layer;
    }
    return _pointLayer;
}

@end
