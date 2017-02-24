//
//  CSThumbnailCreater.h
//  Contact Selector
//
//  Created by Dam Vu Duy on 2/23/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSThumbnailCreater : NSObject

+ (instancetype)getInstance;

- (UIImage *)getThumbnailImageWithText:(NSString *)text withSize:(CGSize)size;

@end
