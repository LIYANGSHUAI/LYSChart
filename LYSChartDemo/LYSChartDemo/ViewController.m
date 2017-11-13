//
//  ViewController.m
//  ChartDemo
//
//  Created by HENAN on 17/8/4.
//  Copyright © 2017年 李阳帅. All rights reserved.
//

#import "ViewController.h"
#import "LYSChartHistogram.h"
#import "LYSChartLine.h"
#import "LYSChartAloneLine.h"
@interface ViewController ()

@property (nonatomic,strong)LYSChartHistogram *baseView;
@property (nonatomic,strong)LYSChartLine *baseLine;
@property (nonatomic,strong)LYSChartAloneLine *moreLine;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    _baseView = [[LYSChartHistogram alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 200)];
    _baseView.precisionScale = 1000;
    _baseView.yAxisPrecisionScale = 3;
    _baseView.isShowBenchmarkLine = YES;
    _baseView.benchmarkLineStyle.benchmarkValue = @0.5;
    [_baseView reloadData];
    [self.view addSubview:_baseView];
    
    
    _baseLine = [[LYSChartLine alloc] initWithFrame:CGRectMake(0, 230, self.view.frame.size.width, 200)];
    _baseLine.precisionScale = 1000;
    _baseLine.yAxisPrecisionScale = 3;
    _baseLine.isCurve = YES;
    _baseLine.isShowBenchmarkLine = YES;
    _baseLine.benchmarkLineStyle.benchmarkValue = @0.5;
    [_baseLine reloadData];
    [self.view addSubview:_baseLine];
    
    _moreLine = [[LYSChartAloneLine alloc] initWithFrame:CGRectMake(0, 440, self.view.frame.size.width, 200)];
    _moreLine.precisionScale = 1000;
    _moreLine.yAxisPrecisionScale = 1;
    _moreLine.isCurve = NO;
    _moreLine.isShowBenchmarkLine = YES;
    _moreLine.isPercent = YES;
    _moreLine.benchmarkLineStyle.benchmarkValue = @0.5;
    [_moreLine reloadData];
    [self.view addSubview:_moreLine];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _baseView.valueData = @[@"0.807",@"0.354",@"0.902",@"0.504",@"0.709"];
    _baseView.columnData = @[@"1月",@"2月",@"3月",@"4月",@"5月"];
    _baseLine.valueData = @[@"0.807",@"0.354",@"0.902",@"0.504",@"0.709"];
    _baseLine.columnData = @[@"1月",@"2月",@"3月",@"4月",@"5月"];
    _moreLine.valueData = @[@"0.807",@"0.354",@"0.902",@"0.504",@"0.709"];
    _moreLine.columnData = @[@"1月",@"2月",@"3月",@"4月",@"5月"];
    
    
    [_baseView reloadData];
    [_baseLine reloadData];
    [_moreLine reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
