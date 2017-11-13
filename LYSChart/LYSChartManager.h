/*
    非常感谢大家使用!如果大家在使用过程中,发现bug,或者希望有什么改进的地方尽管提出来,
    我会尽一切可能满足你们的需求
    Github地址:https://github.com/LYSBuildCode/LYSChart
    简书地址:http://www.jianshu.com/p/2efd439f936c
    如果有什么疑问,可以在简书下面留言,我会及时对您的问题做出处理
    如果喜欢,给个赞,或者给个星,谢谢
 */

#import <UIKit/UIKit.h>

// 轴线样式
@interface LYSAxisStyle : NSObject
@property (nonatomic,strong)UIColor *lineColor;
@property (nonatomic,assign)CGFloat lineWidth;
@end

// 辅助线样式
@interface LYSGuideStyle : NSObject
@property (nonatomic,strong)UIColor *lineColor;
@property (nonatomic,assign)CGFloat lineWidth;
@end

// X轴数据样式
@interface LYSAxisDataStyle : NSObject
@property (nonatomic,strong)UIColor *fontColor;
@property (nonatomic,assign)CGFloat fontSize;
@end

// 阈值线样式
@interface LYSBenchmarkLineStyle : NSObject
@property (nonatomic,strong)NSNumber *benchmarkValue;
@property (nonatomic,strong)UIColor *lineColor;
@property (nonatomic,assign)CGFloat lineWidth;
@property (nonatomic,strong)UIColor *fontColor;
@property (nonatomic,assign)CGFloat fontSize;
@end

// 动态layer
@interface LYSAnimationLayer : CAShapeLayer
@property (nonatomic,strong)id obj;
@property (nonatomic,assign)CGRect selfRect;
- (void)animationSetPath:(CGPathRef (^)(CADisplayLink *displayLink))setPathAction;
@end

