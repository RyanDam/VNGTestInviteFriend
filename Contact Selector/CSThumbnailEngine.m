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
#import "LRUCacheItem.h"

@implementation UIImageView (CSThumbnailEngine)

- (void)setThumbnailText:(NSString *)text withCompletion:(void (^)(UIImage * image))completion {
    
    LRUCache * cacher = [LRUCache getInstanceWithName:@"CSThumbnailEngineCache" hopeSize:50];
    
    [self setImage:nil];
    
    static int count = 0;
    
    [cacher objectForKey:text withCompletion:^(LRUCacheItem *item) {
        UIImage * image = (UIImage *)item.value;
        
        if (image == nil) {
            [[CSThumbnailCreater getInstance] getThumbnailImageWithText:text withSize:self.frame.size withCompletion:^(UIImage *image) {
                [cacher addObject:image forKey:text withCompletion:^(LRUCacheItem *item) {
                    // do nothing
                }];
                count ++;
                NSLog(@"Create %@ %d", text, count);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setImage:image];
                    if (completion != nil) {
                        completion(image);
                    }
                });
                
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setImage:image];
                if (completion != nil) {
                    completion(image);
                }
            });
        }
    }];
}

@end
