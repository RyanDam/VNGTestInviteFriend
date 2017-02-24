//
//  LRUCache.m
//  Contact Selector
//
//  Created by CPU11815 on 2/21/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "LRUCache.h"
#import "LRUCacheItem.h"
#import "LRUCacheDisk.h"

@interface LRUCache()

@property (nonatomic) NSMutableDictionary * dictionary;
@property (nonatomic) NSMutableOrderedSet * keySet;
@property (nonatomic) NSUInteger internalMaxSize;
@property (nonatomic) NSUInteger currentSize;
@property (nonatomic) dispatch_queue_t internalQueue;
@property (nonatomic) NSString * internalCacheName;
@property (nonatomic) LRUCacheDisk * diskCacher;

@end

@implementation LRUCache

+ (instancetype)getInstanceWithName:(NSString *)cacheName hopeSize:(NSUInteger)maxSize {
    
    static NSMutableDictionary * diskCacheDictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        diskCacheDictionary = [NSMutableDictionary dictionary];
    });
    
    LRUCache * cacher = [diskCacheDictionary objectForKey:cacheName];
    
    if (cacher == nil) {
        cacher = [[LRUCache alloc] initWithName:cacheName maxSize:maxSize];
        [diskCacheDictionary setObject:cacher forKey:cacheName];
    }
    
    return cacher;
}

- (instancetype)initWithName:(NSString *)cacheName maxSize:(NSUInteger)maxSize {
    
    self = [super init];
    
    if (self) {
        self.internalCacheName = cacheName;
        self.internalMaxSize = maxSize;
        self.currentSize = 0;
        self.dictionary = [NSMutableDictionary dictionary];
        self.keySet = [NSMutableOrderedSet orderedSet];
        
        NSString * queueName = [NSString stringWithFormat:@"queue#%@", cacheName];
        self.internalQueue = dispatch_queue_create(queueName.UTF8String, DISPATCH_QUEUE_CONCURRENT);
        
        [LRUCacheDisk getInstanceWithName:cacheName hopeMaxSize:maxSize withCompletion:^(LRUCacheDisk *diskCacher) {
            self.diskCacher = diskCacher;
        }];
    }
    
    return self;
}

- (NSString *)cacheName {
    
    return self.internalCacheName;
}

- (NSUInteger)maxSize {
    
    return self.internalMaxSize;
}

- (void)addObject:(NSObject *)object forKey:(NSString *)key withCompletion:(LRUHandlerCompleteBlock)completion {
    
    [self addObject:object forKey:key withSize:1 withCompletion:completion];
}

- (void)addObject:(NSObject *)object forKey:(NSString *)key withSize:(NSUInteger)size withCompletion:(LRUHandlerCompleteBlock)completion {
    
    dispatch_barrier_async(self.internalQueue, ^{
        LRUCacheItem * item = [[LRUCacheItem alloc] initWithObject:object andSize:size];
        
        if ([self.keySet containsObject:key]) {
            LRUCacheItem * oldItem = [self.dictionary objectForKey:key];
            self.currentSize -= oldItem.size;
        }
        
        while (self.currentSize + item.size > self.internalMaxSize) {
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_enter(group);
            [self tryMoveMostRareUsageObjectToDiskWithCompletion:^(LRUCacheItem *item) {
                // TODO handle
                dispatch_group_leave(group);
            }];
            dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        }
        
        if ([self.keySet containsObject:key]) {
            [self.keySet moveObjectsAtIndexes:[NSIndexSet indexSetWithIndex:[self.keySet indexOfObject:key]] toIndex:0];
        } else {
            [self.keySet insertObject:key atIndex:0];
        }
        
        [self.dictionary setObject:item forKey:key];
        self.currentSize += item.size;
        
        if (completion != nil) {
            completion(item);
        }
    });
}

- (void)objectForKey:(NSString *)key withCompletion:(LRUHandlerCompleteBlock)completion {
    
    dispatch_sync(self.internalQueue, ^{
        
        if ([self.keySet containsObject:key]) {
            [self.keySet moveObjectsAtIndexes:[NSIndexSet indexSetWithIndex:[self.keySet indexOfObject:key]] toIndex:0];
            LRUCacheItem * item = [self.dictionary objectForKey:key];
            
            if (completion != nil) {
                completion(item);
            }
        } else {
            [self tryGetObjectFromDiskWithKey:key withCompletion:^(LRUCacheItem *item) {
                
                if (item != nil) {
                    // move item from disk to ram cache
                    [self.diskCacher removeObjectForKey:key withCompletion:^(LRUCacheItem *item, NSString *path, NSError *error) {
                        
                        if (error == nil && item != nil) {
                            [self addObject:item forKey:key withCompletion:^(LRUCacheItem *item) {
                                completion(item);
                            }];
                        } else {
                            completion(nil);
                        }
                    }];
                } else {
                    completion(nil);
                }
            }];
        }
    });
}

- (void)tryGetObjectFromDiskWithKey:(NSString *)key withCompletion:(LRUHandlerCompleteBlock)completion {
    
    NSString * mostRareKey = [self.keySet lastObject];
    if (mostRareKey != nil) {
        [self.diskCacher objectForKey:key withCompletion:^(LRUCacheItem *item, NSString *path, NSError *error) {
            if (error) {
                // TODO print error
                NSLog(@"ERRRROR: %@", [error localizedDescription]);
                completion(nil);
            } else {
                completion(item);
            }
        }];
    } else {
        completion(nil);
    }
}

- (void)tryMoveMostRareUsageObjectToDiskWithCompletion:(LRUHandlerCompleteBlock)completion {
    
    if (self.diskCacher == nil) {
        completion(nil);
        return;
    }
    
    NSString * mostRareKey = [self.keySet lastObject];
    if (mostRareKey != nil) {
        LRUCacheItem * item = [self.dictionary objectForKey:mostRareKey];
        
        [self.diskCacher addItem:item forKey:mostRareKey withCompletion:^(LRUCacheItem *item, NSString *path, NSError *error) {
            if (error) {
                // TODO print error
            } else {
                completion(item);
            }
        }];
    }
}

- (void)removeAllObjectWithCompletion:(LRUHandlerCompleteBlock)completion {
    [self.diskCacher removeAllObjectWithCompletion:^(LRUCacheItem *item, NSString *path, NSError *error) {
        [self.keySet removeAllObjects];
        [self.dictionary removeAllObjects];
        self.currentSize = 0;
        completion(nil);
    }];
}

- (void)removeObjectForKey:(NSString *)key withCompletion:(LRUHandlerCompleteBlock)completion {
    
    dispatch_barrier_async(self.internalQueue, ^{
        if ([self.keySet containsObject:key]) {
            LRUCacheItem * item = [self.dictionary objectForKey:key];
            self.currentSize -= item.size;
            [self.dictionary removeObjectForKey:key];
            if (completion != nil) {
                completion(item);
            }
        }
    });
}

- (void)removeMostRareUsageObjectWithCompletion:(LRUHandlerCompleteBlock)completion {
    
    NSString * mostRareKey = [self.keySet lastObject];
    if (mostRareKey != nil) {
        LRUCacheItem * item = [self.dictionary objectForKey:mostRareKey];
        self.currentSize -= item.size;
        [self.dictionary removeObjectForKey:mostRareKey];
        if (completion != nil) {
            completion(item);
        }
    }
}

#pragma mark - Testing

- (NSString *)printAll {
    
    NSString * ret = @"";
    for (NSString * key in self.keySet) {
        LRUCacheItem * item = [self.dictionary objectForKey:key];
        ret = [NSString stringWithFormat:@"%@,%@", ret, item.value];
    }
    
    if (self.diskCacher) {
        NSString * disk = [self.diskCacher printAll];
        
        ret = [NSString stringWithFormat:@"%@,%@", ret, disk];
    }
    
    return ret;
}

@end
