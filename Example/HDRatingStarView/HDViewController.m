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
}
@end
