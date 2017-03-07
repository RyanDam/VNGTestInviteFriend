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

#import "UIView+AutoLayout.h"

NSString * kCSContactTableViewCellID = @"CSContactTableViewCell";

@interface CSContactTableViewCell()

@property (nonatomic) CSThumbnailView *thumbnailView;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UIView *seperatorView;
@property (nonatomic) UIImageView *checkboxView;
@property (nonatomic) NSLayoutConstraint *leftConstraintThumbnailView;

@property (nonatomic) NSInteger defaultLeftAvatarContraintValue;
@property (nonatomic) NSInteger defaultHideCheckboxContraintValue;

@property (nonatomic) BOOL checkBoxHidden;

@end

@implementation CSContactTableViewCell

@synthesize data = _data;

+(CGFloat)getCellHeight {
    
    return 64;
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
    
    self.defaultLeftAvatarContraintValue = 56;
    self.defaultHideCheckboxContraintValue = 16;
    
    self.thumbnailView = [[CSThumbnailView alloc] initWithFrame:CGRectMake(0, 0, 42, 42)];
    [self.contentView addSubview:self.thumbnailView];
    [self.thumbnailView atWidth:42];
    [self.thumbnailView atHeight:42];
    [self.thumbnailView atCenterVerticalInParent];
    self.leftConstraintThumbnailView = [self.thumbnailView atLeadingWith:self.contentView value:56];
    
    self.checkboxView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [self.contentView addSubview:self.checkboxView];
    [self.checkboxView atWidth:24];
    [self.checkboxView atHeight:24];
    [self.checkboxView atCenterVerticalInParent];
    [self.checkboxView atLeadingWith:self.contentView value:16];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f];
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel atCenterVerticalInParent];
    [self.nameLabel atLeftMarginTo:self.thumbnailView value:16];
    [self.nameLabel atTrailingWith:self.contentView value:16];
    
    self.seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 1)];
    self.seperatorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05f];
    [self.contentView addSubview:self.seperatorView];
    [self.seperatorView atHeight:1];
    [self.seperatorView atLeadingWith:self.nameLabel value:0];
    [self.seperatorView atBottomingWith:self.contentView value:0];
    [self.seperatorView atTrailingWith:self.contentView value:0];
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

- (void)allowCheckbox:(BOOL)flag {
    
    self.leftConstraintThumbnailView.constant = flag == YES ? self.defaultLeftAvatarContraintValue : self.defaultHideCheckboxContraintValue;
    self.checkboxView.hidden = !flag;
}

@end
