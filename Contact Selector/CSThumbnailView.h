//
//  CSThumbnailView.h
//  Contact Selector
//
//  Created by CPU11815 on 2/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSContact;

@interface CSThumbnailView : UIView

- (void)setContact:(CSContact *)contact;

- (void)setHighlight:(BOOL)flag;

@end
