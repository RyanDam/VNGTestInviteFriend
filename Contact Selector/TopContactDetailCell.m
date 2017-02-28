//
//  TopContactDetailCell.m
//  Contact Selector
//
//  Created by CPU11815 on 2/27/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "TopContactDetailCell.h"
#import "CSContact.h"
#import "CSThumbnailEngine.h"

@interface TopContactDetailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation TopContactDetailCell

@synthesize model = _model;

+ (CGFloat)getHeight {
    return 230;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarView.layer.cornerRadius = 60;
    self.avatarView.clipsToBounds = YES;
}

- (void)setModel:(CSContact *)newModel {
    _model = newModel;
    
    if (newModel) {
        if (newModel.avatar) {
            self.avatarView.image = newModel.avatar;
        } else {
            [self.avatarView setThumbnailText:[newModel shortName] withCompletion:nil];
        }
        self.nameLabel.text = newModel.fullName;
        if (newModel.phoneNumbers.count > 0) {
            self.phoneLabel.text = newModel.phoneNumbers[0];
        } else {
            self.phoneLabel.text = @"";
        }
    }
}

@end
