//
//  CSThumbnailEngine.m
//  Contact Selector
//
//  Created by CPU11815 on 2/24/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CSThumbnailEngine.h"
#import "LRUCache.h"
#import "CSThumbnailCreater.h"

@implementation UIImageView (CSThumbnailEngine)

- (void)setThumbnailText:(NSString *)text withCompletion:(void (^)(UIImage * image))completion {
    
    LRUCache * cacher = [LRUCache getInstanceWithName:@"CSThumbnailEngineCache" hopeSize:1024*1024]; // 10MB;
    
    [self setImage:nil];
    if (text) {
        [cacher objectForKey:text withCompletion:^(UIImage *item) {
            
            if (item == nil) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    UIImage * image = [[CSThumbnailCreater getInstance] getThumbnailImageWithText:text withSize:self.frame.size];
                    [cacher addObject:image forKey:text withCompletion:^(UIImage *item) {
                        // do nothing
                    }];
                    NSLog(@"Create %@", text);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self setImage:image];
                        if (completion != nil) {
                            completion(image);
                        }
                    });
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setImage:item];
                    if (completion != nil) {
                        completion(item);
                    }
                });
            }
        }];
    } else {
        if (completion) {
            completion(nil);
        }
    }
}

@end
