//
//  GYBadgeView.m
//  GYBadgeView
//
//  Created by Yalay Gu on 2018/10/25.
//  Copyright © 2018年 Yalay Gu. All rights reserved.
//

#import "GYBadgeView.h"

@interface GYBadgeView ()

@property (nonatomic, copy) NSString *badgeValueString;

/**
 数字顶部/底部到红圈的距离
 the copy of vertical padding
 */
@property (nonatomic, assign) CGFloat lastBadgeVerticalPadding;

/**
 数字左部/右部到红圈的距离
 the copy of horizontal padding
 */
@property (nonatomic, assign) CGFloat lastBadgeHorizontalPadding;

@property (nonatomic, assign) BOOL isNeedsUpdateBadgeLayout;
@property (nonatomic, assign) BOOL isNeedsUpdateBadgeAppearance;

@end

@implementation GYBadgeView

+ (instancetype)badgeView:(GYBadgeViewStyle)badgeStyle textStyle:(GYBadgeViewTextStyle)textStyle
{
    return [[self alloc] initWithBadgeStyle:badgeStyle textStyle:textStyle];
}

- (instancetype)initWithBadgeStyle:(GYBadgeViewStyle)badgeStyle textStyle:(GYBadgeViewTextStyle)textStyle
{
    if (self = [super init]) {
        self.backgroundColor  = [UIColor clearColor];
        _badgeValueString = @"";
        _isNeedsUpdateBadgeLayout = NO;
        _isNeedsUpdateBadgeAppearance = NO;
        _badgeStyle = badgeStyle;
        _textStyle = textStyle;
        [self someDefaultConfig];
    }
    return self;
}

+ (instancetype)badgeViewWithStyle:(GYBadgeViewStyle)badgeStyle textStyle:(GYBadgeViewTextStyle)textStyle
{
    return [[self alloc] initWithBadgeStyle:badgeStyle textStyle:textStyle];
}

- (void)someDefaultConfig
{
    _maxBadgeValue = NSIntegerMax;
    _badgeDotSize = 8.;
    _badgeTextFont = [UIFont boldSystemFontOfSize:11];
    
    _badgeVerticalPadding = 1;
    _lastBadgeVerticalPadding = 1;
    _badgeHorizontalPadding = 4;
    _lastBadgeHorizontalPadding = 4;
    
    _badgeBackgroundColor = UIColor.redColor;
    _badgeTextColor = UIColor.whiteColor;
    _edgeCirleColor = UIColor.whiteColor;
    _gradientColors = @[[UIColor.redColor colorWithAlphaComponent:0.8], [UIColor.redColor colorWithAlphaComponent:0.1]];
    _gradientLocations = @[@(0.0), @(0.6)];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    if (self.badgeValue && (self.textStyle == GYBadgeViewTextStyleNumber)) {
        [self drawFullContentWithContext:context];
    }else{
        [self drawEmptyContentWithContext:context];
    }
    CGContextRestoreGState(context);
}


#pragma mark - setter

- (void)setBadgeValue:(NSInteger)badgeValue
{
    _badgeValue = badgeValue;
    [self setNeedsUpdateBadgeLayout];
}

- (void)setTextStyle:(GYBadgeViewTextStyle)textStyle
{
    _textStyle = textStyle;
    [self setNeedsUpdateBadgeLayout];
}

- (void)setBadgeStyle:(GYBadgeViewStyle)badgeStyle
{
    _badgeStyle = badgeStyle;
    [self setNeedsUpdateBadgeLayout];
}

- (void)setBadgeDotSize:(CGFloat)badgeDotSize
{
    _badgeDotSize = badgeDotSize;
    [self setNeedsUpdateBadgeLayout];
}

- (void)setBadgeVerticalPadding:(CGFloat)badgeVerticalPadding
{
    _badgeVerticalPadding = badgeVerticalPadding;
    _lastBadgeVerticalPadding = _badgeVerticalPadding;
    [self setNeedsUpdateBadgeLayout];
}

- (void)setBadgeHorizontalPadding:(CGFloat)badgeHorizontalPadding
{
    _badgeHorizontalPadding = badgeHorizontalPadding;
    _lastBadgeHorizontalPadding = _badgeHorizontalPadding;
    [self setNeedsUpdateBadgeLayout];
}

- (void)setEdgeCircleWidth:(CGFloat)edgeCircleWidth
{
    _edgeCircleWidth = edgeCircleWidth;
    [self setNeedsUpdateBadgeLayout];
}

- (void)setBadgeTextFont:(UIFont *)badgeTextFont
{
    _badgeTextFont = badgeTextFont;
    [self setNeedsUpdateBadgeLayout];
}

- (void)setMaxBadgeValue:(NSInteger)maxBadgeValue
{
    _maxBadgeValue = maxBadgeValue;
    [self setNeedsUpdateBadgeLayout];
}

- (void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor
{
    _badgeBackgroundColor = badgeBackgroundColor;
    [self setNeedsUpdateBadgeAppearance];
}

- (void)setBadgeTextColor:(UIColor *)badgeTextColor
{
    _badgeTextColor = badgeTextColor;
    [self setNeedsUpdateBadgeAppearance];
}

- (void)setEdgeCirleColor:(UIColor *)edgeCirleColor
{
    _edgeCirleColor = edgeCirleColor;
    [self setNeedsUpdateBadgeAppearance];
}

- (void)setGradientColors:(NSArray<UIColor *> *)gradientColors
{
    _gradientColors = gradientColors;
    [self setNeedsUpdateBadgeAppearance];
}

- (void)setGradientLocations:(NSArray<NSNumber *> *)gradientLocations
{
    _gradientLocations = gradientLocations;
    [self setNeedsUpdateBadgeAppearance];
}

- (void)setGradientDirection:(GYBadgeViewGradientDirection)gradientDirection
{
    _gradientDirection = gradientDirection;
    [self setNeedsUpdateBadgeAppearance];
}

- (void)setOverMaxShowValue:(NSString *)overMaxShowValue
{
    if (_overMaxShowValue != overMaxShowValue) {
        _overMaxShowValue = overMaxShowValue;
        if (self.badgeValue > self.maxBadgeValue) {
            [self setNeedsUpdateBadgeLayout];
        }
    }
}

#pragma mark - update layout

- (void)setNeedsUpdateBadgeLayout
{
    self.isNeedsUpdateBadgeLayout = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateBadgeLayoutIfNeeded];
    });
}

- (void)updateBadgeLayoutIfNeeded
{
    if (self.isNeedsUpdateBadgeLayout) {
        self.isNeedsUpdateBadgeLayout = NO;
        if (self.badgeValue > self.maxBadgeValue) {
            self.badgeValueString = self.overMaxShowValue ?: [NSString stringWithFormat:@"%ld+", self.maxBadgeValue];
        } else {
            self.badgeValueString = [NSString stringWithFormat:@"%ld", self.badgeValue];
        }
        if (self.badgeValue < 10) {
            CGFloat roundPadding = MIN(self.badgeVerticalPadding, self.badgeHorizontalPadding);
            _badgeVerticalPadding = _badgeHorizontalPadding = roundPadding;
        } else {
            _badgeVerticalPadding = self.lastBadgeVerticalPadding;
            _badgeHorizontalPadding = self.lastBadgeHorizontalPadding;
        }
        self.frame = [self frameToFitWithBadgeValue:self.badgeValueString];
        [self setNeedsDisplay];
    }
}

#pragma mark - update appearance

- (void)setNeedsUpdateBadgeAppearance
{
    self.isNeedsUpdateBadgeAppearance = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.isNeedsUpdateBadgeAppearance) {
            self.isNeedsUpdateBadgeAppearance = NO;
            [self setNeedsDisplay];
        }
    });
}

#pragma mark - size

/**
 根据传入的内容判断badge Frame
 get frame by badge value
 */
- (CGRect)frameToFitWithBadgeValue:(NSString *)badgeValue
{
    CGSize badgeSize = CGSizeZero;
    if (self.textStyle == GYBadgeViewTextStyleNumber) {
        badgeSize = [badgeValue sizeWithAttributes:@{NSFontAttributeName:self.badgeTextFont}];
        if (badgeSize.width < badgeSize.height) {
            badgeSize = CGSizeMake(badgeSize.height, badgeSize.height);
        }
        badgeSize = CGSizeMake(badgeSize.width + self.badgeHorizontalPadding * 2 + self.edgeCircleWidth * 2, badgeSize.height + self.badgeVerticalPadding * 2 + self.edgeCircleWidth * 2);
    } else {
        badgeSize = CGSizeMake(self.badgeDotSize, self.badgeDotSize);
    }
    return (CGRect){self.frame.origin, badgeSize};
}

#pragma mark - draw context

/**
 有数字的绘制
 text style is number draw
 */
- (void)drawFullContentWithContext:(CGContextRef)context
{
    CGRect fullBounds = self.bounds;
    CGRect backGroundFrame = CGRectInset(self.bounds, self.edgeCircleWidth, self.edgeCircleWidth);
    CGRect badgeFrame = CGRectInset(self.bounds, self.edgeCircleWidth + self.badgeHorizontalPadding, self.edgeCircleWidth + self.badgeVerticalPadding);
    CGContextSetFillColorWithColor(context, self.edgeCirleColor.CGColor);
    if (self.badgeValue > 9) {
        CGFloat circleWith = fullBounds.size.height;
        CGFloat totalWidth = fullBounds.size.width;
        CGFloat diffWidth = totalWidth - circleWith;
        CGPoint originPoint = fullBounds.origin;
        CGRect leftCicleFrame = CGRectMake(originPoint.x, originPoint.y, circleWith, circleWith);
        CGRect centerFrame = CGRectMake(originPoint.x +circleWith/2, originPoint.y, diffWidth, circleWith);
        CGRect rightCicleFrame = CGRectMake(originPoint.x +(totalWidth - circleWith), originPoint.y, circleWith, circleWith);
        CGContextFillEllipseInRect(context, leftCicleFrame);
        CGContextFillRect(context, centerFrame);
        CGContextFillEllipseInRect(context, rightCicleFrame);
    }else{
        CGContextFillEllipseInRect(context, fullBounds);
    }
    // badge background color
    CGContextSetFillColorWithColor(context, self.badgeBackgroundColor.CGColor);
    CGFloat circleWith = backGroundFrame.size.height;
    if (self.badgeValue > 9) {
        CGFloat totalWidth = backGroundFrame.size.width;
        CGFloat diffWidth = totalWidth - circleWith;
        CGPoint originPoint = backGroundFrame.origin;
        CGRect leftCicleFrame = CGRectMake(originPoint.x, originPoint.y, circleWith, circleWith);
        CGRect centerFrame = CGRectMake(originPoint.x +circleWith/2, originPoint.y, diffWidth, circleWith);
        CGRect rightCicleFrame = CGRectMake(originPoint.x +(totalWidth - circleWith), originPoint.y, circleWith, circleWith);
        CGContextFillEllipseInRect(context, leftCicleFrame);
        CGContextFillRect(context, centerFrame);
        CGContextFillEllipseInRect(context, rightCicleFrame);
    }else{
        CGContextFillEllipseInRect(context, backGroundFrame);
    }
    if (self.badgeStyle == GYBadgeViewStyleGradient) {
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:backGroundFrame cornerRadius:circleWith];
        [bezierPath addClip];
        CGFloat gradientCount = MIN(self.gradientColors.count, self.gradientLocations.count);
        NSMutableArray *tempColors = [NSMutableArray array];
        for (NSInteger index = 0; index < gradientCount; index++) {
            [tempColors addObject:(__bridge id)self.gradientColors[index].CGColor];
        }
        CGFloat locations[self.gradientLocations.count];
        for (NSInteger index = 0; index < self.gradientLocations.count; index++) {
            locations[index] = self.gradientLocations[index].floatValue;
        }
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)tempColors.copy, locations);
        CGContextClip(context);
        
        CGPoint startPoint = CGPointMake(0, 0);
        CGPoint endPoint = CGPointMake(self.gradientDirection == GYBadgeViewGradientHorizontal ? fullBounds.size.width : 0, self.gradientDirection == GYBadgeViewGradientHorizontal ? 0 : fullBounds.size.height);
        CGContextDrawLinearGradient (context, gradient, startPoint, endPoint, 0);
        CGColorSpaceRelease(colorSpace);
        CGGradientRelease(gradient);
    }
    
    CGContextSetFillColorWithColor(context, [[self badgeTextColor] CGColor]);
    NSMutableParagraphStyle *badgeTextStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    [badgeTextStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [badgeTextStyle setAlignment:NSTextAlignmentCenter];
    NSDictionary *badgeTextAttributes = @{
                                          NSFontAttributeName: self.badgeTextFont,
                                          NSForegroundColorAttributeName: self.badgeTextColor,
                                          NSParagraphStyleAttributeName: badgeTextStyle,
                                          };
    [self.badgeValueString drawInRect:CGRectMake(self.edgeCircleWidth + self.badgeHorizontalPadding,
                                                 self.edgeCircleWidth + self.badgeVerticalPadding,
                                                 badgeFrame.size.width, badgeFrame.size.height)
                       withAttributes:badgeTextAttributes];
}

/**
 数字为0或者无数字的绘制
 text style is dot draw
 */
- (void)drawEmptyContentWithContext:(CGContextRef)context
{
    CGRect fullBounds = self.bounds;
    CGContextSetFillColorWithColor(context, [self.badgeBackgroundColor CGColor]);
    CGContextFillEllipseInRect(context, fullBounds);
}

@end
