//
//  UIView+AutoLayout.m
//  Contact Selector
//
//  Created by CPU11815 on 3/6/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UIView+AutoLayout.h"

@implementation UIView (AutoLayout)

- (NSLayoutConstraint *)atWidth:(CGFloat)width {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *widthc = [NSLayoutConstraint
                                  constraintWithItem:self
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:1.0
                                  constant:width];
    [self.superview addConstraint:widthc];
    return widthc;
}

- (NSLayoutConstraint *)atHeight:(CGFloat)height {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *heightc = [NSLayoutConstraint
                                  constraintWithItem:self
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:1.0
                                  constant:height];
    [self.superview addConstraint:heightc];
    return heightc;
}

- (NSLayoutConstraint *)atLeftMarginTo:(UIView *)view value:(CGFloat)value {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *leftMargin = [NSLayoutConstraint
                                       constraintWithItem:self
                                       attribute:NSLayoutAttributeLeft
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:view
                                       attribute:NSLayoutAttributeRight
                                       multiplier:1.0f
                                       constant:value];
    [[self superview] addConstraint:leftMargin];
    return leftMargin;
}

- (NSLayoutConstraint *)atRightMarginTo:(UIView *)view value:(CGFloat)value {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *rightMargin = [NSLayoutConstraint
                                     constraintWithItem:self
                                     attribute:NSLayoutAttributeRight
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:view
                                     attribute:NSLayoutAttributeLeft
                                     multiplier:1.0f
                                     constant:value];
    [[self superview] addConstraint:rightMargin];
    return rightMargin;
}

- (NSLayoutConstraint *)atTopMarginTo:(UIView *)view value:(CGFloat)value {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *topMargin = [NSLayoutConstraint
                                        constraintWithItem:self
                                        attribute:NSLayoutAttributeTop
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:view
                                        attribute:NSLayoutAttributeBottom
                                        multiplier:1.0f
                                        constant:value];
    [[self superview] addConstraint:topMargin];
    return topMargin;
}

- (NSLayoutConstraint *)atBottomMarginTo:(UIView *)view value:(CGFloat)value {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *bottomMargin = [NSLayoutConstraint
                                   constraintWithItem:self
                                   attribute:NSLayoutAttributeBottom
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:view
                                   attribute:NSLayoutAttributeTop
                                   multiplier:1.0f
                                   constant:value];
    [[self superview] addConstraint:bottomMargin];
    return bottomMargin;
}

- (NSLayoutConstraint *)atCenterHorizonalInParent {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint
                                   constraintWithItem:self
                                   attribute:NSLayoutAttributeCenterX
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:[self superview]
                                   attribute:NSLayoutAttributeCenterX
                                   multiplier:1.0f
                                   constant:0.f];
    [[self superview] addConstraint:centerX];
    return centerX;
}

- (NSLayoutConstraint *)atCenterVerticalInParent {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *centerY = [NSLayoutConstraint
                                   constraintWithItem:self
                                   attribute:NSLayoutAttributeCenterY
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:[self superview]
                                   attribute:NSLayoutAttributeCenterY
                                   multiplier:1.0f
                                   constant:0.f];
    [[self superview] addConstraint:centerY];
    return centerY;
}

- (NSArray<NSLayoutConstraint *> *)atCenterInParent {
    return @[[self atCenterVerticalInParent], [self atCenterHorizonalInParent]];
}

- (NSLayoutConstraint *)atLeadingWith:(UIView *)view value:(CGFloat)value {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:self
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:view
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:value];
    [self.superview addConstraint:leading];
    return leading;
}

- (NSLayoutConstraint *)atTrailingWith:(UIView *)view value:(CGFloat)value {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *trail =[NSLayoutConstraint
                              constraintWithItem:self
                              attribute:NSLayoutAttributeTrailing
                              relatedBy:NSLayoutRelationEqual
                              toItem:view
                              attribute:NSLayoutAttributeTrailing
                              multiplier:1.0f
                              constant:value];
    [self.superview addConstraint:trail];
    return trail;
}

- (NSLayoutConstraint *)atTopingWith:(UIView *)view value:(CGFloat)value {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *top =[NSLayoutConstraint
                                 constraintWithItem:self
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:view
                                 attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                 constant:value];
    [self.superview addConstraint:top];
    return top;
}

- (NSLayoutConstraint *)atBottomingWith:(UIView *)view value:(CGFloat)value {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *bottom =[NSLayoutConstraint
                                 constraintWithItem:self
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:view
                                 attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                 constant:value];
    [self.superview addConstraint:bottom];
    return bottom;
}

@end
