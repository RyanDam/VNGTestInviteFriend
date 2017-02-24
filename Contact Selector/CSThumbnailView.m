//
//  CSThumbnailView.m
//  Contact Selector
//
//  Created by CPU11815 on 2/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CSThumbnailView.h"
#import "CSModel.h"
#import "CSThumbnailEngine.h"

@interface CSThumbnailView()

@property (nonatomic) UIImageView * avatarView;
@property (nonatomic) UIView * highlightView;

@property (nonatomic) NSString * currentText;

@end

@implementation CSThumbnailView

- (void)initAvatarView {
    
    self.avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.avatarView.layer.cornerRadius = self.frame.size.height / 2.0;
    self.avatarView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarView.clipsToBounds = YES;
    [self addSubview:self.avatarView];
}

- (void)initHighlightView {
    
    self.highlightView = [[UIView alloc] initWithFrame:self.frame];
    self.highlightView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    [self addSubview:self.highlightView];
    self.highlightView.hidden = YES;
}

- (void)setData:(CSModel *)data; {
    if (self.avatarView == nil) {
        [self initAvatarView];
    }
    
    if (data.avatar == nil) {
        [self.avatarView setThumbnailText:[data shortName] withCompletion:nil];
    } else {
        [self.avatarView setImage:data.avatar];
    }
}

- (void)setHighlight:(BOOL)flag {
    
    if (self.highlightView == nil) {
        [self initHighlightView];
    }
    
    self.highlightView.hidden = !flag;
}

@end
