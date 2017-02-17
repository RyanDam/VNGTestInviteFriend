//
//  CSSearchNoResultTableViewCell.m
//  Contact Selector
//
//  Created by CPU11815 on 2/17/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CSSearchNoResultTableViewCell.h"

NSString * kCSSearchNoResultTableViewCellID = @"CSSearchNoResultTableViewCell";

@implementation CSSearchNoResultTableViewCell

+(CGFloat)getCellHeight {
    
    return 300;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
