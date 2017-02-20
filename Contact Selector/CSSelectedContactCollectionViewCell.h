//
//  CSSelectedContactCollectionViewCell.h
//  Contact Selector
//
//  Created by CPU11815 on 2/14/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * kCSSelectedContactCollectionViewCellID;

@class CSModel;

@interface CSSelectedContactCollectionViewCell : UICollectionViewCell

@property (nonatomic) CSModel * data;

/**
 Set data for this cell

 @param newData input data
 */
- (void)setData:(CSModel *)newData;

/**
 Highight cell

 @param flag YES or NO
 */
- (void)setHighlight:(BOOL)flag;

/**
 Toggle highlight state
 */
- (void)toggleHighlight;

@end
