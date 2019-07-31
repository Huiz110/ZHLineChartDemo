//
//  ZHLineChartCalloutView.m
//  Pods
//
//  Created by Huiz on 2019/7/30.
//	
//

#import "ZHLineChartCalloutView.h"

static CGFloat const kArrowX = 5.f;

@interface ZHLineChartCalloutView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) CAShapeLayer *traiLayer;

@end


@implementation ZHLineChartCalloutView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadSubviews];
    }
    return self;
}

#pragma mark - Load Subviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(0.f, 0.f, self.bounds.size.width, 21.f);
    
    [CATransaction begin];
    //禁用隐式动画
    [CATransaction setDisableActions:YES];
    //隐式动画
    self.traiLayer.frame = CGRectMake(CGRectGetMidX(self.bounds) - kArrowX, 20.f, kArrowX * 2, 6.f);
    //提交事务
    [CATransaction commit];
}

- (void)loadSubviews {
    [self addSubview:self.titleLabel];
    [self.layer addSublayer:self.traiLayer];
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowRadius = 4.f;
    self.layer.shadowOpacity = 0.26f;
}

#pragma mark - Public

- (void)reloadWithTitle:(NSString *)title {
    self.titleLabel.text = title;
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(150.f, 21.f)];
    if (size.width < 90.f) {
        size.width = 90.f;
    }
    self.bounds = CGRectMake(0.f, 0.f, size.width + 6.f * 2, 26.f);
    
    [self setNeedsLayout];
}

#pragma mark - Setter、Getter
#pragma mark setter


#pragma mark getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor orangeColor];
        label.font = [UIFont systemFontOfSize:14.f];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (CAShapeLayer *)traiLayer {
    if (!_traiLayer) {
        _traiLayer = [[CAShapeLayer alloc] init];
        _traiLayer.frame = CGRectMake(CGRectGetMidX(self.bounds) - kArrowX, 20.f, kArrowX * 2, 6.f);
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointZero];
        [path addLineToPoint:CGPointMake(2 * kArrowX, 0)];
        [path addLineToPoint:CGPointMake(kArrowX, 6.f)];
        [path addLineToPoint:CGPointZero];
        [path closePath];
        _traiLayer.path = path.CGPath;
        _traiLayer.fillColor = [UIColor orangeColor].CGColor;
    }
    return _traiLayer;
}


@end
