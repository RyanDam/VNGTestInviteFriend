//
//  CSSelectedContactCollectionViewCell.h
//  Contact Selector
//
//  Created by CPU11815 on 2/14/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * kCSSelectedContactCollectionViewCellID;

@class CSContact;

@interface CSSelectedContactCollectionViewCell : UICollectionViewCell

@property (nonatomic) CSContact * contact;

- (void)setContact:(CSContact *)newContact;

- (void)setHighlight:(BOOL)flag;

- (void)toggleHighlight;

@end
