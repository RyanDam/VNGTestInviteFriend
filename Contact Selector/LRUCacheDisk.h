//
//  LRUCacheDisk.h
//  Contact Selector
//
//  Created by CPU11815 on 2/21/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LRUCacheItem;

typedef void (^ReadWriteCacheItemCompletion)(LRUCacheItem * item, NSString * path, NSError * error);

@interface LRUCacheDisk : NSObject

@property (nonatomic, readonly) NSUInteger maxSize;
@property (nonatomic, readonly) NSString * cacheName;

+ (void)getInstanceWithName:(NSString *)cacheName hopeMaxSize:(NSUInteger)maxSize withCompletion:(void(^)(LRUCacheDisk * diskCacher))completion;

- (instancetype)initCacheDiskName:(NSString *)cacheName withMaxSize:(NSUInteger)maxSize;

- (void)addItem:(LRUCacheItem *)item forKey:(NSString *)key withCompletion:(ReadWriteCacheItemCompletion)completion;

- (void)objectForKey:(NSString *)key withCompletion:(ReadWriteCacheItemCompletion)completion;

- (void)removeObjectForKey:(NSString *)key withCompletion:(ReadWriteCacheItemCompletion)completion;

- (void)removeAllObjectWithCompletion:(ReadWriteCacheItemCompletion)completion;

- (NSString *)printAll;

@end
