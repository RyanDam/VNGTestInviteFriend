//
//  CSSelectedContactCollectionViewCell.m
//  Contact Selector
//
//  Created by CPU11815 on 2/14/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CSSelectedContactCollectionViewCell.h"
#import "CSThumbnailView.h"
#import "CSContact.h"
#import "UIView+AutoLayout.h"

NSString * kCSSelectedContactCollectionViewCellID = @"CSSelectedContactCollectionViewCell";

@interface CSSelectedContactCollectionViewCell() {
    BOOL highlight;
}

@property (nonatomic) CSThumbnailView *thumbnailView;

@end

@implementation CSSelectedContactCollectionViewCell

@synthesize data = _data;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
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

- (void)initUIElements {
    
    self.clipsToBounds = YES;
    highlight = NO;
    
    self.thumbnailView = [[CSThumbnailView alloc] initWithFrame:self.frame];
    [self.contentView addSubview:self.thumbnailView];
    [self.thumbnailView atLeadingWith:self.contentView value:0];
    [self.thumbnailView atTrailingWith:self.contentView value:0];
    [self.thumbnailView atBottomingWith:self.contentView value:0];
    [self.thumbnailView atTopingWith:self.contentView value:0];
}

- (void)setData:(CSModel *)newData; {
    
    // must init child view at this time when parent view already have it's frame
    self.layer.cornerRadius = self.frame.size.height / 2.0;
    
    _data = newData;
    [self.thumbnailView setData:newData];
}

- (void)setHighlight:(BOOL)flag;{
    highlight = flag;
    [self.thumbnailView setHighlight:highlight];
}

- (void)toggleHighlight {
    [self setHighlight:!highlight];
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

@end
