//
//  UIView+AutoLayout.h
//  Contact Selector
//
//  Created by CPU11815 on 3/6/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AutoLayout)

- (NSLayoutConstraint *)atWidth:(CGFloat)width;
- (NSLayoutConstraint *)atHeight:(CGFloat)height;

- (NSLayoutConstraint *)atLeftMarginTo:(UIView *)view value:(CGFloat)value;
- (NSLayoutConstraint *)atRightMarginTo:(UIView *)view value:(CGFloat)value;
- (NSLayoutConstraint *)atTopMarginTo:(UIView *)view value:(CGFloat)value;
- (NSLayoutConstraint *)atBottomMarginTo:(UIView *)view value:(CGFloat)value;

- (NSLayoutConstraint *)atCenterHorizonalInParent;
- (NSLayoutConstraint *)atCenterVerticalInParent;
- (NSArray<NSLayoutConstraint *> *)atCenterInParent;

- (NSLayoutConstraint *)atLeadingWith:(UIView *)view value:(CGFloat)value;
- (NSLayoutConstraint *)atTrailingWith:(UIView *)view value:(CGFloat)value;
- (NSLayoutConstraint *)atTopingWith:(UIView *)view value:(CGFloat)value;
- (NSLayoutConstraint *)atBottomingWith:(UIView *)view value:(CGFloat)value;

@end
