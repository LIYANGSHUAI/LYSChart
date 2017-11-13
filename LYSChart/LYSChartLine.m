/*
    非常感谢大家使用!如果大家在使用过程中,发现bug,或者希望有什么改进的地方尽管提出来,
    我会尽一切可能满足你们的需求
    Github地址:https://github.com/LYSBuildCode/LYSChart
    简书地址:http://www.jianshu.com/p/2efd439f936c
    如果有什么疑问,可以在简书下面留言,我会及时对您的问题做出处理
    如果喜欢,给个赞,或者给个星,谢谢
 */

#import "LYSChartLine.h"
/* 创建位置点 */

#define POINT(A,B) CGPointMake(A,B)

/* 计算两个点直接距离 */

#define TWOPOINTSPACING(A,B) sqrt(pow(A.x - B.x,2) + pow(A.y - B.y, 2))

@interface LYSChartLine ()

/* 图表左上角点 */

@property (nonatomic,assign)CGPoint boxLeftTopPoint;

/* 图表左下角点 */

@property (nonatomic,assign)CGPoint boxLeftBottomPoint;

/* 图表右上角点 */

@property (nonatomic,assign)CGPoint boxRightTopPoint;

/* 图表右下角点 */

@property (nonatomic,assign)CGPoint boxRightBottomPoint;

/* 画布左上角点 */

@property (nonatomic,assign)CGPoint canvasLeftTopPoint;

/* 画布左下角点 */

@property (nonatomic,assign)CGPoint canvasLeftBottomPoint;

/* 画布右上角点 */

@property (nonatomic,assign)CGPoint canvasRightTopPoint;

/* 画布右下角点 */

@property (nonatomic,assign)CGPoint canvasRightBottomPoint;

/* 当前视图大小 */

@property (nonatomic,assign)CGSize size;

/* y轴数据计算后的真实间隔 */

@property (nonatomic,assign)CGFloat space_value;

/* 用于存放计算后Y轴上显示的数据,通常会有小数位数, 是否显示百分比的区别 */

@property (nonatomic,strong)NSArray *rowData;


/* 用于柱状图和折线图坐标轴偏移 */

@property (nonatomic,assign)BOOL isLineChart;

/* 用于存放柱状图 */

@property (nonatomic,strong)NSMutableArray *chartLayerAry;

@end

@implementation LYSChartLine

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /* 翻转视图坐标轴, 使(0,0)点出于视图左下角 */
        
        self.layer.geometryFlipped = YES;
        
        /* 设置默认属性 */
        
        [self customDefaultParams];
        
    }
    return self;
}

#pragma mark - 获 取 四 个 顶 到 位 置 -

/* 重写get方法,以确保获取的图表点坐标是真实有效的 */

- (CGPoint)boxLeftTopPoint
{
    return POINT(self.edgeInsets.left, self.size.height - self.edgeInsets.top);
}
- (CGPoint)boxLeftBottomPoint
{
    return POINT(self.edgeInsets.left, self.edgeInsets.bottom);
}
- (CGPoint)boxRightBottomPoint
{
    return POINT(self.size.width - self.edgeInsets.right, self.edgeInsets.bottom);
}
- (CGPoint)boxRightTopPoint
{
    return POINT(self.size.width - self.edgeInsets.right, self.size.height - self.edgeInsets.top);
}

#pragma mark - 获 取 画 布 四 个 顶 到 位 置 -

/* 重写get方法, 以确保获取的画布点坐标是真实有效的 */

- (CGPoint)canvasLeftTopPoint
{
    return POINT(self.boxLeftTopPoint.x + self.canvasEdgeInsets.left, self.boxLeftTopPoint.y - self.canvasEdgeInsets.top);
}
- (CGPoint)canvasLeftBottomPoint
{
    return POINT(self.boxLeftBottomPoint.x + self.canvasEdgeInsets.left, self.boxLeftBottomPoint.y + self.canvasEdgeInsets.bottom);
}
- (CGPoint)canvasRightBottomPoint
{
    return POINT(self.boxRightBottomPoint.x - self.canvasEdgeInsets.right, self.boxRightBottomPoint.y + self.canvasEdgeInsets.bottom);
}
- (CGPoint)canvasRightTopPoint
{
    return POINT(self.boxRightTopPoint.x - self.canvasEdgeInsets.right, self.boxRightTopPoint.y - self.canvasEdgeInsets.top);
}

#pragma mark - 获 取 X Y 间 距 值 -

/* 设置默认的XY轴数据间隔值 */

- (CGFloat)rowSpace
{
    if (_isAutoYSpacing) {
        _rowSpace = TWOPOINTSPACING(self.canvasLeftTopPoint, self.canvasLeftBottomPoint) / _row;
    }
    return _rowSpace;
}
- (CGFloat)columnSpace
{
    if (_isAutoXSpacing) {
        if (_isLineChart) {
            _columnSpace = TWOPOINTSPACING(self.canvasRightBottomPoint, self.canvasLeftBottomPoint) / (_column - 1);
        }else{
            _columnSpace = TWOPOINTSPACING(self.canvasRightBottomPoint, self.canvasLeftBottomPoint) / _column;
        }
    }
    return _columnSpace;
}

#pragma mark - 设 置 默 认 属 性 -

- (void)customDefaultParams
{
    
    _size = self.frame.size;
    
    // 图表边距
    _edgeInsets = UIEdgeInsetsMake(20, 40, 20, 20);
    
    // 画布边距
    _canvasEdgeInsets = UIEdgeInsetsMake(20, 20, 0, 20);
    
    // 默认是5行5列
    _row = 5;
    _column = 5;
    
    // 设置默认数据值
    _columnData = @[];
    _valueData = @[];
    
    // 坐标轴样式
    LYSAxisStyle *xdefaulyAxisStyle = [[LYSAxisStyle alloc] init];
    xdefaulyAxisStyle.lineWidth = 1;
    xdefaulyAxisStyle.lineColor = [UIColor colorWithRed:67 / 255.0 green:155 / 255.0 blue:231 / 255.0 alpha:1];
    _xStyle = xdefaulyAxisStyle;
    LYSAxisStyle *ydefaulyAxisStyle = [[LYSAxisStyle alloc] init];
    ydefaulyAxisStyle.lineWidth = 1;
    ydefaulyAxisStyle.lineColor = [UIColor colorWithRed:67 / 255.0 green:155 / 255.0 blue:231 / 255.0 alpha:1];
    _yStyle = ydefaulyAxisStyle;
    
    // 辅助线样式
    LYSGuideStyle *horizontaldefaultGuideStyle = [[LYSGuideStyle alloc] init];
    horizontaldefaultGuideStyle.lineWidth = 0.5;
    horizontaldefaultGuideStyle.lineColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1];
    _horizontalStyle = horizontaldefaultGuideStyle;
    
    LYSGuideStyle *verticaldefaultGuideStyle = [[LYSGuideStyle alloc] init];
    verticaldefaultGuideStyle.lineWidth = 0.5;
    verticaldefaultGuideStyle.lineColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1];
    _verticalStyle = verticaldefaultGuideStyle;
    _isShowVerticalGuide = NO;
    _isShowHorizontalGuide = YES;
    
    // 网格样式
    LYSGuideStyle *defaultGriddingStyle = [[LYSGuideStyle alloc] init];
    defaultGriddingStyle.lineWidth = 0.5;
    defaultGriddingStyle.lineColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1];
    _griddingStyle = defaultGriddingStyle;
    _isShowGriddingGuide = NO;
    
    // 是否是百分比
    _isPercent = NO;
    _isHundredPercent = NO;
    
    // 精度
    _precisionScale = 1;
    _yAxisPrecisionScale = 2;
    
    // 坐标轴数据样式
    LYSAxisDataStyle *xdefaultAxisDataStyle = [[LYSAxisDataStyle alloc] init];
    xdefaultAxisDataStyle.fontSize = 10;
    xdefaultAxisDataStyle.fontColor = [UIColor blackColor];
    _xAxisDataStyle = xdefaultAxisDataStyle;
    
    LYSAxisDataStyle *ydefaultAxisDataStyle = [[LYSAxisDataStyle alloc] init];
    ydefaultAxisDataStyle.fontSize = 10;
    ydefaultAxisDataStyle.fontColor = [UIColor blackColor];
    _yAxisDataStyle = ydefaultAxisDataStyle;
    
    // 是否坐标轴偏移
    _isLineChart = YES;
    
    // 是否自适应X间距
    _isAutoXSpacing = YES;
    
    // 是否自适应Y间距
    _isAutoYSpacing = YES;
    
    LYSAxisDataStyle *yValuedefaultAxisDataStyle = [[LYSAxisDataStyle alloc] init];
    yValuedefaultAxisDataStyle.fontSize = 10;
    yValuedefaultAxisDataStyle.fontColor = [UIColor blackColor];
    _yValueDataStyle = yValuedefaultAxisDataStyle;
    
    _isShowBenchmarkLine = NO;
    LYSBenchmarkLineStyle *benchmarkLineStyle = [[LYSBenchmarkLineStyle alloc] init];
    benchmarkLineStyle.lineColor = [UIColor redColor];
    benchmarkLineStyle.lineWidth = 1;
    benchmarkLineStyle.fontSize = 9;
    benchmarkLineStyle.fontColor = [UIColor redColor];
    _benchmarkLineStyle = benchmarkLineStyle;
    
    _lineChartFillColor = [UIColor colorWithRed:67 / 255.0 green:155 / 255.0 blue:231 / 255.0 alpha:0.5];
    _lineChartColor = [UIColor colorWithRed:67 / 255.0 green:155 / 255.0 blue:231 / 255.0 alpha:1];
    _lineChartWidth = 1;
    _lineChartDotRadius = 2;
    _lineChartDotColor = [UIColor colorWithRed:67 / 255.0 green:155 / 255.0 blue:231 / 255.0 alpha:1];
    
    _isCurve = NO;
    
}
#pragma mark - 刷 新 页 面 -
- (void)reloadData
{
    // 绘制前清空画布
    for (CALayer *layer in self.layer.sublayers.mutableCopy) {[layer removeFromSuperlayer];}
    
    // 绘制XY轴
    [self drawXYAxis];
    
    // 绘制辅助线
    [self drawGuide];
    
    // 计算数据
    [self calculateValue];
    
    // 绘制坐标轴下标值
    [self drawAxisData];

    // 画图
    [self drawLineChart];
    
}

#pragma mark - 画图 -
- (void)drawLineChart
{
    CGFloat scale = self.rowSpace / _space_value;
    
    if (!_valueData || [_valueData count] == 0) {
        return;
    }
    if (!_columnData || [_columnData count] == 0) {
        return;
    }
    
    if (_isShowBenchmarkLine) {
        
        CAShapeLayer *benchmarkLine = [self horizontalLine:POINT(self.boxLeftBottomPoint.x, self.canvasLeftBottomPoint.y + [_benchmarkLineStyle.benchmarkValue floatValue] * scale)
                                                     width:TWOPOINTSPACING(self.boxLeftBottomPoint, self.boxRightBottomPoint)
                                                 linecolor:_benchmarkLineStyle.lineColor
                                                lineHeight:_benchmarkLineStyle.lineWidth];
        
        [self.layer addSublayer:benchmarkLine];
        
        CGRect rect = [self rectWithSize:CGSizeMake(_edgeInsets.left, self.rowSpace)
                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_benchmarkLineStyle.fontSize]}
                                  forStr:[NSString stringWithFormat:@"%@",_benchmarkLineStyle.benchmarkValue]];
        
        CATextLayer *ytext = [self textLayer:POINT(self.boxLeftBottomPoint.x - _yStyle.lineWidth, self.canvasLeftBottomPoint.y + [_benchmarkLineStyle.benchmarkValue floatValue] * scale)
                                        text:[NSString stringWithFormat:@"%@",_benchmarkLineStyle.benchmarkValue]
                                   fontColor:_benchmarkLineStyle.fontColor
                                    fontSize:_benchmarkLineStyle.fontSize
                                     boxSize:CGSizeMake(_edgeInsets.left, rect.size.height)];
        
        ytext.anchorPoint = CGPointMake(1, 0.5);
        ytext.alignmentMode = kCAAlignmentRight;
        [self.layer addSublayer:ytext];
        
    }
    
    _chartLayerAry = [NSMutableArray array];
    
    LYSAnimationLayer *animationLayer = [self lineChartWith:self.canvasLeftBottomPoint
                                                      width:TWOPOINTSPACING(self.canvasRightBottomPoint, self.canvasLeftBottomPoint)
                                                     height:TWOPOINTSPACING(self.canvasLeftTopPoint, self.canvasLeftBottomPoint)];
    
    animationLayer.anchorPoint = CGPointMake(0, 0);
    animationLayer.fillColor = _lineChartFillColor.CGColor;
    animationLayer.zPosition = 999999;
    [self.layer addSublayer:animationLayer];
    
    [_chartLayerAry addObject:animationLayer];
    
    NSMutableArray *tempAry = [NSMutableArray array];
    
    for (int i = 0; i < [_valueData count]; i++) {
        [tempAry addObject:@0];
    }
    
    [animationLayer animationSetPath:^CGPathRef(CADisplayLink *displayLink) {
        BOOL isSuccess = YES;
        for (int i = 0; i < [_valueData count]; i++) {
            CGFloat speed = ([_valueData[i] floatValue] - [tempAry[i] floatValue]) / 10;
            tempAry[i] = @([tempAry[i] floatValue] + speed);
            if (speed > 1.0 / 1000) {
                isSuccess = NO;
            }
        }
        if (isSuccess) {
            [displayLink invalidate];
        }
        UIBezierPath *path = [UIBezierPath bezierPath];
        if (_isCurve == NO) {
            [path moveToPoint:POINT(0, 0)];
            for (int i = 0; i < [_valueData count]; i++) {
                [path addLineToPoint:POINT(self.columnSpace * i, [tempAry[i] floatValue] * scale)];
            }
            [path addLineToPoint:POINT(TWOPOINTSPACING(self.canvasRightBottomPoint, self.canvasLeftBottomPoint), 0)];
            [path addLineToPoint:POINT(0, 0)];
        }else{
            [path moveToPoint:POINT(0, [tempAry[0] floatValue] * scale)];
            for (int i = 0; i < [tempAry count]; i++) {
                if (i + 1 < [tempAry count]) {
                    CGPoint point1 = CGPointMake(self.columnSpace * i + self.columnSpace * 0.5,[tempAry[i] floatValue] * scale);
                    CGPoint point2 = CGPointMake(self.columnSpace * i + self.columnSpace * 0.5,[tempAry[i + 1] floatValue] * scale);
                    [path addCurveToPoint:POINT(self.columnSpace * (i + 1), [tempAry[i + 1] floatValue] * scale) controlPoint1:point1 controlPoint2:point2];
                }
            }
            [path addLineToPoint:POINT(TWOPOINTSPACING(self.canvasRightBottomPoint, self.canvasLeftBottomPoint), 0)];
            [path addLineToPoint:POINT(0, 0)];
            [path addLineToPoint:POINT(0, [tempAry[0] floatValue] * scale)];
        }
        return path.CGPath;
    }];
    
    LYSAnimationLayer *animationLayerLine = [self lineChartWith:self.canvasLeftBottomPoint width:TWOPOINTSPACING(self.canvasRightBottomPoint, self.canvasLeftBottomPoint) height:TWOPOINTSPACING(self.canvasLeftTopPoint, self.canvasLeftBottomPoint)];
    animationLayerLine.anchorPoint = CGPointMake(0, 0);
    animationLayerLine.strokeColor = _lineChartColor.CGColor;
    animationLayerLine.fillColor = [UIColor clearColor].CGColor;
    animationLayerLine.zPosition = 999999;
    [self.layer addSublayer:animationLayerLine];
    [_chartLayerAry addObject:animationLayerLine];
    NSMutableArray *tempAryLine = [NSMutableArray array];
    for (int i = 0; i < [_valueData count]; i++) {
        [tempAryLine addObject:@0];
    }
    [animationLayerLine animationSetPath:^CGPathRef(CADisplayLink *displayLink) {
        BOOL isSuccess = YES;
        for (int i = 0; i < [_valueData count]; i++) {
            CGFloat speed = ([_valueData[i] floatValue] - [tempAryLine[i] floatValue]) / 10;
            tempAryLine[i] = @([tempAryLine[i] floatValue] + speed);
            if (speed > 1.0 / 1000) {
                isSuccess = NO;
            }
        }
        if (isSuccess) {
            [displayLink invalidate];
            for (int i = 0; i < [_valueData count]; i++) {
                CGRect rect = [self rectWithSize:CGSizeMake(_edgeInsets.left, self.rowSpace) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_yValueDataStyle.fontSize]} forStr:_valueData[i]];
                CATextLayer *ytext = [self textLayer:POINT(self.columnSpace * i, [tempAryLine[i] floatValue] * scale + 2) text:_valueData[i] fontColor:_yValueDataStyle.fontColor fontSize:_yValueDataStyle.fontSize boxSize:CGSizeMake(_edgeInsets.left, rect.size.height)];
                ytext.anchorPoint = CGPointMake(0.5, 0);
                ytext.alignmentMode = kCAAlignmentCenter;
                [animationLayerLine addSublayer:ytext];
                
                CAShapeLayer *dot = [self dotWith:POINT(self.columnSpace * i, [tempAryLine[i] floatValue] * scale) radius:_lineChartDotRadius color:_lineChartColor];
                dot.anchorPoint = POINT(0.5, 0.5);
                [animationLayerLine addSublayer:dot];
            }
        }
        UIBezierPath *path = [UIBezierPath bezierPath];
        if (_isCurve == NO) {
            [path moveToPoint:POINT(0, [tempAryLine[0] floatValue] * scale + _lineChartWidth)];
            for (int i = 0; i < [_valueData count]; i++) {
                [path addLineToPoint:POINT(self.columnSpace * i, [tempAryLine[i] floatValue] * scale)];
            }
        }else{
            [path moveToPoint:POINT(0, [tempAryLine[0] floatValue] * scale)];
            for (int i = 0; i < [tempAryLine count]; i++) {
                if (i + 1 < [tempAryLine count]) {
                    CGPoint point1 = CGPointMake(self.columnSpace * i + self.columnSpace * 0.5,[tempAryLine[i] floatValue] * scale);
                    CGPoint point2 = CGPointMake(self.columnSpace * i + self.columnSpace * 0.5,[tempAryLine[i + 1] floatValue] * scale);
                    [path addCurveToPoint:POINT(self.columnSpace * (i + 1), [tempAryLine[i + 1] floatValue] * scale) controlPoint1:point1 controlPoint2:point2];
                }
            }
        }
        return path.CGPath;
    }];
    
}


#pragma mark - 绘 制 坐 标 轴 数 据

- (void)drawAxisData
{
    if (_columnData && [_columnData count]) {
        
        for (int i = 0; i < [_columnData count]; i++) {
            
            CGRect rect = [self rectWithSize:CGSizeMake(self.columnSpace, _edgeInsets.bottom)
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_xAxisDataStyle.fontSize]}
                                      forStr:_columnData[i]];
            
            CGFloat x = 0;
            if (_isLineChart) {
                x = self.canvasLeftBottomPoint.x + (i * self.columnSpace);
            }else{
                x = self.canvasLeftBottomPoint.x + ((i + 1) * self.columnSpace) - (self.columnSpace * 0.5);
            }
            
            CATextLayer *xtext = [self textLayer:POINT(x, self.boxLeftBottomPoint.y - _xStyle.lineWidth)
                                            text:_columnData[i]
                                       fontColor:_xAxisDataStyle.fontColor
                                        fontSize:_xAxisDataStyle.fontSize
                                         boxSize:CGSizeMake(rect.size.width, rect.size.height)];
            
            xtext.anchorPoint = CGPointMake(0.5, 1);
            [self.layer addSublayer:xtext];
            
        }
    }
    
    if (_rowData && [_rowData count]) {
        
        for (int i = 0; i < [_rowData count]; i++) {
            
            CGRect rect = [self rectWithSize:CGSizeMake(_edgeInsets.left, self.rowSpace)
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_yAxisDataStyle.fontSize]}
                                      forStr:_rowData[i]];
            
            CATextLayer *ytext = [self textLayer:POINT(self.boxLeftBottomPoint.x - _yStyle.lineWidth, self.canvasLeftBottomPoint.y + (i * self.rowSpace))
                                            text:_rowData[i]
                                       fontColor:_yAxisDataStyle.fontColor
                                        fontSize:_yAxisDataStyle.fontSize
                                         boxSize:CGSizeMake(_edgeInsets.left, rect.size.height)];
            
            ytext.anchorPoint = CGPointMake(1, 0.5);
            ytext.alignmentMode = kCAAlignmentRight;
            [self.layer addSublayer:ytext];
            
        }
        
    }
}

#pragma mark - 计 算 y 轴 数 据 -

- (void)calculateValue
{
    
    if (!_valueData || [_valueData count] == 0) {
        return;
    }
    if (!_columnData || [_columnData count] == 0) {
        return;
    }
    
    NSMutableArray *tempRowData = [NSMutableArray array];
    
    _space_value = [self spaceValue];
    
    if (_space_value > 0) {
        
        if (_isHundredPercent == YES) {
            _space_value = 1.0 / _row;
        }
        
        if (_isPercent == NO) {
            
            for (int i = 0; i < _row + 1; i++) {
                
                switch (_yAxisPrecisionScale) {
                        
                    case 0:
                    {
                        [tempRowData addObject:[NSString stringWithFormat:@"%.0f",i * _space_value]];
                    }
                        break;
                    case 1:
                    {
                        [tempRowData addObject:[NSString stringWithFormat:@"%.1f",i * _space_value]];
                    }
                        break;
                    case 2:
                    {
                        [tempRowData addObject:[NSString stringWithFormat:@"%.2f",i * _space_value]];
                    }
                        break;
                    case 3:
                    {
                        [tempRowData addObject:[NSString stringWithFormat:@"%.3f",i * _space_value]];
                    }
                        break;
                    case 4:
                    {
                        [tempRowData addObject:[NSString stringWithFormat:@"%.4f",i * _space_value]];
                    }
                        break;
                    case 5:
                    {
                        [tempRowData addObject:[NSString stringWithFormat:@"%.5f",i * _space_value]];
                    }
                        break;
                    default:
                        break;
                }
            }
            
            tempRowData[0] = @"0";
            
        }else{
            
            for (int i = 0; i < _row + 1; i++) {
                
                switch (_yAxisPrecisionScale) {
                        
                    case 0:
                    {
                        [tempRowData addObject:[NSString stringWithFormat:@"%.0f%%",i * _space_value * 100]];
                    }
                        break;
                    case 1:
                    {
                        [tempRowData addObject:[NSString stringWithFormat:@"%.1f%%",i * _space_value * 100]];
                    }
                        break;
                    case 2:
                    {
                        [tempRowData addObject:[NSString stringWithFormat:@"%.2f%%",i * _space_value * 100]];
                    }
                        break;
                    case 3:
                    {
                        [tempRowData addObject:[NSString stringWithFormat:@"%.3f%%",i * _space_value * 100]];
                    }
                        break;
                    case 4:
                    {
                        [tempRowData addObject:[NSString stringWithFormat:@"%.4f%%",i * _space_value * 100]];
                    }
                        break;
                    case 5:
                    {
                        [tempRowData addObject:[NSString stringWithFormat:@"%.5f%%",i * _space_value * 100]];
                    }
                        break;
                    default:
                        break;
                }
            }
            tempRowData[0] = @"0";
        }
    }
    
    _rowData = [NSArray arrayWithArray:tempRowData];
}

// 获取数据最大值,并计算每一行间隔值

- (CGFloat)spaceValue
{
    
    if (_valueData && [_valueData count]) {
        
        CGFloat minValue = MAXFLOAT;
        
        CGFloat maxValue = -MAXFLOAT;
        
        for (int i = 0; i < [_valueData count]; i++) {
            
            if ([_valueData[i] floatValue] * _precisionScale> maxValue) {
                maxValue = [_valueData[i] floatValue] * _precisionScale;
            }
            
            if ([_valueData[i] floatValue] * _precisionScale < minValue) {
                minValue = [_valueData[i] floatValue] * _precisionScale;
            }
            
        }
        
        int max = (int)[self getNumber:maxValue];
        
        NSInteger tenValue = 0;
        
        while (max / 10) {max = max / 10;tenValue++;}
        
        CGFloat space_Value = ((max + 1) * pow(10, tenValue)) / _row;
        
        return space_Value / _precisionScale;
        
    }else{
        
        return 0;
        
    }
    
}

// 只取小数点之前的数字

- (CGFloat)getNumber:(CGFloat)value
{
    NSString *string = [NSString stringWithFormat:@"%f",value];
    
    if (![[NSMutableString stringWithString:string] containsString:@"."]) {
        return value;
    }
    
    return [[[string componentsSeparatedByString:@"."] firstObject] floatValue];
    
}

#pragma mark - 绘 制 辅 助 线 -

- (void)drawGuide
{
    if (!_valueData || [_valueData count] == 0) {
        return;
    }
    if (!_columnData || [_columnData count] == 0) {
        return;
    }
    
    if (_isShowGriddingGuide) {
        
        for (int i = 0; i < _row + 1; i++) {
            
            CGPoint point = POINT(self.canvasLeftBottomPoint.x, self.canvasLeftBottomPoint.y + (i * self.rowSpace));
            
            CGFloat width = 0;
            
            if (_isLineChart) {
                width = self.columnSpace * (_column - 1);
            }else{
                width = self.columnSpace * _column;
            }
            
            CAShapeLayer *xGuide = [self horizontalLine:point
                                                  width:width                                              linecolor:_griddingStyle.lineColor
                                             lineHeight:_griddingStyle.lineWidth];
            xGuide.zPosition = 777777;
            [self.layer addSublayer:xGuide];
        }
        
        CGFloat columnNum = 0;
        
        if (_isLineChart) {
            columnNum = _column;
        }else{
            columnNum = _column + 1;
        }
        
        for (int i = 0; i < columnNum; i++) {
            
            CGPoint point = POINT(self.canvasLeftBottomPoint.x + (i * self.columnSpace), self.canvasLeftBottomPoint.y);
            
            CAShapeLayer *yGuide = [self verticalLine:point
                                               height:self.rowSpace * _row
                                            linecolor:_griddingStyle.lineColor
                                            lineWidth:_griddingStyle.lineWidth];
            
            yGuide.zPosition = 777777;
            [self.layer addSublayer:yGuide];
            
        }
    }
    
    if (_isShowHorizontalGuide) {
        
        for (int i = 0; i < _row + 1; i++) {
            
            CGPoint point = POINT(self.boxLeftBottomPoint.x, self.canvasLeftBottomPoint.y + (i * self.rowSpace));
            
            CAShapeLayer *xGuide = [self horizontalLine:point
                                                  width:TWOPOINTSPACING(self.boxRightTopPoint, self.boxLeftTopPoint)
                                              linecolor:_horizontalStyle.lineColor
                                             lineHeight:_horizontalStyle.lineWidth];
            
            xGuide.zPosition = 888888;
            [self.layer addSublayer:xGuide];
            
        }
    }
    if (_isShowVerticalGuide) {
        
        CGFloat columnNum = 0;
        
        if (_isLineChart) {
            columnNum = _column;
        }else{
            columnNum = _column + 1;
        }
        
        for (int i = 0; i < columnNum; i++) {
            
            CGPoint point = POINT(self.canvasLeftBottomPoint.x + (i * self.columnSpace), self.boxLeftBottomPoint.y);
            CAShapeLayer *yGuide = [self verticalLine:point
                                               height:TWOPOINTSPACING(self.canvasLeftTopPoint, self.boxLeftBottomPoint) - (_isShowHorizontalGuide ? _horizontalStyle.lineWidth : 0)
                                            linecolor:_verticalStyle.lineColor
                                            lineWidth:_verticalStyle.lineWidth];
            yGuide.zPosition = 888888;
            [self.layer addSublayer:yGuide];
            
        }
    }
}
#pragma mark - 绘 制 X Y 轴 -
- (void)drawXYAxis
{
    CAShapeLayer *x = [self horizontalLine:self.boxLeftBottomPoint width:TWOPOINTSPACING(self.boxLeftBottomPoint, self.boxRightBottomPoint) linecolor:_xStyle.lineColor lineHeight:_xStyle.lineWidth];
    x.anchorPoint = CGPointMake(0, 1);
    x.zPosition = 999999;
    [self.layer addSublayer:x];
    CAShapeLayer *y = [self verticalLine:self.boxLeftBottomPoint height:TWOPOINTSPACING(self.boxLeftTopPoint, self.boxLeftBottomPoint) linecolor:_yStyle.lineColor lineWidth:_yStyle.lineWidth];
    y.anchorPoint = CGPointMake(1, 0);
    y.zPosition = 999999;
    [self.layer addSublayer:y];
    
    // 弥补左下角缺陷
    CAShapeLayer *pane = [self horizontalLine:self.boxLeftBottomPoint width:_yStyle.lineWidth linecolor:_xStyle.lineColor lineHeight:_xStyle.lineWidth];
    pane.anchorPoint = CGPointMake(1, 1);
    [self.layer addSublayer:pane];
    
    // 绘制小三角
    CAShapeLayer *sanjiaoLayer = [self layerWith:POINT(self.boxLeftTopPoint.x - (_yStyle.lineWidth * 0.5), self.boxLeftTopPoint.y) width:_yStyle.lineWidth * 5 height:_yStyle.lineWidth * 7 fillColor:_yStyle.lineColor];
    [self.layer addSublayer:sanjiaoLayer];
}
// 获取字符串在指定区域的rect
- (CGRect)rectWithSize:(CGSize)size attributes:(NSDictionary<NSString *,id> *)attributes forStr:(NSString *)string{
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [string boundingRectWithSize:size options:options attributes:attributes context:nil];
    return rect;
}
// 创建轴标题
- (CATextLayer *)textLayer:(CGPoint)positionPoint text:(NSString *)text fontColor:(UIColor *)fontColor fontSize:(CGFloat)fontSize boxSize:(CGSize)boxSize{
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.string = text;
    textLayer.foregroundColor = fontColor.CGColor;
    textLayer.position = positionPoint;
    textLayer.fontSize = fontSize;
    textLayer.bounds = CGRectMake(0, 0, boxSize.width, boxSize.height);
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.wrapped = YES;
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    return textLayer;
}
#pragma mark - 创建竖线 -
- (CAShapeLayer *)verticalLine:(CGPoint)bottomPoint height:(CGFloat)height linecolor:(UIColor *)linecolor lineWidth:(CGFloat)lineWidth{
    CAShapeLayer *line = [CAShapeLayer layer];
    line.bounds = CGRectMake(0, 0, lineWidth, height);
    line.anchorPoint = CGPointMake(0.5, 0);
    line.position = bottomPoint;
    line.backgroundColor = linecolor.CGColor;
    return line;
}
#pragma mark - 创建水平线 -
- (CAShapeLayer *)horizontalLine:(CGPoint)leftPoint width:(CGFloat)width linecolor:(UIColor *)linecolor lineHeight:(CGFloat)lineHeight{
    CAShapeLayer *line = [CAShapeLayer layer];
    line.bounds = CGRectMake(0, 0, width, lineHeight);
    line.anchorPoint = CGPointMake(0, 0.5);
    line.position = leftPoint;
    line.backgroundColor = linecolor.CGColor;
    return line;
}
// 创建小三角
- (CAShapeLayer *)layerWith:(CGPoint)point width:(CGFloat)width height:(CGFloat)height fillColor:(UIColor *)fillColor{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.bounds = CGRectMake(0, 0, width, height);
    layer.position = point;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:POINT(0, 0)];
    [path addLineToPoint:POINT(width, 0)];
    [path addLineToPoint:POINT(width / 2.0, height * 0.8)];
    [path addLineToPoint:POINT(0, 0)];
    layer.fillColor = fillColor.CGColor;
    layer.path = path.CGPath;
    return layer;
}
// 创建折线图
- (LYSAnimationLayer *)lineChartWith:(CGPoint)point width:(CGFloat)width height:(CGFloat)height{
    LYSAnimationLayer *layer = [LYSAnimationLayer layer];
    layer.position = point;
    layer.bounds = CGRectMake(0, 0, width, height);
    return layer;
}
// 绘制圆点
- (CAShapeLayer *)dotWith:(CGPoint)point radius:(CGFloat)radius color:(UIColor *)color{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.bounds = CGRectMake(0, 0, 2 * radius, 2 * radius);
    layer.position = point;
    layer.cornerRadius = radius;
    layer.backgroundColor = color.CGColor;
    return layer;
}
@end
