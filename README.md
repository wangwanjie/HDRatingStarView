# HDRatingStarView

高可自定义，支持任意粒度的星星点击、滑动评分，具体使用请查看 Demo

[![CI Status](https://img.shields.io/travis/wangwanjie/HDRatingStarView.svg?style=flat)](https://travis-ci.org/wangwanjie/HDRatingStarView)
[![Version](https://img.shields.io/cocoapods/v/HDRatingStarView.svg?style=flat)](https://cocoapods.org/pods/HDRatingStarView)
[![License](https://img.shields.io/cocoapods/l/HDRatingStarView.svg?style=flat)](https://cocoapods.org/pods/HDRatingStarView)
[![Platform](https://img.shields.io/cocoapods/p/HDRatingStarView.svg?style=flat)](https://cocoapods.org/pods/HDRatingStarView)

# Effect

![Effect](https://github.com/wangwanjie/HDRatingStarView/blob/master/image/demo.gif)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Use

```ObjC
HDRatingStarView *view = [[HDRatingStarView alloc] init];
view.frame = (CGRect){20, 100, [view sizeThatFits:CGSizeMake(CGFLOAT_MAX, 0)]};
view.selectScoreHandler = ^(CGFloat score) {
    NSLog(@"打分 %.2f", score);
};
[self.view addSubview:view];
```

### 直接设置分数，设置不可修改

```
starView.score = 2.5;
starView.allowTouchToSelectScore = false;
```
### 总分 100，最小粒度 10 分，开启补偿

```
starView.fullScore = 100;
starView.score = 2.5;
starView.shouldFixScore = true;
starView.allowTouchToSelectScore = false;
```

### 使用 UI 给的五角星，不使用绘制的五角星（只修改五角星形状，颜色与之无关）

```
starView.starNum = 8;
starView.itemMargin =2;
starView.renderColor = UIColor.greenColor;
starView.defaultColor = UIColor.redColor;
starView.starImage = [UIImage imageNamed:@"starUnselected"];
```

### 四颗星，总分 80 分, 打分粒度 10 分，即半星打分

```
starView.fullScore = 80;
starView.starNum = 4;
```

### (默认 5 颗星) 总分 100 分, 打分粒度 20 分，即满星打分

```
starView.fullScore = 100;
starView.countForOneStar = 100 / 20 / 5;
```

### 自定义颜色，修改间距

```
starView.itemMargin = 20;
starView.renderColor = UIColor.redColor;
starView.defaultColor = UIColor.greenColor;
```

### 支持点击、拖动打分，拖动试试

```
starView.itemMargin = 10;
starView.starNum = 6;
starView.renderColor = UIColor.yellowColor;
starView.defaultColor = UIColor.blackColor;
```

### 禁用滑动打分，只能点击打分

```
starView.allowSlideToChangeScore = false;
```

## Custom

```
/**
 * 星星图片，如果设置了将不绘制五角星
 * 设置此属性只使用该图的形状，默认颜色依旧由 defaultColor 决定
 */
@property (nonatomic, strong) UIImage *starImage;

/** 星星宽度，星星宽高相同，默认 35 */
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

/** 星星渲染颜色 */
@property (nonatomic, strong) UIColor *renderColor;

/** 星星默认颜色 */
@property (nonatomic, strong) UIColor *defaultColor;

/** 设置当前评分 */
@property (nonatomic, assign) CGFloat score;

/** 允许触摸修改评分，默认 YES */
@property (nonatomic, assign) BOOL allowTouchToSelectScore;

/**
 * 设置分数时，是否纠正分数，默认关闭
 * 比如如果设置的最小分数粒度是 0.5，当设置 1.4 分时，会自动补偿为 1.5 分
 */
@property (nonatomic, assign) BOOL shouldFixScore;

/** 是否允许滑动打分，默认开启 */
@property (nonatomic, assign) BOOL allowSlideToChangeScore;
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
