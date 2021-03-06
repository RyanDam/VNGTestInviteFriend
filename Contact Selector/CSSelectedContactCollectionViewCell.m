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

NSString * kCSSelectedContactCollectionViewCellID = @"CSSelectedContactCollectionViewCell";

@interface CSSelectedContactCollectionViewCell() {
    BOOL highlight;
}

@property (weak, nonatomic) IBOutlet CSThumbnailView *thumbnailView;

@end

@implementation CSSelectedContactCollectionViewCell

@synthesize data = _data;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.clipsToBounds = YES;
    highlight = NO;
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
