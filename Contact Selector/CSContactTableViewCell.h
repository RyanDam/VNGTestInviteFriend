//
//  CSContactTableViewCell.h
//  Contact Selector
//
//  Created by CPU11815 on 2/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * kCSContactTableViewCellID;

@class CSModel;

@interface CSContactTableViewCell : UITableViewCell

@property (nonatomic) CSModel * data;

+(CGFloat)getCellHeight;

/**
 Mark cell as selected of unselected

 @param flag YES or NO
 */
- (void)setSelect:(BOOL)flag;

/**
 Show seperator between cells
 */
- (void)showSeperator;

/**
 Hide seperator between cells
 */
- (void)hideSeperator;

@end
