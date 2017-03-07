//
//  UIView+AutoLayout.m
//  Contact Selector
//
//  Created by CPU11815 on 3/6/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UIView+AutoLayout.h"

@implementation UIView (AutoLayout)

- (void)atWidth:(CGFloat)width {
    NSLayoutConstraint *widthc = [NSLayoutConstraint
                                  constraintWithItem:self
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:1.0
                                  constant:width];
    [self addConstraint:widthc];
}
- (void)atHeight:(CGFloat)height {
    NSLayoutConstraint *heightc = [NSLayoutConstraint
                                  constraintWithItem:self
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:1.0
                                  constant:height];
    [self addConstraint:heightc];
}

- (void)atLeftMarginTo:(UIView *)view value:(CGFloat)value {
    NSLayoutConstraint *leftMargin = [NSLayoutConstraint
                                       constraintWithItem:self
                                       attribute:NSLayoutAttributeLeft
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:view
                                       attribute:NSLayoutAttributeRight
                                       multiplier:1.0f
                                       constant:value];
    [[self superview] addConstraint:leftMargin];
}

- (void)atRightMarginTo:(UIView *)view value:(CGFloat)value {
    NSLayoutConstraint *rightMargin = [NSLayoutConstraint
                                     constraintWithItem:self
                                     attribute:NSLayoutAttributeRight
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:view
                                     attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                     constant:value];
    [[self superview] addConstraint:rightMargin];
}

- (void)atTopMarginTo:(UIView *)view value:(CGFloat)value {
    NSLayoutConstraint *topMargin = [NSLayoutConstraint
                                        constraintWithItem:self
                                        attribute:NSLayoutAttributeTop
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:view
                                        attribute:NSLayoutAttributeBottom
                                        multiplier:1.0f
                                        constant:value];
    [[self superview] addConstraint:topMargin];
}

- (void)atBottomMarginTo:(UIView *)view value:(CGFloat)value {
    NSLayoutConstraint *bottomMargin = [NSLayoutConstraint
                                   constraintWithItem:self
                                   attribute:NSLayoutAttributeBottom
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:view
                                   attribute:NSLayoutAttributeTop
                                   multiplier:1.0f
                                   constant:value];
    [[self superview] addConstraint:bottomMargin];
}

- (void)atCenterHorizonalInParent {
    NSLayoutConstraint *centerX = [NSLayoutConstraint
                                   constraintWithItem:self
                                   attribute:NSLayoutAttributeCenterX
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:[self superview]
                                   attribute:NSLayoutAttributeCenterX
                                   multiplier:1.0f
                                   constant:0.f];
    [[self superview] addConstraint:centerX];
}

- (void)atCenterVerticalInParent {
    NSLayoutConstraint *centerY = [NSLayoutConstraint
                                   constraintWithItem:self
                                   attribute:NSLayoutAttributeCenterY
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:[self superview]
                                   attribute:NSLayoutAttributeCenterY
                                   multiplier:1.0f
                                   constant:0.f];
    [[self superview] addConstraint:centerY];
}

- (void)atCenterInParent {
    [self atCenterVerticalInParent];
    [self atCenterHorizonalInParent];
}

- (void)atLeadingWith:(UIView *)view value:(CGFloat)value {
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:self
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:view
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:value];
    [view addConstraint:leading];
}

- (void)atTrailingWith:(UIView *)view value:(CGFloat)value {
    NSLayoutConstraint *trail =[NSLayoutConstraint
                              constraintWithItem:self
                              attribute:NSLayoutAttributeTrailing
                              relatedBy:NSLayoutRelationEqual
                              toItem:view
                              attribute:NSLayoutAttributeTrailing
                              multiplier:1.0f
                              constant:value];
    [view addConstraint:trail];
}

- (void)atTopingWith:(UIView *)view value:(CGFloat)value {
    NSLayoutConstraint *top =[NSLayoutConstraint
                                 constraintWithItem:self
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:view
                                 attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                 constant:value];
    [view addConstraint:top];
}

- (void)atBottomingWith:(UIView *)view value:(CGFloat)value {
    NSLayoutConstraint *bottom =[NSLayoutConstraint
                                 constraintWithItem:self
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:view
                                 attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                 constant:value];
    [view addConstraint:bottom];
}

@end
