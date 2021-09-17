//
//  ViewController.m
//  Benyue
//
//  Created by xiaoll on 2021/9/17.
//

#import "ViewController.h"
#import "MoonView.h"
#import "StarshowerView.h"
#import <UIImage+GIF.h>

#define CHANGE_WIDTH 400

@interface ViewController ()

@property (nonatomic , strong) UIImageView *backgroundImgView;

@property (nonatomic, strong) MoonView *moonView;
@property (nonatomic, strong) UIImage *starRainImage;
@property (nonatomic, strong) UIImageView *changeImgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.backgroundImgView];
    [self.view addSubview:self.moonView];
    [self.view addSubview:self.changeImgView];
    
    for (int i = 0; i < 100; i ++) {
        // 创建小星星
        UIView *starView = [[UIView alloc] init];
        CGFloat starViewX = random() % ((int)[UIScreen mainScreen].bounds.size.width);
        CGFloat starViewY = random() % ((int)([UIScreen mainScreen].bounds.size.height));
        CGFloat starViewWH = random() % 3 + 2;
        starView.frame = CGRectMake(starViewX, starViewY, starViewWH, starViewWH);
        starView.backgroundColor = [UIColor whiteColor];
        starView.layer.shadowColor = [UIColor whiteColor].CGColor;
        starView.layer.shadowOffset = CGSizeMake(0, 0);
        starView.layer.shadowRadius = starViewWH * 0.5;
        starView.layer.shadowOpacity = 0.8;
        starView.layer.cornerRadius = starViewWH * 0.5;
        [self.view insertSubview:starView belowSubview:self.moonView];
        
        // 小星星闪烁动画
        CGFloat delayTime = (random() % 10) / 10.f + 0.5;
        CGFloat duration = (random() % 2) + 1;
        CGFloat toValue = (random() % 6) / 10.f;
        CABasicAnimation *starOpacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        starOpacityAnim.fromValue = @(1.0);
        starOpacityAnim.toValue = @(toValue);
        starOpacityAnim.duration = duration;
        starOpacityAnim.beginTime = delayTime;
        starOpacityAnim.autoreverses = YES;
        starOpacityAnim.repeatCount = MAXFLOAT;
        starOpacityAnim.removedOnCompletion = NO;
        starOpacityAnim.fillMode = kCAFillModeForwards;
        starOpacityAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [starView.layer addAnimation:starOpacityAnim forKey:nil];
    }
    
    [self startStarRainAnimation];
    [self startChangeFlyToMoonAnimation];
}

#pragma mark - private methods
- (void)startStarRainAnimation {
    CAEmitterLayer *meteor = [CAEmitterLayer layer];
    // 发射位置
    meteor.emitterPosition = CGPointMake(-300, 0);
    // 粒子产生系数，默认为1
    meteor.birthRate = 1;
    // 发射器的尺寸
    meteor.emitterSize = CGSizeMake(4000, 0);
    // 发射的形状
    meteor.emitterShape = kCAEmitterLayerCuboid;
    // 发射的模式
    meteor.emitterMode = kCAEmitterLayerLine;
    // 渲染模式
    meteor.renderMode = kCAEmitterLayerAdditive;
    
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    // 设置粒子每秒的生成数量
    cell.birthRate = 15;
    // 设置生成时的初始速度的变化范围
    cell.velocity = 500.0f;
    cell.velocityRange = 300.0f;
    // 设置粒子的Y轴加速度
    cell.yAcceleration = 0.0f;
    // 缩放比例
    cell.scale= 0.5f;
    // 缩放速度
    cell.scaleSpeed = 0.1;
    // 粒子存活时长
    cell.lifetime = 2.5f/*1.8f*/;
    // 粒子的初始发射方向
    cell.emissionLongitude = 0.75 * M_PI;
    // 展示流星快照
    cell.contents = (__bridge id _Nullable)(self.starRainImage.CGImage);
    // 设置粒子颜色
    cell.color = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6].CGColor;

    meteor.emitterDepth = 10.0f;
    meteor.shadowOpacity = 0.0f;
    meteor.shadowRadius = 0.0f;
    meteor.emitterCells = [NSArray arrayWithObject:cell];
    [self.view.layer insertSublayer:meteor below:self.moonView.layer];
}

- (void)startChangeFlyToMoonAnimation {
    CABasicAnimation *moonScaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    moonScaleAnim.fromValue = [NSNumber numberWithFloat:0.8];
    moonScaleAnim.toValue = [NSNumber numberWithFloat:1.5];
    moonScaleAnim.duration = 4;
    moonScaleAnim.autoreverses = NO;
    moonScaleAnim.removedOnCompletion = NO;
    moonScaleAnim.fillMode = kCAFillModeForwards;
    moonScaleAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.moonView.layer addAnimation:moonScaleAnim forKey:nil];
    
    CAKeyframeAnimation *changeScaleAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    changeScaleAnim.values = @[[NSNumber numberWithFloat:1.2],
                          [NSNumber numberWithFloat:0.8],
                          [NSNumber numberWithFloat:0.5]];
    changeScaleAnim.keyTimes = @[[NSNumber numberWithFloat:0.0],
                            [NSNumber numberWithFloat:0.5],
                            [NSNumber numberWithFloat:1.0]];
    changeScaleAnim.beginTime = 0;
    
    CABasicAnimation *changeOpacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    changeOpacityAnim.fromValue = @(1.0);
    changeOpacityAnim.toValue = @(0.0);
    changeOpacityAnim.beginTime = 2.5;
    
    CAKeyframeAnimation *changePositionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [path addQuadCurveToPoint:self.moonView.center controlPoint:CGPointMake(CGRectGetMinX(self.changeImgView.frame) - 100, CGRectGetMinY(self.moonView.frame))];
    changePositionAnim.path = path.CGPath;
    changePositionAnim.beginTime = 0;
    
    CAAnimationGroup *changeAnim = [CAAnimationGroup animation];
    changeAnim.duration = 4;
    changeAnim.repeatCount = 1;
    changeAnim.removedOnCompletion = NO;
    changeAnim.fillMode = kCAFillModeForwards;
    changeAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    changeAnim.animations = @[changeScaleAnim, changePositionAnim, changeOpacityAnim];
    [self.changeImgView.layer addAnimation:changeAnim forKey:nil];
}

#pragma mark - lazy loading
- (UIImageView *)backgroundImgView{
    if (!_backgroundImgView) {
        _backgroundImgView = [[UIImageView alloc] init];
        _backgroundImgView.frame = self.view.bounds;
        _backgroundImgView.image = [UIImage imageNamed:@"home_background"];
    }
    return _backgroundImgView;
}

- (MoonView *)moonView {
    if (_moonView == nil) {
        _moonView = [[MoonView alloc] initWithFrame:CGRectMake(200, (200 + 100) * 0.618 - 100, 200, 200)];
    }
    return _moonView;
}

- (UIImage *)starRainImage {
    if (_starRainImage == nil) { /*250 100*/
        StarshowerView *starRainView = [[StarshowerView alloc] initWithFrame:CGRectMake(0, 0, 90, 60)];
        _starRainImage =[starRainView convertViewToImage];
    }
    return _starRainImage;
}

- (UIImageView *)changeImgView {
    if (_changeImgView == nil) {
        _changeImgView = [[UIImageView alloc] init];
        NSData *changeData = [[NSDataAsset alloc] initWithName:@"change" bundle:[NSBundle mainBundle]].data;
        UIImage *changeImage = [UIImage sd_animatedGIFWithData:changeData];
        _changeImgView.image = changeImage;
        _changeImgView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height, CHANGE_WIDTH, CHANGE_WIDTH * changeImage.size.width / changeImage.size.height);
    }
    return _changeImgView;
}

@end
