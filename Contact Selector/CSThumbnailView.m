//
//  CSThumbnailView.m
//  Contact Selector
//
//  Created by CPU11815 on 2/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CSThumbnailView.h"
#import "CSContact.h"

@interface CSThumbnailView() {
    NSUInteger textSize;
}

@property (nonatomic) UIColor * baseColor;
@property (nonatomic) UIColor * textColor;
@property (nonatomic) UILabel * textContentView;
@property (nonatomic) UIImageView * avatarView;
@property (nonatomic) UIView * highlightView;

@end

@implementation CSThumbnailView

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
        return self;
    }
    return nil;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initView];
        return self;
    }
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        return self;
    }
    return nil;
}

- (void)initView {
    
    self.textColor = [UIColor whiteColor];
    self.baseColor = [UIColor colorWithRed:231.0/255.0 green:189.0/255.0 blue:151.0/255.0 alpha:1.0];
    self.clipsToBounds = YES;
    textSize = 20;
}

- (void)setContact:(CSContact *)contact {
    
    if (contact.avatar == nil) {
        [self setText:contact.shortName];
    } else {
        [self setAvatar:contact.avatar];
    }
}

- (void)initLabelViewWithText:(NSString *)text {

    CGSize size = [text sizeWithAttributes:
                   @{NSFontAttributeName: [UIFont systemFontOfSize:textSize]}];
    size.width *= 1.2;
    size.height *= 1.2;
    UIFont * customFont = [UIFont systemFontOfSize:textSize];
    CGRect labelRect = CGRectMake((self.frame.size.width - size.width) / 2.0, (self.frame.size.height - size.height) / 2.0, size.width, size.height);
    self.textContentView = [[UILabel alloc] initWithFrame:labelRect];
    self.textContentView.clipsToBounds = YES;
    self.textContentView.backgroundColor = [UIColor clearColor];
    self.textContentView.font = customFont;
    self.textContentView.textColor = self.textColor;
    self.textContentView.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.textContentView];
}

- (void)initAvatarView {
    
    self.avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.avatarView.layer.cornerRadius = self.frame.size.height / 2.0;
    [self addSubview:self.avatarView];
}

- (void)initHighlightView {
    
    self.highlightView = [[UIView alloc] initWithFrame:self.frame];
    self.highlightView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    [self addSubview:self.highlightView];
}

- (void)setText:(NSString *)text {
    
    // must init child view at this time when parent view already have it's frame
    if (self.textContentView == nil) {
        [self initLabelViewWithText:text];
    }
    self.textContentView.hidden = NO;
    self.avatarView.hidden = YES;
    
    self.textContentView.text = text;
    self.backgroundColor = self.baseColor;
}

- (void)setAvatar:(UIImage *)avatar {
    
    // must init child view at this time when parent view already have it's frame
    if (self.avatarView == nil) {
        [self initAvatarView];
    }
    self.textContentView.hidden = YES;
    self.avatarView.hidden = NO;
    
    self.avatarView.image = avatar;
}

- (void)setHighlight:(BOOL)flag {
    
    if (self.highlightView == nil) {
        [self initHighlightView];
    }
    
    self.highlightView.hidden = !flag;
}

- (void)resetBackColor {
    self.backgroundColor = self.baseColor;
    self.textContentView.backgroundColor = [UIColor clearColor];
}

@end
