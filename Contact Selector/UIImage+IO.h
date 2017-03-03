//
//  UIImage+IO.h
//  Contact Selector
//
//  Created by CPU11815 on 3/3/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (IO)

+ (void)readFromFilePath:(NSString *)filePath WithComplete:(void (^)(UIImage * data, NSError * error))completion;

- (void)writeToFilePath:(NSString *)filePath WithComplete:(void (^)(UIImage * data, NSError * error))completion;

@end
