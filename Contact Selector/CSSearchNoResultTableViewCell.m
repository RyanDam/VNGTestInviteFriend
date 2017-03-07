//
//  CSSearchNoResultTableViewCell.m
//  Contact Selector
//
//  Created by CPU11815 on 2/17/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CSSearchNoResultTableViewCell.h"
#import "UIView+AutoLayout.h"

NSString * kCSSearchNoResultTableViewCellID = @"CSSearchNoResultTableViewCell";

@interface CSSearchNoResultTableViewCell ()

@property (nonatomic) UILabel * noResultLabel;

@end

@implementation CSSearchNoResultTableViewCell

+(CGFloat)getCellHeight {
    
    return 300;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUIElements];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initUIElements];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUIElements];
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUIElements];
    }
    
    return self;
}

- (void)initUIElements {
    self.noResultLabel = [[UILabel alloc] init];
    self.noResultLabel.font = [UIFont systemFontOfSize:16];
    self.noResultLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.contentView addSubview:self.noResultLabel];
    [self.noResultLabel atCenterInParent];
}

@end
