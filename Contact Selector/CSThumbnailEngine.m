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
    
    LRUCache * cacher = [LRUCache getInstanceWithName:@"CSThumbnailEngineCache" hopeSize:400];
    
    [self setImage:nil];
    
    [cacher objectForKey:text withCompletion:^(LRUCacheItem *item) {
        UIImage * image = (UIImage *)item.value;
        
        if (image == nil) {
            image = [[CSThumbnailCreater getInstance] getThumbnailImageWithText:text withSize:self.frame.size];
            [cacher addObject:image forKey:text withCompletion:^(LRUCacheItem *item) {
               // do nothing
            }];
            NSLog(@"Create %@", text);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setImage:image];
            if (completion != nil) {
                completion(image);
            }
        });
    }];
}

@end
