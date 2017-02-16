//
//  CSThumbnailView.m
//  Contact Selector
//
//  Created by CPU11815 on 2/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CSThumbnailView.h"
#import "CSContact.h"

static NSDictionary * colorDictionary;

@interface CSThumbnailView() {
    NSUInteger textSize;
}

@property (nonatomic) UIColor * baseColor;
@property (nonatomic) UIColor * textColor;
@property (nonatomic) UILabel * textContentView;
@property (nonatomic) UIImageView * avatarView;
@property (nonatomic) UIView * highlightView;

@property (nonatomic) NSString * currentText;

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
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableDictionary * colorDic = [NSMutableDictionary dictionary];
        [colorDic setObject:[UIColor colorWithRed:213.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1.0] forKey:@"Q"];
        [colorDic setObject:[UIColor colorWithRed:248.0/255.0 green:201.0/255.0 blue:133.0/255.0 alpha:1.0] forKey:@"W"];
        [colorDic setObject:[UIColor colorWithRed:131.0/255.0 green:179.0/255.0 blue:233.0/255.0 alpha:1.0] forKey:@"E"];
        [colorDic setObject:[UIColor colorWithRed:239.0/255.0 green:144.0/255.0 blue:183.0/255.0 alpha:1.0] forKey:@"R"];
        [colorDic setObject:[UIColor colorWithRed:159.0/255.0 green:200.0/255.0 blue:188.0/255.0 alpha:1.0] forKey:@"T"];
        [colorDic setObject:[UIColor colorWithRed:105.0/255.0 green:213.0/255.0 blue:178.0/255.0 alpha:1.0] forKey:@"Y"];
        [colorDic setObject:[UIColor colorWithRed:131.0/255.0 green:125.0/255.0 blue:198.0/255.0 alpha:1.0] forKey:@"U"];
        [colorDic setObject:[UIColor colorWithRed:180.0/255.0 green:167.0/255.0 blue:134.0/255.0 alpha:1.0] forKey:@"I"];
        [colorDic setObject:[UIColor colorWithRed:96.0/255.0 green:111.0/255.0 blue:150.0/255.0 alpha:1.0] forKey:@"O"];
        [colorDic setObject:[UIColor colorWithRed:122.0/255.0 green:116.0/255.0 blue:116.0/255.0 alpha:1.0] forKey:@"P"];
        [colorDic setObject:[UIColor colorWithRed:140.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1.0] forKey:@"A"];
        [colorDic setObject:[UIColor colorWithRed:139.0/255.0 green:178.0/255.0 blue:128.0/255.0 alpha:1.0] forKey:@"S"];
        [colorDic setObject:[UIColor colorWithRed:223.0/255.0 green:150.0/255.0 blue:224.0/255.0 alpha:1.0] forKey:@"D"];
        [colorDic setObject:[UIColor colorWithRed:0.875 green:0.588 blue:0.878 alpha:1.00] forKey:@"F"];
        [colorDic setObject:[UIColor colorWithRed:0.847 green:0.392 blue:0.486 alpha:1.00] forKey:@"G"];
        [colorDic setObject:[UIColor colorWithRed:0.780 green:0.804 blue:0.549 alpha:1.00] forKey:@"H"];
        [colorDic setObject:[UIColor colorWithRed:0.651 green:0.620 blue:0.816 alpha:1.00] forKey:@"J"];
        [colorDic setObject:[UIColor colorWithRed:0.839 green:0.643 blue:0.349 alpha:1.00] forKey:@"K"];
        [colorDic setObject:[UIColor colorWithRed:0.384 green:0.651 blue:0.459 alpha:1.00] forKey:@"L"];
        [colorDic setObject:[UIColor colorWithRed:0.682 green:0.776 blue:0.925 alpha:1.00] forKey:@"Z"];
        [colorDic setObject:[UIColor colorWithRed:0.635 green:0.514 blue:0.616 alpha:1.00] forKey:@"X"];
        [colorDic setObject:[UIColor colorWithRed:0.624 green:0.667 blue:0.608 alpha:1.00] forKey:@"C"];
        [colorDic setObject:[UIColor colorWithRed:0.847 green:0.847 blue:0.847 alpha:1.00] forKey:@"V"];
        [colorDic setObject:[UIColor colorWithRed:0.922 green:0.890 blue:0.796 alpha:1.00] forKey:@"B"];
        [colorDic setObject:[UIColor colorWithRed:0.514 green:0.694 blue:0.643 alpha:1.00] forKey:@"N"];
        [colorDic setObject:[UIColor colorWithRed:0.863 green:0.635 blue:0.518 alpha:1.00] forKey:@"M"];
        [colorDic setObject:[UIColor colorWithRed:0.722 green:0.431 blue:0.686 alpha:1.00] forKey:@"#"];
        colorDictionary = colorDic;
    });
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
    size.width *= 1.5;
    size.height *= 1.5;
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
    self.avatarView.contentMode = UIViewContentModeScaleAspectFill;
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
    UIColor * color = [colorDictionary objectForKey:[text substringWithRange:NSMakeRange(1, 1)]];
    if (color) {
        self.backgroundColor = color;
    } else {
        self.backgroundColor = self.baseColor;
    }
    
    self.currentText = text;
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
    UIColor * color = [colorDictionary objectForKey:[self.currentText substringWithRange:NSMakeRange(1, 1)]];
    if (color) {
        self.backgroundColor = color;
    } else {
        self.backgroundColor = self.baseColor;
    }
    self.textContentView.backgroundColor = [UIColor clearColor];
}

@end
