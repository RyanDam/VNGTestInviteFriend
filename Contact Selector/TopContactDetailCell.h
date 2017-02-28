//
//  TopContactDetailCell.h
//  Contact Selector
//
//  Created by CPU11815 on 2/27/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSContact;

@interface TopContactDetailCell : UITableViewCell

@property (nonatomic) CSContact * model;

+ (CGFloat)getHeight;

@end
