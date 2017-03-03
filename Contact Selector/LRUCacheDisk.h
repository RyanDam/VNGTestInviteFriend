//
//  LRUCacheDisk.h
//  Contact Selector
//
//  Created by CPU11815 on 2/21/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UIKit/UIKit.h"

@class LRUCacheItem;

typedef void (^ReadWriteCacheItemCompletion)(UIImage * item, NSString * path, NSError * error);

@interface LRUCacheDisk : NSObject

@property (nonatomic, readonly) NSUInteger maxSize;
@property (nonatomic, readonly) NSString * cacheName;

+ (void)getInstanceWithName:(NSString *)cacheName withCompletion:(void(^)(LRUCacheDisk * diskCacher))completion;

/**
 Add image to cachedisk

 @param item image to cache
 @param key key for retrive
 @param completion completion
 */
- (void)addItem:(UIImage *)item forKey:(NSString *)key withCompletion:(ReadWriteCacheItemCompletion)completion;

/**
 Read image from cache disk

 @param key key to retrive
 @param completion completion
 */
- (void)objectForKey:(NSString *)key withCompletion:(ReadWriteCacheItemCompletion)completion;

/**
 Remove cache image with key

 @param key key to remove
 @param completion completion
 */
- (void)removeObjectForKey:(NSString *)key withCompletion:(ReadWriteCacheItemCompletion)completion;

/**
 Remove all cachedisk

 @param completion completion
 */
- (void)removeAllObjectWithCompletion:(ReadWriteCacheItemCompletion)completion;

@end
