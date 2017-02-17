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
@property (weak, nonatomic) IBOutlet UIView *seperatorView;
@property (weak, nonatomic) IBOutlet UIImageView *checkboxView;

@end

@implementation CSContactTableViewCell

@synthesize contact = _contact;

- (void)awakeFromNib {
    [super awakeFromNib];
}


/**
 This is for prevent flickering when tap on table cell
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    UIColor *color = self.thumbnailView.backgroundColor;
    [super setSelected:selected animated:animated];
    
    if (selected){
        self.thumbnailView.backgroundColor = color;
    }
}

/**
 This is for prevent flickering when tap on table cell
 */
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    UIColor *color = self.thumbnailView.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted){
        self.thumbnailView.backgroundColor = color;
    }
}

- (void)setSelect:(BOOL)flag {
    if (flag) {
        self.checkboxView.image = [UIImage imageNamed:@"selectedCheck"];
    } else {
        self.checkboxView.image = [UIImage imageNamed:@"unselectedCheck"];
    }
}

- (void)setContact:(CSContact *)newContact {
    
    self.thumbnailView.layer.cornerRadius = self.thumbnailView.frame.size.height / 2.0;
    _contact = newContact;
    
    [self.thumbnailView setContact:newContact];
    self.nameLabel.text = newContact.fullname;
}

- (void)showSeperator {
    self.seperatorView.hidden = NO;
}

- (void)hideSeperator {
    self.seperatorView.hidden = YES;
}

@end
