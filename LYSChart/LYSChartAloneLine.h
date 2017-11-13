/*
    非常感谢大家使用!如果大家在使用过程中,发现bug,或者希望有什么改进的地方尽管提出来,
    我会尽一切可能满足你们的需求
    Github地址:https://github.com/LYSBuildCode/LYSChart
    简书地址:http://www.jianshu.com/p/2efd439f936c
    如果有什么疑问,可以在简书下面留言,我会及时对您的问题做出处理
    如果喜欢,给个赞,或者给个星,谢谢
 */

#import <UIKit/UIKit.h>
#import "LYSChartManager.h"

@interface LYSChartAloneLine : UIView
/* 内容边距 */

@property (nonatomic,assign)UIEdgeInsets edgeInsets;

/* 画布边距 */

@property (nonatomic,assign)UIEdgeInsets canvasEdgeInsets;

/* x轴样式 */

@property (nonatomic,strong)LYSAxisStyle *xStyle;

/* y轴样式 */

@property (nonatomic,strong)LYSAxisStyle *yStyle;

/* 图表有多少行 */

@property (nonatomic,assign)NSInteger row;

/* 图表有多少列 */

@property (nonatomic,assign)NSInteger column;

/* 是否显示网格线 */

@property (nonatomic,assign)BOOL isShowGriddingGuide;

/* 网格样式 */

@property (nonatomic,strong)LYSGuideStyle *griddingStyle;

/* 是否显示水平辅助线 */

@property (nonatomic,assign)BOOL isShowHorizontalGuide;

/* 水平线样式*/

@property (nonatomic,strong)LYSGuideStyle *horizontalStyle;

/* 是否显示竖直辅助线 */

@property (nonatomic,assign)BOOL isShowVerticalGuide;

/* 竖直线样式 */

@property (nonatomic,strong)LYSGuideStyle *verticalStyle;

/* 是否是百分比 */

@property (nonatomic,assign)BOOL isPercent;

/* 是否最大值100% */

@property (nonatomic,assign)BOOL isHundredPercent;

/* 计算精度,10,100,1000,默认是1,通常用于数据非常小的情况下 */

@property (nonatomic,assign)NSInteger precisionScale;

/* y轴下标计算精度,0,1,2,3,4,5,默认是2,y轴数据的小数位 */

@property (nonatomic,assign)NSInteger yAxisPrecisionScale;

/* x轴下标 */

@property (nonatomic,strong)NSArray *columnData;

/* 展示数据 */

@property (nonatomic,strong)NSArray *valueData;

/* x轴下标样式 */

@property (nonatomic,strong)LYSAxisDataStyle *xAxisDataStyle;

/* y轴下标样式 */

@property (nonatomic,strong)LYSAxisDataStyle *yAxisDataStyle;

/* 是否自适应X间距 */

@property (nonatomic,assign)BOOL isAutoXSpacing;

/* 是否自适应Y间距 */

@property (nonatomic,assign)BOOL isAutoYSpacing;

/* 如果 isAutoXSpacing 设置为NO,则需要设置这个属性 */

/* 竖直方向每一行间距 */

@property (nonatomic,assign)CGFloat rowSpace;

/* 水平方向每一列间距 */

@property (nonatomic,assign)CGFloat columnSpace;

/* 显示数据样式 */

@property (nonatomic,strong)LYSAxisDataStyle *yValueDataStyle;

/* 是否显示阈值线 */

@property (nonatomic,assign)BOOL isShowBenchmarkLine;

/* 阈值线样式 */

@property (nonatomic,strong)LYSBenchmarkLineStyle *benchmarkLineStyle;

/* 折线颜色 */

@property (nonatomic,strong)UIColor *lineChartColor;

/* 折线宽度 */

@property (nonatomic,assign)CGFloat lineChartWidth;

/* 折线圆点 */

@property (nonatomic,assign)CGFloat lineChartDotRadius;

/* 折线圆点颜色 */

@property (nonatomic,strong)UIColor *lineChartDotColor;

/* 曲线 */

@property (nonatomic,assign)BOOL isCurve;

/* 刷 新 视 图 */

- (void)reloadData;
@end
