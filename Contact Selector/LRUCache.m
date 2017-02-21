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

@property (nonatomic) LRUCacheDisk * diskCacher;

@end

@implementation LRUCache

+ (instancetype)getInstanceWithName:(NSString *)cacheName hopeSize:(NSUInteger)maxSize {
    
    static NSMutableDictionary * diskCacheDictionary = nil;
    if (diskCacheDictionary == nil) {
        diskCacheDictionary = [NSMutableDictionary dictionary];
    }
    
    LRUCache * cacher = [diskCacheDictionary objectForKey:cacheName];
    
    if (cacher == nil) {
        cacher = [[LRUCache alloc] initWithName:cacheName maxSize:maxSize];
        [diskCacheDictionary setObject:cacher forKey:cacheName];
    }
    
    return cacher;
}

- (instancetype)initWithName:(NSString *)cacheName maxSize:(NSUInteger)maxSize {
    
    static NSUInteger queueCouter = 0;
    
    self = [super init];
    
    if (self) {
        self.internalMaxSize = maxSize;
        self.currentSize = 0;
        self.dictionary = [NSMutableDictionary dictionary];
        self.keySet = [NSMutableOrderedSet orderedSet];
        
        NSString * queueName = [NSString stringWithFormat:@"queue#%lu", (unsigned long)queueCouter++];
        self.internalQueue = dispatch_queue_create(queueName.UTF8String, DISPATCH_QUEUE_CONCURRENT);
        
        [LRUCacheDisk getInstanceWithName:cacheName hopeMaxSize:maxSize withCompletion:^(LRUCacheDisk *diskCacher) {
            self.diskCacher = diskCacher;
        }];
    }
    
    return self;
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
        
        while (self.currentSize + item.size > self.internalMaxSize) {
            [self tryMoveMostRareUsageObjectToDiskWithCompletion:^(LRUCacheItem *item) {
                // TODO handle
            }];
        }
        
        if ([self.keySet containsObject:key]) {
            [self.keySet moveObjectsAtIndexes:[NSIndexSet indexSetWithIndex:[self.keySet indexOfObject:key]] toIndex:0];
            LRUCacheItem * oldItem = [self.dictionary objectForKey:key];
            self.currentSize -= oldItem.size;
            [self.dictionary setObject:item forKey:key];
            self.currentSize += item.size;
        } else {
            [self.keySet insertObject:key atIndex:0];
            [self.dictionary setObject:item forKey:key];
            self.currentSize += item.size;
        }
        
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
            [self tryGetObjectFromDiskWithKey:key withCompletion:completion];
        }
    });
}

- (void)tryGetObjectFromDiskWithKey:(NSString *)key withCompletion:(LRUHandlerCompleteBlock)completion {
    NSString * mostRareKey = [self.keySet lastObject];
    if (mostRareKey != nil) {
        [self.diskCacher objectForKey:key withCompletion:^(LRUCacheItem *item, NSString *path, NSError *error) {
            if (error) {
                // TODO print error
            } else {
                completion(item);
            }
        }];
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

@end
