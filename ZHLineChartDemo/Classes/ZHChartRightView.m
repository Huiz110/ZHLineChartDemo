//
//  ZHChartRightView.m
//  Pods
//
//  Created by Huiz on 2019/7/31.
//	
//

#import "ZHChartRightView.h"

#import "ZHLineChartConst.h"

static CGFloat const kLeftLabelW = 9.f;
static CGFloat const kRightLabelW = 28.f;

@interface ZHChartRightItemView : UIView

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation ZHChartRightItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.leftLabel.frame = CGRectMake(0.f, 0.f, kLeftLabelW, self.bounds.size.height);
    self.rightLabel.frame = CGRectMake(kLeftLabelW, 0.f, kRightLabelW, self.bounds.size.height);
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"-";
        label.font = [UIFont systemFontOfSize:15.f];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentRight;
        _leftLabel = label;
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:15.f];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentRight;
        _rightLabel = label;
    }
    return _rightLabel;
}

@end

@interface ZHChartRightView ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end


@implementation ZHChartRightView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadSubviews];
    }
    return self;
}

#pragma mark - Load Subviews

- (void)loadSubviews {
    [self.layer addSublayer:self.gradientLayer];
    NSArray *dataArr = @[@"100", @"90", @"80", @"70", @"60"];
    for (NSInteger i = 0; i < dataArr.count; i++) {
        ZHChartRightItemView *itemView = [[ZHChartRightItemView alloc] init];
        itemView.rightLabel.text = dataArr[i];
        itemView.frame = CGRectMake(0.f, 11.f + (21.f + 40.f) * i, kLeftLabelW + kRightLabelW, 21.f);
        [self addSubview:itemView];
    }
}

#pragma mark - Getter

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = @[(__bridge id)[UIColor colorWithWhite:1.f alpha:0.f].CGColor, (__bridge id)[UIColor colorWithWhite:1.f alpha:1.f].CGColor];
        //        _gradientLayer.locations = @[@0.f, @0.9f];
        _gradientLayer.frame = CGRectMake(0.f, 0.f, 17.f, kChartViewH + kPointSize);
        _gradientLayer.startPoint = CGPointMake(0.f, 0.5f);
        _gradientLayer.endPoint = CGPointMake(1.f, 0.5f);
    }
    return _gradientLayer;
}


@end
