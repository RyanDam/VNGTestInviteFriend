//
//  BlockPhoneTableViewCell.h
//  Contact Selector
//
//  Created by CPU11815 on 2/27/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * kBlockPhoneTableViewCellID;

typedef NS_ENUM(NSInteger, BlockPhoneCellState) {
    BlockPhoneCellStateName,
    BlockPhoneCellStateNumber
};

@class CSContact;

@interface BlockPhoneTableViewCell : UITableViewCell

@property (nonatomic) BlockPhoneCellState cellState;

@property (nonatomic) CSContact * model;

- (void)becomeFirstResponser;

@end
