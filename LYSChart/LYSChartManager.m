/*
    非常感谢大家使用!如果大家在使用过程中,发现bug,或者希望有什么改进的地方尽管提出来,
    我会尽一切可能满足你们的需求
    Github地址:https://github.com/LYSBuildCode/LYSChart
    简书地址:http://www.jianshu.com/p/2efd439f936c
    如果有什么疑问,可以在简书下面留言,我会及时对您的问题做出处理
    如果喜欢,给个赞,或者给个星,谢谢
 */

#import "LYSChartManager.h"

@implementation LYSAxisStyle
@end

@implementation LYSGuideStyle
@end

@implementation LYSAxisDataStyle
@end

@implementation LYSBenchmarkLineStyle
@end

@implementation LYSAnimationLayer
{
    CGPathRef (^animationAction)(CADisplayLink *displayLink);
    CADisplayLink *_displayLink;
}
- (void)animationSetPath:(CGPathRef (^)(CADisplayLink *displayLink))setPathAction{
    if (_displayLink) {[_displayLink invalidate];_displayLink = nil;}
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animationDisPlayHistogram)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:(NSDefaultRunLoopMode)];
    animationAction = setPathAction;
}
- (void)animationDisPlayHistogram{
    if (animationAction) {[self setPath:animationAction(_displayLink)];}
}
@end
