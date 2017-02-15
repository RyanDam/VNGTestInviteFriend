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
    
//    if (selected) {
//        [self setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:0 alpha:1]];
//        [self setAccessibilityTraits:UIAccessibilityTraitSelected];
//        
//        self.selectedBackgroundView.backgroundColor = [UIColor blackColor];
//        self.multipleSelectionBackgroundView.backgroundColor = [UIColor greenColor];
//        
//    } else {
//        [self setBackgroundColor:[UIColor clearColor]];
//        [self setAccessibilityTraits:UIAccessibilityTraitNone];
//    }
}

- (void)setContact:(CSContact *)newContact {
    
    self.thumbnailView.layer.cornerRadius = self.thumbnailView.frame.size.height / 2.0;
    _contact = newContact;
    
    [self.thumbnailView setContact:newContact];
    self.nameLabel.text = newContact.fullname;
}

@end
