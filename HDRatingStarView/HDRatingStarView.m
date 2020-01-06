//
//  HDRatingStarView.m
//  ViPay
//
//  Created by VanJay on 2020/1/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDRatingStarView.h"
#import "HDStarView.h"

static CGFloat const kStarViewTop = 0;

@interface HDRatingStarView ()
@property (nonatomic, strong) CAShapeLayer *foreGroundLayer;
@property (nonatomic, strong) UIView *starContainer;  ///< 星星容器
@property (nonatomic, strong) NSMutableArray<HDStarView *> *allStarViews;
@end

@implementation HDRatingStarView
#pragma mark - life cycle
- (void)commonInit {
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.starContainer];
    self.starContainer.userInteractionEnabled = false;
    [self.layer addSublayer:self.foreGroundLayer];

    self.starNum = 5;
    self.itemMargin = 5;
    self.countForOneStar = 2;
    self.fullScore = 5;
    self.starWidth = 35;
    self.renderColor = UIColor.blueColor;
    self.defaultColor = UIColor.grayColor;
    self.allowTouchToSelectScore = true;
    self.shouldFixScore = false;
    self.allowSlideToChangeScore = true;
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

    [self.allStarViews removeAllObjects];
    [self.starContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    for (NSInteger i = 0; i < self.starNum; i++) {
        HDStarView *star = [[HDStarView alloc] init];
        star.image = self.starImage;
        [self.allStarViews addObject:star];
        [self.starContainer addSubview:star];
    }
    [self setNeedsLayout];
}

- (void)setRenderColor:(UIColor *)renderColor {
    _renderColor = renderColor;

    self.foreGroundLayer.strokeColor = self.renderColor.CGColor;
}

- (void)setDefaultColor:(UIColor *)defaultColor {
    _defaultColor = defaultColor;

    self.foreGroundLayer.backgroundColor = defaultColor.CGColor;
}

- (void)setStarImage:(UIImage *)starImage {
    _starImage = starImage;

    for (HDStarView *star in self.allStarViews) {
        star.image = starImage;
    }
}

- (void)setScore:(CGFloat)score {
    score = score < 0 ? 0 : score;
    score = score > self.fullScore ? self.fullScore : score;

    _score = score;

    [self drawScore:score];
}

- (void)setAllowTouchToSelectScore:(BOOL)allowTouchToSelectScore {
    _allowTouchToSelectScore = allowTouchToSelectScore;

    self.userInteractionEnabled = allowTouchToSelectScore;
}

#pragma mark - layout
- (void)layoutSubviews {
    [super layoutSubviews];

    if (CGRectIsEmpty(self.frame)) return;

    self.starContainer.frame = self.bounds;

    CGFloat x = 0;
    for (HDStarView *item in self.allStarViews) {
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

    [self drawScore:self.score];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat width = self.starWidth * self.starNum + (self.starNum - 1) * self.itemMargin;
    return CGSizeMake(width, self.starWidth);
}

#pragma mark - override system methods
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 获取当前点
    CGPoint touchPoint = [touches.anyObject locationInView:self];
    [self updateForeGroundLayerWithPoint:touchPoint];

    if (!self.allowSlideToChangeScore) {
        [self caculateScoreWithEndTouchPoint:touchPoint];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    if (!self.allowSlideToChangeScore) return;

    // 获取当前点
    CGPoint touchPoint = [touches.anyObject locationInView:self];
    [self updateForeGroundLayerWithPoint:touchPoint];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 获取当前点
    CGPoint touchPoint = [touches.anyObject locationInView:self];

    [self caculateScoreWithEndTouchPoint:touchPoint];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 获取当前点
    CGPoint touchPoint = [touches.anyObject locationInView:self];

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
        HDStarView *starView = self.allStarViews[i];

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
        [self updateForeGroundLayerWithPoint:fixedPointToContainer];
    } else {
        // 点在了空白区域
        // 获取触摸点左边的星星
        for (NSInteger i = 0; i < self.allStarViews.count; i++) {
            HDStarView *starView = self.allStarViews[i];
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

    self.score = totalPieces * pieceScore;
    if (self.selectScoreHandler) {
        self.selectScoreHandler(self.score);
    }
}

/** 设置评分 */
- (void)drawScore:(CGFloat)score {

    // 决定是否执行分数补偿
    if (self.shouldFixScore) {
        CGFloat pieceScore = (CGFloat)self.fullScore / (self.starNum * self.countForOneStar);
        if (fmodf(score, pieceScore) != 0) {
            score = ((NSInteger)(score / pieceScore) + 1) * pieceScore;
            _score = score;
        }
    }

    // 先算出一个星星是几分
    CGFloat singleStarScore = (CGFloat)self.fullScore / self.starNum;

    NSInteger count = score / singleStarScore;
    CGFloat pointX = count * (self.starWidth + self.itemMargin) - (count > 0 ? self.itemMargin : 0);

    CGFloat leftScore = fmodf(score, singleStarScore);
    if (leftScore != 0) {
        pointX += ((count > 0 ? self.itemMargin : 0) + (leftScore / singleStarScore) * (CGFloat)self.starWidth);
    }

    [self updateForeGroundLayerWithPoint:CGPointMake(pointX, CGRectGetHeight(self.starContainer.frame) * 0.5)];
}

/* 更新图层渲染终点 */
- (void)updateForeGroundLayerWithPoint:(CGPoint)point {
    self.foreGroundLayer.strokeEnd = point.x / CGRectGetWidth(self.starContainer.bounds);
}

#pragma mark - lazy load
- (CAShapeLayer *)foreGroundLayer {
    if (!_foreGroundLayer) {
        _foreGroundLayer = [[CAShapeLayer alloc] init];
        _foreGroundLayer.fillColor = [UIColor clearColor].CGColor;
        _foreGroundLayer.mask = self.starContainer.layer;
    }
    return _foreGroundLayer;
}

- (UIView *)starContainer {
    if (!_starContainer) {
        _starContainer = UIView.new;
    }
    return _starContainer;
}

- (NSMutableArray<HDStarView *> *)allStarViews {
    if (!_allStarViews) {
        _allStarViews = [NSMutableArray array];
    }
    return _allStarViews;
}
@end
