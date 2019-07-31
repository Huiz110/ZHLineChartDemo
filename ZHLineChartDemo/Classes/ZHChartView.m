//
//  ZHChartView.m
//  Pods
//
//  Created by Huiz on 2019/7/31.
//	
//

#import "ZHChartView.h"

#import "ZHLineChartCalloutView.h"
#import "ZHLineChartView.h"
#import "ZHChartRightView.h"
#import "ZHChartCollectionViewCell.h"

@interface ZHChartView () <
UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ZHLineChartView *chartView; //折线图及渐变
@property (nonatomic, strong) ZHChartRightView *rightView;

@property (nonatomic, strong) ZHLineChartCalloutView *calloutView;

@end


@implementation ZHChartView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadSubviews];
    }
    return self;
}

#pragma mark - Load Subviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.rightView.frame = CGRectMake(self.bounds.size.width - kLineChartRightMargin + 4.f, 0.f, kLineChartRightMargin - 4.f, kChartViewH + 5.f);
    [self.collectionView sendSubviewToBack:self.chartView];
}

- (void)loadSubviews {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.collectionView];
    [self.collectionView addSubview:self.chartView];
    
    [self addSubview:self.rightView];
}

#pragma mark - Action

- (void)handleTapIndex:(NSInteger)index {
    !self.selectedIndex ?: self.selectedIndex(index);
}

#pragma mark UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZHChartCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZHChartCollectionViewCell class]) forIndexPath:indexPath];
    
    ZHLineChartModel *model = [_dataModels objectAtIndex:indexPath.item];
    [cell reloadWithDate:model.date yPoint:model.yPoint atIndex:indexPath.item];
    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item >= self.dataModels.count) {
        return;
    }
    ZHLineChartModel *model = [_dataModels objectAtIndex:indexPath.item];
    if (model.yPoint == kInvaildYPoint) {
        return;
    }
    NSString *showString = [model.date stringByAppendingFormat:@" %@分", model.score];
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    CGPoint point = CGPointMake(kLineChartMoveW / 2.f, model.yPoint);
    point = [cell convertPoint:point toView:self];
    
    [self.calloutView removeFromSuperview];
    [self.calloutView reloadWithTitle:showString];
    self.calloutView.center = CGPointMake(point.x, self.calloutView.center.y);
    CGRect frame = self.calloutView.frame;
    frame.origin.y = point.y - 3.f - kPointSize / 2.f - frame.size.height; // 3为偏移量
    self.calloutView.frame = frame;
    [self addSubview:self.calloutView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.calloutView.superview) {
        [self.calloutView removeFromSuperview];
    }
}

#pragma mark - Setter、Getter
#pragma mark setter

- (void)setDataModels:(NSArray<ZHLineChartModel *> *)dataModels {
    _dataModels = dataModels;
    
    self.chartView.dataModels = dataModels;
    [self.collectionView reloadData];
    if ([dataModels isKindOfClass:[NSArray class]] && dataModels.count) {
        NSInteger count = [self.collectionView numberOfItemsInSection:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:count - 1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
        __weak typeof(self) weakSelf = self;
        // reload 之后马上执行，cell 还没有布局完成，所以延迟 0.1s
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf collectionView:weakSelf.collectionView didSelectItemAtIndexPath:indexPath]; // 初始选择最后一条
        });
        [self.collectionView sendSubviewToBack:self.chartView];
    }
}

#pragma mark getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        // layout
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kLineChartMoveW, kChartViewH + kLineChartBottomMargin);
        layout.minimumLineSpacing = 0.f;
        layout.minimumInteritemSpacing = 0.f;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0.f, kLineChartMoveW / 2.f, 0.f, 0.f);
        
        // collectionView
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.f, 0.f, [UIScreen mainScreen].bounds.size.width - kLineChartRightMargin + kLineChartMoveW / 2, kChartViewH + kLineChartBottomMargin) collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.bounces = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView registerClass:[ZHChartCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ZHChartCollectionViewCell class])];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (ZHLineChartView *)chartView {
    if (!_chartView) {
        _chartView = [[ZHLineChartView alloc] initWithFrame:CGRectMake(0.f, 0.f, [UIScreen mainScreen].bounds.size.width - kLineChartRightMargin, kChartViewH)];
    }
    return _chartView;
}

- (ZHChartRightView *)rightView {
    if (!_rightView) {
        _rightView = [[ZHChartRightView alloc] init];
    }
    return _rightView;
}

- (ZHLineChartCalloutView *)calloutView {
    if (!_calloutView) {
        _calloutView = [[ZHLineChartCalloutView alloc] init];
    }
    return _calloutView;
}


@end
