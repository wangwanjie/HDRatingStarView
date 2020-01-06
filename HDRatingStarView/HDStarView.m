//
//  HDStarView.m
//  HDRatingStarView_Example
//
//  Created by VanJay on 2020/1/4.
//  Copyright © 2020 wangwanjie. All rights reserved.
//

#import "HDStarView.h"

@implementation HDStarView
#pragma mark - life cycle
- (void)commonInit {
    self.backgroundColor = UIColor.clearColor;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];

        // 从 xib 初始化的话，在 IB 里设置了 tintColor 也不会触发 tintColorDidChange，所以这里手动调用一下
        [self tintColorDidChange];
    }
    return self;
}

- (void)tintColorDidChange {
    [super tintColorDidChange];

    [self setNeedsDisplay];
}

- (void)setImage:(UIImage *)image {
    _image = image;

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();

    if (self.image) {
        // UIKit的坐标系和 CGContext 所在的坐标系不同
        // UIKit下面圆点在左上角 而CGContext所在的坐标系在左下角，垂直翻转一下
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, 0, rect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        // 绘制图片
        CGRect drawImageRect = rect;
        if (CGRectGetWidth(self.bounds) > CGRectGetHeight(self.bounds)) {
            drawImageRect.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetHeight(self.bounds)) * 0.5;
            drawImageRect.size.width = drawImageRect.size.height;
        } else if (CGRectGetWidth(self.bounds) < CGRectGetHeight(self.bounds)) {
            drawImageRect.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetWidth(self.bounds)) * 0.5;
            drawImageRect.size.height = drawImageRect.size.width;
        }
        CGContextDrawImage(context, drawImageRect, self.image.CGImage);
        CGContextEndPage(context);
        return;
    }

    NSMutableArray<NSValue *> *points = [NSMutableArray array];
    CGContextSetStrokeColorWithColor(context, UIColor.clearColor.CGColor);
    CGContextSetFillColorWithColor(context, self.tintColor.CGColor);
    CGContextSetLineWidth(context, 5);

    CGFloat smallerSideLength = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    CGFloat radius = smallerSideLength * 0.5;
    double angel = M_PI * 2 / 5;

    for (NSInteger i = 0; i < 5; i++) {
        CGFloat x = (CGFloat)CGRectGetWidth(self.bounds) * 0.5 - sinf(i * angel) * radius;
        CGFloat y = (CGFloat)CGRectGetHeight(self.bounds) * 0.5 - cosf(i * angel) * radius;
        [points addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
    }
    CGPoint firstPoint = points.firstObject.CGPointValue;
    CGContextMoveToPoint(context, firstPoint.x, firstPoint.y);

    for (NSInteger i = 0; i < 5; i++) {
        NSInteger index = (2 * i) % 5;
        CGPoint point = points[index].CGPointValue;
        CGContextAddLineToPoint(context, point.x, point.y);
    }
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextEndPage(context);
}
@end
