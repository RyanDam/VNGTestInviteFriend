//
//  CSContactTableViewCell.m
//  Contact Selector
//
//  Created by CPU11815 on 2/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CSContactTableViewCell.h"
#import "CSThumbnailView.h"
#import "CSContact.h"

NSString * kCSContactTableViewCellID = @"CSContactTableViewCell";

@interface CSContactTableViewCell()

@property (weak, nonatomic) IBOutlet CSThumbnailView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation CSContactTableViewCell

@synthesize contact = _contact;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.thumbnailView resetBackColor];
    }
    
}

- (void)setContact:(CSContact *)newContact {
    
    [self bringSubviewToFront:self.thumbnailView];
    
    self.thumbnailView.layer.cornerRadius = self.thumbnailView.frame.size.height / 2.0;
    _contact = newContact;
    
    [self.thumbnailView setContact:newContact];
    self.nameLabel.text = newContact.fullname;
}

@end
