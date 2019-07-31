//
//  ZHViewController.m
//  ZHLineChartDemo
//
//  Created by zhanghui on 07/30/2019.
//  Copyright (c) 2019 zhanghui. All rights reserved.
//

#import "ZHViewController.h"

#import <ZHLineChartDemo/ZHChartView.h>

@interface ZHViewController ()

@end

@implementation ZHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    ZHChartView *chartView = [[ZHChartView alloc] init];
    chartView.bounds = CGRectMake(0.f, 0.f, self.view.bounds.size.width, kChartViewH);
    chartView.center = self.view.center;
    
    [self.view addSubview:chartView];
    
    chartView.dataModels = [ZHLineChartModel testDataArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
