//
//  CSCheckbox.m
//  Contact Selector
//
//  Created by CPU11815 on 2/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CSCheckbox.h"

#define PI 3.14159265359
#define   DEGREES_TO_RADIANS(degrees)  ((PI * degrees)/ 180)

#define CHECKED YES
#define UNCHECK NO

@interface CSCheckbox()

@property (nonatomic) UIColor * circleColor;
@property (nonatomic) UIColor * tickColor;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) BOOL checked;

@end

@implementation CSCheckbox

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
        return self;
    }
    return nil;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initView];
        return self;
    }
    return nil;
}

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        return self;
    }
    return nil;
}

- (void) initView {
    self.circleColor = [UIColor colorWithRed:80.0/255.0 green:187.0/255.0 blue:216.0/255.0 alpha:1.0];
    self.tickColor = [UIColor whiteColor];
    self.lineWidth = 1.0;
    self.checked = UNCHECK;
}

- (void)setCheck:(BOOL)flag {
    self.checked = flag;
    [self layoutIfNeeded];
}

- (void) drawRect:(CGRect)rect {
    
    CGPoint center = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0);
    CGFloat radius = (rect.size.width > rect.size.height ? rect.size.height : rect.size.width) - self.lineWidth * 2.0;
    
    UIBezierPath * bigCircle = [UIBezierPath bezierPathWithArcCenter:center radius:radius / 2.0 startAngle:0 endAngle:DEGREES_TO_RADIANS(360) clockwise:YES];
    bigCircle.lineWidth = self.lineWidth;
    
    [self.circleColor set];
    
    if (self.checked) {
        [bigCircle fill];
    } else {
        [bigCircle stroke];
    }
    
    CGFloat deltaBottomTickWithCenter = center.y * (1.414 - 1.0);
    CGPoint bottomTickPoint = CGPointMake(center.x, center.y + deltaBottomTickWithCenter * 0.8);
    CGPoint leftTickPoint = CGPointMake(center.x - deltaBottomTickWithCenter, center.y);
    CGPoint rightTickPoint = CGPointMake(center.x + deltaBottomTickWithCenter*1.2, center.y - deltaBottomTickWithCenter*0.8);
    
    if (self.checked) {
        UIBezierPath * tickPath = [UIBezierPath bezierPath];
        tickPath.lineWidth = self.lineWidth;
        
        [tickPath moveToPoint:leftTickPoint];
        [tickPath addLineToPoint:bottomTickPoint];
        [tickPath addLineToPoint:rightTickPoint];
        
        [self.tickColor set];
        [tickPath stroke];
    }
}

@end
