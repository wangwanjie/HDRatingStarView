//
//  HDRatingStarView.h
//  ViPay
//
//  Created by VanJay on 2020/1/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDRatingStarView : UIView

/** 星星图片，默认使用 bundle 里的 */
@property (nonatomic, strong) UIImage *starImage;

/** 星星宽度，默认 35 */
@property (nonatomic, assign) CGFloat starWidth;

/* 星星个数，默认 5 个 */
@property (nonatomic, assign) NSInteger starNum;

/* 星星间距 默认 5 */
@property (nonatomic, assign) CGFloat itemMargin;

/**
 * 一个星星分几份，默认 2，即相差一颗星打分间隔在2份，半星打分
 *  改变此属性可实现任意粒度的打分
 */
@property (nonatomic, assign) NSInteger countForOneStar;

/* 总分，默认 5 分 */
@property (nonatomic, assign) CGFloat fullScore;

/* 选择分数回调 */
@property (nonatomic, copy) void (^selectScoreHandler)(CGFloat score);

/** 渲染颜色 */
@property (nonatomic, strong) UIColor *renderColor;

@end

NS_ASSUME_NONNULL_END
