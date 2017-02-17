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

/**
 Set contact data

 @param contact input
 */
- (void)setContact:(CSContact *)contact;

/**
 Set a semi-white mask on top of view for highlighting

 @param flag YES or NO
 */
- (void)setHighlight:(BOOL)flag;

@end
