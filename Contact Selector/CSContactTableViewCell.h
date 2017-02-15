//
//  CSContactTableViewCell.h
//  Contact Selector
//
//  Created by CPU11815 on 2/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * kCSContactTableViewCellID;

@class CSContact;

@interface CSContactTableViewCell : UITableViewCell

@property (nonatomic) CSContact * contact;

@end
