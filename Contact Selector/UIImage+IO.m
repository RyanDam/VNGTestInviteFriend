//
//  UIImage+IO.m
//  Contact Selector
//
//  Created by CPU11815 on 3/3/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UIImage+IO.h"

@implementation UIImage (IO)

+ (void)readFromFilePath:(NSString *)filePath WithComplete:(void (^)(UIImage * data, NSError * error))completion {
    
    if (completion) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            if ([fileManager fileExistsAtPath:filePath]) {
                completion([[UIImage alloc] initWithContentsOfFile:filePath], nil);
            } else {
                completion(nil, [NSError errorWithDomain:@"Write Cache error" code:0 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Error when write cache for path: %@", filePath]}]);
            }
        });
    }
}

- (void)writeToFilePath:(NSString *)filePath WithComplete:(void (^)(UIImage * data, NSError * error))completion {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError * err = nil;
        
        if ([fileManager fileExistsAtPath:filePath]) {
            [fileManager removeItemAtPath:filePath error:&err];
        }
        
        if (err) {
            NSLog(@"%@", err.localizedDescription);
            if (completion) {
                completion(nil, err);
            }
        } else {
            [UIImageJPEGRepresentation(self, 0.8) writeToFile:filePath atomically:YES];
            if (completion) {
                completion(self, nil);
            }
        }
    });
}

@end
