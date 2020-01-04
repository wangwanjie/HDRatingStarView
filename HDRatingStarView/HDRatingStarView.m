//
//  HDRatingStarView.m
//  ViPay
//
//  Created by VanJay on 2020/1/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDRatingStarView.h"

static CGFloat const kStarViewTop = 0;

@interface HDRatingStarView ()
@property (nonatomic, strong) CAShapeLayer *foreGroundLayer;
@property (nonatomic, strong) UIView *starContainer;  ///< 星星容器
@property (nonatomic, strong) NSMutableArray<UIImageView *> *allStarViews;
@end

@implementation HDRatingStarView
#pragma mark - life cycle
- (void)commonInit {
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.starContainer];
    self.starContainer.userInteractionEnabled = false;
    [self.layer addSublayer:self.foreGroundLayer];

    // 使用 resource_bundles，不加 use_frameworks! 才可
    // NSURL *bundleURL = [[NSBundle bundleForClass:self.class] URLForResource:@"HDRatingStarView" withExtension:@"bundle"];
    // NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
    // UIImage *image = [UIImage imageNamed:@"starUnselected" inBundle:bundle compatibleWithTraitCollection:nil];

    // 使用 resource，use_frameworks! 加不加均可
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    UIImage *image = [UIImage imageNamed:@"starUnselected"
                                inBundle:bundle
           compatibleWithTraitCollection:nil];

    self.starImage = image;
    self.starNum = 5;
    self.itemMargin = 5;
    self.countForOneStar = 2;
    self.fullScore = 5;
    self.starWidth = 35;
    self.renderColor = UIColor.blueColor;
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
    }
    return self;
}

#pragma mark - getters and setters
- (void)setStarNum:(NSInteger)starNum {
    if (_starNum == starNum) return;
    _starNum = starNum;

    NSAssert(self.starImage, @"请先设置星星图片");

    [self.allStarViews removeAllObjects];
    [self.starContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    for (NSInteger i = 0; i < self.starNum; i++) {
        UIImageView *item = [[UIImageView alloc] initWithImage:self.starImage];
        [self.allStarViews addObject:item];
        [self.starContainer addSubview:item];
    }
    [self setNeedsLayout];
}

- (void)setRenderColor:(UIColor *)renderColor {
    _renderColor = renderColor;

    self.foreGroundLayer.strokeColor = self.renderColor.CGColor;
}

#pragma mark - layout
- (void)layoutSubviews {
    [super layoutSubviews];

    if (CGRectIsEmpty(self.frame)) return;

    NSAssert(CGRectGetHeight(self.frame) >= self.starWidth, @"控件高度不能低于星星高度");

    self.starContainer.frame = self.bounds;

    CGFloat x = 0;
    for (UIImageView *item in self.allStarViews) {
        item.frame = CGRectMake(x, kStarViewTop, self.starWidth, self.starWidth);
        x += self.starWidth;
        x += self.itemMargin;
    }

    self.foreGroundLayer.frame = self.bounds;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, CGRectGetHeight(self.frame) / 2)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) / 2)];
    self.foreGroundLayer.path = path.CGPath;
    self.foreGroundLayer.lineWidth = CGRectGetHeight(self.frame);
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat width = self.starWidth * self.starNum + (self.starNum - 1) * self.itemMargin;
    return CGSizeMake(width, size.height);
}

#pragma mark - override system methods
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 获取touch
    UITouch *touch = [touches anyObject];
    // 获取当前点
    CGPoint touchPoint = [touch locationInView:self];
    [self setStrokeWithTransformPoint:touchPoint];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 获取touch
    UITouch *touch = [touches anyObject];
    // 获取当前点
    CGPoint touchPoint = [touch locationInView:self];
    [self setStrokeWithTransformPoint:touchPoint];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 获取touch
    UITouch *touch = [touches anyObject];
    // 获取当前点
    CGPoint touchPoint = [touch locationInView:self];

    [self caculateScoreWithEndTouchPoint:touchPoint];
}

#pragma mark - private methods
/** 计算分数 */
- (void)caculateScoreWithEndTouchPoint:(CGPoint)touchPoint {
    touchPoint = [self convertPoint:touchPoint toView:self.starContainer];

    CGFloat pieceScore = (CGFloat)self.fullScore / (self.starNum * self.countForOneStar);
    CGFloat pieceWidth = self.starWidth / (CGFloat)self.countForOneStar;

    if (touchPoint.x < 0) {
        touchPoint.x = 0 + pieceWidth * 0.5;
    }
    if (touchPoint.x > CGRectGetWidth(self.starContainer.frame)) {
        touchPoint.x = CGRectGetWidth(self.starContainer.frame) - pieceWidth * 0.5;
    }
    if (touchPoint.y < kStarViewTop) {
        touchPoint.y = kStarViewTop + pieceWidth * 0.5;
    }
    if (touchPoint.y > self.starWidth) {
        touchPoint.y = self.starWidth - pieceWidth * 0.5;
    }

    // 目标控件
    NSInteger destIndex = NSNotFound;
    for (NSInteger i = 0; i < self.allStarViews.count; i++) {
        UIImageView *starView = self.allStarViews[i];

        CGRect fullHeightStarViewRect = CGRectMake(CGRectGetMinX(starView.frame), 0, CGRectGetWidth(starView.frame), CGRectGetHeight(self.starContainer.frame));
        if (CGRectContainsPoint(fullHeightStarViewRect, touchPoint)) {
            destIndex = i;
            break;
        }
    }

    NSInteger totalPieces = 0;
    if (destIndex != NSNotFound) {

        UIView *starView = self.allStarViews[destIndex];
        // 点在了星星上
        // 坐标转换
        CGPoint pointToStar = [self convertPoint:touchPoint toView:starView];

        NSUInteger extraPieces = (NSInteger)(pointToStar.x / pieceWidth) + (fmodf(pointToStar.x, pieceWidth) != 0 ? 1 : 0);

        totalPieces = destIndex * self.countForOneStar + extraPieces;

        // 纠正图层终点位置
        CGPoint fixedPoint = CGPointMake(extraPieces * pieceWidth, touchPoint.y);
        CGPoint fixedPointToContainer = [starView convertPoint:fixedPoint toView:self.starContainer];
        [self setStrokeWithTransformPoint:fixedPointToContainer];
    } else {
        // 点在了空白区域
        // 获取触摸点左边的星星
        for (NSInteger i = 0; i < self.allStarViews.count; i++) {
            UIImageView *starView = self.allStarViews[i];
            if (touchPoint.x > CGRectGetMaxX(starView.frame) && touchPoint.x < CGRectGetMaxX(starView.frame) + self.itemMargin) {
                destIndex = i;
                break;
            }
        }
        if (destIndex != NSNotFound) {
            totalPieces = (destIndex + 1) * self.countForOneStar;
        } else {
            NSLog(@"点在了三界之外");
        }
    }

    if (self.selectScoreHandler) {
        self.selectScoreHandler(totalPieces * pieceScore);
    }
}

/* 设置图层渲染终点 */
- (void)setStrokeWithTransformPoint:(CGPoint)transformPoint {
    self.foreGroundLayer.strokeEnd = transformPoint.x / self.frame.size.width;
}

#pragma mark - lazy load
- (CAShapeLayer *)foreGroundLayer {
    if (!_foreGroundLayer) {
        _foreGroundLayer = [[CAShapeLayer alloc] init];
        _foreGroundLayer.backgroundColor = [UIColor grayColor].CGColor;
        _foreGroundLayer.fillColor = [UIColor clearColor].CGColor;
        _foreGroundLayer.mask = self.starContainer.layer;
        _foreGroundLayer.strokeEnd = 0;
    }
    return _foreGroundLayer;
}

- (UIView *)starContainer {
    if (!_starContainer) {
        _starContainer = UIView.new;
    }
    return _starContainer;
}

- (NSMutableArray<UIImageView *> *)allStarViews {
    if (!_allStarViews) {
        _allStarViews = [NSMutableArray array];
    }
    return _allStarViews;
}
@end
