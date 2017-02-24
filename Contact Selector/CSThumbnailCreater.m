//
//  CSThumbnailCreater.m
//  Contact Selector
//
//  Created by Dam Vu Duy on 2/23/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CSThumbnailCreater.h"

static NSDictionary * colorDictionary;

@implementation CSThumbnailCreater

+ (instancetype)getInstance {
    static CSThumbnailCreater * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CSThumbnailCreater alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initColor];
    }
    return self;
}

- (void)initColor {
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
        [colorDic setObject:[UIColor colorWithRed:231.0/255.0 green:189.0/255.0 blue:151.0/255.0 alpha:1.0] forKey:@"default"];
        colorDictionary = colorDic;
    });
}

- (UIImage *)getThumbnailImageWithText:(NSString *)text withSize:(CGSize)size {
    UIColor * color = nil;
    
    CGPoint midPoint = CGPointMake(size.width / 2, size.height / 2);
    
    if (text == nil || text.length == 0) {
        color = [colorDictionary objectForKey:@"default"];
    } else if (text.length == 1) {
        color = [colorDictionary objectForKey:[text substringWithRange:NSMakeRange(0, 1)]];
    } else {
        color = [colorDictionary objectForKey:[text substringWithRange:NSMakeRange(1, 1)]];
    }
    if (color == nil) {
        color = [colorDictionary objectForKey:@"default"];
    }
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    // Font attributes
    int fontSize = size.height / 1.8;
    CGSize textSizeRect = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:fontSize]}];
    CGRect textRect = CGRectMake(midPoint.x - textSizeRect.width/2.1, midPoint.y - textSizeRect.height/2, textSizeRect.width, textSizeRect.height);
    UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
    NSDictionary *att = @{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    //// Create image
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // set color for circle
    [color set];
    // draw circle
    CGContextFillEllipseInRect(context, rect);
    // draw text
    [text drawInRect:CGRectIntegral(textRect) withAttributes:att];
    // get image
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
