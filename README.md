# HDRatingStarView

高可自定义，支持任意粒度的星星点击、滑动评分

[![CI Status](https://img.shields.io/travis/wangwanjie/HDRatingStarView.svg?style=flat)](https://travis-ci.org/wangwanjie/HDRatingStarView)
[![Version](https://img.shields.io/cocoapods/v/HDRatingStarView.svg?style=flat)](https://cocoapods.org/pods/HDRatingStarView)
[![License](https://img.shields.io/cocoapods/l/HDRatingStarView.svg?style=flat)](https://cocoapods.org/pods/HDRatingStarView)
[![Platform](https://img.shields.io/cocoapods/p/HDRatingStarView.svg?style=flat)](https://cocoapods.org/pods/HDRatingStarView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Use

```ObjC
[self.view addSubview:({
               HDRatingStarView *view = [[HDRatingStarView alloc] init];
               // view.starNum = 5;
               // view.itemMargin = 20;
               // view.countForOneStar = 8;
               // view.fullScore = 100;
               view.renderColor = UIColor.redColor;
               view.frame = (CGRect){30, 100, [view sizeThatFits:CGSizeMake(CGFLOAT_MAX, view.starWidth)]};
               view.selectScoreHandler = ^(CGFloat score) {
                   NSLog(@"打分 %.2f", score);
               };
               view;
           })];
```

## Custom

```
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
```

## Requirements

iOS 8 or above.

## Installation

HDRatingStarView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HDRatingStarView'
```

## Author

wangwanjie, wangwanjie1993@gmail.com

## License

HDRatingStarView is available under the MIT license. See the LICENSE file for more info.
