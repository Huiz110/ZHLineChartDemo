//
//  ZHChartCollectionViewCell.h
//  Pods
//
//  Created by Huiz on 2019/7/31.
//	
//

#import <UIKit/UIKit.h>

@interface ZHChartCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign, readonly) NSInteger index;

- (void)reloadWithDate:(NSString *)date yPoint:(CGFloat)y atIndex:(NSInteger)index;

@end
