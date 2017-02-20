//
//  CSContactTableViewCell.m
//  Contact Selector
//
//  Created by CPU11815 on 2/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CSContactTableViewCell.h"
#import "CSThumbnailView.h"
#import "CSModel.h"

NSString * kCSContactTableViewCellID = @"CSContactTableViewCell";

@interface CSContactTableViewCell()

@property (weak, nonatomic) IBOutlet CSThumbnailView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *seperatorView;
@property (weak, nonatomic) IBOutlet UIImageView *checkboxView;

@end

@implementation CSContactTableViewCell

@synthesize data = _data;

+(CGFloat)getCellHeight {
    
    return 64;
}

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

- (void)setData:(CSModel *)newData {
    
    self.thumbnailView.layer.cornerRadius = self.thumbnailView.frame.size.height / 2.0;
    _data = newData;
    
    [self.thumbnailView setData:newData];
    self.nameLabel.text = newData.fullName;
}

- (void)showSeperator {
    
    self.seperatorView.hidden = NO;
}

- (void)hideSeperator {
    
    self.seperatorView.hidden = YES;
}

@end
