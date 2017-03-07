//
//  UIView+AutoLayout.h
//  Contact Selector
//
//  Created by CPU11815 on 3/6/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AutoLayout)

- (void)atWidth:(CGFloat)width;
- (void)atHeight:(CGFloat)height;

- (void)atLeftMarginTo:(UIView *)view value:(CGFloat)value;
- (void)atRightMarginTo:(UIView *)view value:(CGFloat)value;
- (void)atTopMarginTo:(UIView *)view value:(CGFloat)value;
- (void)atBottomMarginTo:(UIView *)view value:(CGFloat)value;

- (void)atCenterHorizonalInParent;
- (void)atCenterVerticalInParent;
- (void)atCenterInParent;

- (void)atLeadingWith:(UIView *)view value:(CGFloat)value;
- (void)atTrailingWith:(UIView *)view value:(CGFloat)value;
- (void)atTopingWith:(UIView *)view value:(CGFloat)value;
- (void)atBottomingWith:(UIView *)view value:(CGFloat)value;

@end
