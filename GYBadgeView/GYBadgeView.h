//
//  GYBadgeView.h
//  GYBadgeView
//
//  Created by Yalay Gu on 2018/10/25.
//  Copyright © 2018年 Yalay Gu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 badge 样式
 badge style
 */
typedef NS_ENUM(NSUInteger, GYBadgeViewStyle) {
    GYBadgeViewStyleNormal,//普通的
    GYBadgeViewStyleGradient //渐变色
};

/**
 badge 字体样式
 badge show text style
 */
typedef NS_ENUM(NSUInteger, GYBadgeViewTextStyle) {
    GYBadgeViewTextStyleNumber,//数字类型的
    GYBadgeViewTextStyleDot //圆点类型的
};

/**
 badge 渐变色 渐变方向
 badge gradient direction
 */
typedef NS_ENUM(NSUInteger, GYBadgeViewGradientDirection) {
    GYBadgeViewGradientVertical,//竖直渐变
    GYBadgeViewGradientHorizontal,//水平渐变
};

NS_ASSUME_NONNULL_BEGIN

@interface GYBadgeView : UIView

/**
 数字顶部/底部到红圈的距离
 badge text top/bottom to badge margin
 */
@property (nonatomic, assign) CGFloat badgeVerticalPadding;

/**
 数字左部/右部到红圈的距离
 badge text left/right to badge margin
 */
@property (nonatomic, assign) CGFloat badgeHorizontalPadding;

/**
 背景颜色
 badge backgroundCorlor
 */
@property (nonatomic, strong) UIColor *badgeBackgroundColor;

/**
 渐变颜色 如果设置 badgeBackgroundColor将无效
 gradient corlors  if set, badgeBackgroundColor is unuseful.
 */
@property (nonatomic, copy) NSArray <UIColor *> *gradientColors;

/**
 渐变颜色 位置
 gradient locations
 */
@property (nonatomic, copy) NSArray <NSNumber *> *gradientLocations;

/**
 数字颜色
 badge textCorlor
 */
@property (nonatomic, strong) UIColor *badgeTextColor;

/**
 数字字体
 badge textFont
 */
@property (nonatomic, strong) UIFont *badgeTextFont;

/**
 外部的圆圈宽度
 edge cirle width
 */
@property (nonatomic, assign) CGFloat edgeCircleWidth;

/**
 外部圆圈的颜色
 edge cirle corlor
 */
@property (nonatomic, strong) UIColor *edgeCirleColor;

/**
 如果是圆点样式的话，需要的尺寸
 if badgeStyle is GYBadgeViewTextStyleDot, can set badge dot size.
 */
@property (nonatomic, assign) CGFloat badgeDotSize;

/**
 字体样式
 badge show text style
 */
@property (nonatomic, assign) GYBadgeViewTextStyle textStyle;

/**
 样式
 badge style
 */
@property (nonatomic, assign) GYBadgeViewStyle badgeStyle;

/**
 渐变方向
 gradient direction
 */
@property (nonatomic, assign) GYBadgeViewGradientDirection gradientDirection;

/**
 设置的数字的最大值 默认无穷大
 set badge max value, if nor set, default is NSIntegerMax.
 */
@property (nonatomic, assign) NSInteger maxBadgeValue;

/**
 超过最大值得时候，展示的内容
 when the badge value is over max, you can custom the value showing.
 */
@property (nonatomic, copy) NSString *overMaxShowValue;

/**
 设置的数字 如果要自定义UI一定要设置好参数再赋值
 set badge value, if you want to change frame, you should set badgeValue first.
 */
@property (nonatomic, assign) NSInteger badgeValue;

- (instancetype)initWithBadgeStyle:(GYBadgeViewStyle)badgeStyle textStyle:(GYBadgeViewTextStyle)textStyle;

+ (instancetype)badgeViewWithStyle:(GYBadgeViewStyle)badgeStyle textStyle:(GYBadgeViewTextStyle)textStyle;

@end

NS_ASSUME_NONNULL_END
