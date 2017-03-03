//
//  UIImage+Size.m
//  Contact Selector
//
//  Created by CPU11815 on 3/3/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UIImage+Size.h"

@implementation UIImage(Size)

- (NSUInteger)getSizeInBytes {
    return CGImageGetHeight(self.CGImage) * CGImageGetBytesPerRow(self.CGImage);
}

- (NSUInteger)getJpegSizeInBytes {
    NSData *imgData = UIImageJPEGRepresentation(self, 1.0);
    return imgData.length;
}

@end
