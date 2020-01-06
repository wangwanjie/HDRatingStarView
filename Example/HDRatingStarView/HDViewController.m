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
               view.frame = (CGRect){30, 100, [view sizeThatFits:CGSizeMake(CGFLOAT_MAX, 0)]};
               view.selectScoreHandler = ^(CGFloat score) {
                   NSLog(@"打分 %.2f", score);
               };
               view;
           })];

[self.view addSubview:({
               HDRatingStarView *view = [[HDRatingStarView alloc] init];
               view.starImage = [UIImage imageNamed:@"starUnselected"];
               view.starNum = 8;
               view.itemMargin = 0;
               view.countForOneStar = 8;
               view.fullScore = 100;
               view.renderColor = UIColor.redColor;
               view.defaultColor = UIColor.blueColor;
               view.frame = (CGRect){30, 180, [view sizeThatFits:CGSizeMake(CGFLOAT_MAX, 0)]};
               view.selectScoreHandler = ^(CGFloat score) {
                   NSLog(@"打分 %.2f", score);
               };
               view;
           })];
}
@end
