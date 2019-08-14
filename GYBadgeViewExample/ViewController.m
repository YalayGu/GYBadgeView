//
//  ViewController.m
//  GYBadgeViewExample
//
//  Created by Yalay Gu on 2019/8/13.
//  Copyright © 2019 Yalay Gu. All rights reserved.
//

#import "ViewController.h"
#import "GYBadgeView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGFloat margin = 25;
    for (NSInteger index = 10; index < 30; index++) {
        GYBadgeView *badgeView = [GYBadgeView badgeViewWithStyle:index % 2 == 0 ? GYBadgeViewStyleGradient : GYBadgeViewStyleNormal textStyle:index % 2 == 0 ? GYBadgeViewTextStyleNumber : GYBadgeViewTextStyleDot];
        badgeView.frame = CGRectMake((index / 10 + index % 3) * (margin + 30), (index / 3) * (50 + margin) - 140, 10, 10);
        if (badgeView.textStyle == GYBadgeViewTextStyleNumber) {
//            badgeView.badgeVerticalPadding = 4;
//            badgeView.badgeHorizontalPadding = 8;
            badgeView.badgeValue = index;
        } else {
            badgeView.badgeDotSize = 20;
        }
        [self.view addSubview:badgeView];
    }
    
    [self.view.subviews.lastObject setValue:UIColor.blueColor forKeyPath:@"badgeBackgroundColor"];
    GYBadgeView *badgeView = self.view.subviews[self.view.subviews.count - 2];
    badgeView.badgeTextColor = UIColor.cyanColor;
    badgeView.badgeValue = 10000;
    badgeView.maxBadgeValue = 999;
//    badgeView.overMaxShowValue = @"999...";
}


@end
