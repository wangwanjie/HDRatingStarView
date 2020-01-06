//
//  HDViewController.m
//  HDRatingStarView
//
//  Created by wangwanjie on 01/04/2020.
//  Copyright (c) 2020 wangwanjie. All rights reserved.
//

#import "HDViewController.h"
#import "HDRatingStarView.h"

@interface HDViewController ()

@end

@implementation HDViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupForTestingStarRatingView];
}

- (void)setupForTestingStarRatingView {

    UIScrollView *scrollView = ({
        UIScrollView *view = UIScrollView.new;
        view.frame = self.view.bounds;
        [self.view addSubview:view];
        view;
    });

    void (^addLabelWithTitle)(NSString *) = ^void(NSString *title) {
        UILabel *label = UILabel.new;
        label.text = title;
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = UIColor.grayColor;
        [scrollView addSubview:label];
    };

    HDRatingStarView * (^addStarRatingView)(void) = ^HDRatingStarView *(void) {
        HDRatingStarView *view = [[HDRatingStarView alloc] init];
        view.selectScoreHandler = ^(CGFloat score) {
            NSLog(@"打分 %.2f", score);
        };
        [scrollView addSubview:view];
        return view;
    };

    addLabelWithTitle(@"直接设置分数，不可修改");
    HDRatingStarView *starView = addStarRatingView();
    starView.score = 2.5;
    starView.allowTouchToSelectScore = false;

    addLabelWithTitle(@"直接设置分数，不可修改，总分 100，最小粒度 10 分，开启补偿");
    starView = addStarRatingView();
    starView.fullScore = 100;
    starView.score = 2.5;
    starView.shouldFixScore = true;
    starView.allowTouchToSelectScore = false;

    addLabelWithTitle(@"使用 UI 给的五角星，不使用绘制的五角星（只修改五角星形状，颜色与之无关）");
    starView = addStarRatingView();
    starView.starNum = 8;
    starView.itemMargin =2;
    starView.renderColor = UIColor.greenColor;
    starView.defaultColor = UIColor.redColor;
    starView.starImage = [UIImage imageNamed:@"starUnselected"];

    addLabelWithTitle(@"四颗星，总分 80 分, 打分粒度 10 分，即半星打分");
    starView = addStarRatingView();
    starView.fullScore = 80;
    starView.starNum = 4;

    addLabelWithTitle(@"(默认 5 颗星) 总分 100 分, 打分粒度 20 分，即满星打分");
    starView = addStarRatingView();
    starView.fullScore = 100;
    starView.countForOneStar = 100 / 20 / 5;

    addLabelWithTitle(@"自定义颜色，修改间距");
    starView = addStarRatingView();
    starView.itemMargin = 20;
    starView.renderColor = UIColor.redColor;
    starView.defaultColor = UIColor.greenColor;

    addLabelWithTitle(@"支持点击、拖动打分，拖动试试");
    starView = addStarRatingView();
    starView.itemMargin = 10;
    starView.starNum = 6;
    starView.renderColor = UIColor.yellowColor;
    starView.defaultColor = UIColor.blackColor;

    addLabelWithTitle(@"禁用滑动打分，只能点击打分");
    starView = addStarRatingView();
    starView.starNum = 6;
    starView.renderColor = UIColor.yellowColor;
    starView.defaultColor = UIColor.redColor;
    starView.allowSlideToChangeScore = false;

    UIView *lastView;
    for (UIView *subView in scrollView.subviews) {
        CGSize size = CGSizeZero;
        if ([subView isKindOfClass:UILabel.class]) {
            size = [subView sizeThatFits:CGSizeMake(CGRectGetWidth(scrollView.frame) - 2 * 30, CGFLOAT_MAX)];
        } else if ([subView isKindOfClass:HDRatingStarView.class]) {
            size = [subView sizeThatFits:CGSizeMake(CGFLOAT_MAX, 0)];
        }
        subView.frame = (CGRect){30, (lastView ? CGRectGetMaxY(lastView.frame) : (CGRectGetMaxY(UIApplication.sharedApplication.statusBarFrame)) + 25) + ([lastView isKindOfClass:UILabel.class] ? 10 : (!!lastView ? 30 : 0)), size};
        lastView = subView;
    }
    scrollView.contentSize = CGSizeMake(CGRectGetWidth(scrollView.frame), CGRectGetMaxY(scrollView.subviews.lastObject.frame) + 30);
}
@end
