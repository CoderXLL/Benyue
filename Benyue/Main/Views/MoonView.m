//
//  MoonView.m
//  Benyue
//
//  Created by xiaoll on 2021/9/17.
//

#import "MoonView.h"

#define RGBA(r, g, b, a)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a/255.0f)]

@implementation MoonView

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

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 1.创建CGContextRef
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 2.绘制path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, CGRectGetMidX(rect), CGRectGetMidY(rect), rect.size.width * 0.5, 0, M_PI * 2, false);
    CGPathCloseSubpath(path);
       
    // 3.绘制渐变
    [self drawRadialGradient:ctx path:path];
    
    // 4.绘制阴影
    self.layer.shadowColor = RGBA(247, 247, 9, 255).CGColor;
    self.layer.shadowOffset = CGSizeMake(20, 20);
    self.layer.shadowRadius = self.bounds.size.width * 0.5;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowPath = path;
    
    // 5.释放path 有create就对应有release
    CGPathRelease(path);
    
    // 6.从上下文中获取图像，显示在界面上
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
       
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:imageView];
}

#pragma mark - private methods
- (void)makeUI {
    
}

- (void)drawRadialGradient:(CGContextRef)context path:(CGPathRef)path
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = @[(__bridge id) RGBA(196, 196, 60, 255).CGColor, (__bridge id) RGBA(240, 240, 9, 255).CGColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    CGPoint center = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMidY(pathRect));
    CGFloat radius = MAX(pathRect.size.width * 0.5, pathRect.size.height * 0.5) * sqrt(2);
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextEOClip(context);
    
    CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end
