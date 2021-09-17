//
//  StarshowerView.m
//  Benyue
//
//  Created by xiaoll on 2021/9/17.
//

#import "StarshowerView.h"

@interface StarshowerView()

@property (nonatomic, strong) CAShapeLayer *shaperLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation StarshowerView

#pragma mark - life circle
- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self makeUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if ([super initWithCoder:coder]) {
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.shaperLayer.frame = self.bounds;
    self.gradientLayer.frame = self.bounds;
}

#pragma mark - private methods
- (void)makeUI {
    [self.layer addSublayer:self.gradientLayer];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(self.bounds) + 5, CGRectGetMaxY(self.bounds) - 5);
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(self.bounds) - 5, CGRectGetMinY(self.bounds) + 5);
    CGPathCloseSubpath(path);
    
    self.shaperLayer.path = path;
    CGPathRelease(path);
    
    self.layer.mask = self.shaperLayer;
}

// 转为屏幕快照
- (UIImage *)convertViewToImage {
    UIImage *starRainImage = [[UIImage alloc] init];
    // 设置背景透明背景，并且不失真
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    starRainImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return starRainImage;
}

#pragma mark - lazy loading
- (CAShapeLayer *)shaperLayer {
    if (_shaperLayer == nil) {
        _shaperLayer = [CAShapeLayer layer];
        _shaperLayer.lineCap = kCALineCapButt;
        _shaperLayer.lineJoin = kCALineJoinRound;
        _shaperLayer.strokeColor = [UIColor redColor].CGColor;
        _shaperLayer.fillColor = [[UIColor redColor] CGColor];
        _shaperLayer.lineWidth = 3;
        _shaperLayer.backgroundColor = [UIColor clearColor].CGColor;
    }
    return _shaperLayer;
}

- (CAGradientLayer *)gradientLayer {
    if (_gradientLayer == nil) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = @[
            (__bridge id)[UIColor whiteColor].CGColor,
            (__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:0.6].CGColor,
            (__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor,
            (__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:0].CGColor
        ];
        _gradientLayer.startPoint = CGPointMake(0, 1);
        _gradientLayer.endPoint = CGPointMake(1, 0);
        _gradientLayer.locations = @[@0, @0.3, @0.6, @1];
    }
    return _gradientLayer;
}

@end
