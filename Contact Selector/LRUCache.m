//
//  LRUCache.m
//  Contact Selector
//
//  Created by CPU11815 on 2/21/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "LRUCache.h"
#import "LRUCacheDisk.h"
#import "UIImage+Size.h"

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
        
        [LRUCacheDisk getInstanceWithName:cacheName withCompletion:^(LRUCacheDisk *diskCacher) {
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

- (void)addObject:(UIImage *)object forKey:(NSString *)key withCompletion:(LRUHandlerCompleteBlock)completion {
    
    dispatch_barrier_async(self.internalQueue, ^{
        NSUInteger size = [object getSizeInBytes];
        
        if ([self.keySet containsObject:key]) {
            UIImage * oldItem = [self.dictionary objectForKey:key];
            self.currentSize -= oldItem.getSizeInBytes;
        }
        
        while (self.currentSize + size > self.internalMaxSize) {
            [self tryMoveMostRareUsageObjectToDiskWithCompletion:^(UIImage * item) {
                // TODO handle
            }];
        }
        
        if ([self.keySet containsObject:key]) {
            [self.keySet moveObjectsAtIndexes:[NSIndexSet indexSetWithIndex:[self.keySet indexOfObject:key]] toIndex:0];
        } else {
            [self.keySet insertObject:key atIndex:0];
        }
        
        
        [self.dictionary setObject:object forKey:key];
        self.currentSize += size;
        
        if (completion != nil) {
            completion(object);
        }
    });
}

- (void)objectForKey:(NSString *)key withCompletion:(LRUHandlerCompleteBlock)completion {
    
    if (completion) {
        dispatch_async(self.internalQueue, ^{
            if ([self.keySet containsObject:key]) {
                NSUInteger index = [self.keySet indexOfObject:key];
                if (index < self.keySet.count) {
                    [self.keySet moveObjectsAtIndexes:[NSIndexSet indexSetWithIndex:[self.keySet indexOfObject:key]] toIndex:0];
                }
                UIImage * item = [self.dictionary objectForKey:key];
                
                completion(item);
            } else {
                [self tryGetObjectFromDiskWithKey:key withCompletion:^(UIImage *item) {
                    if (item != nil) {
                        // move item from disk to ram cache
                        [self.diskCacher removeObjectForKey:key withCompletion:^(UIImage *item, NSString *path, NSError *error) {
                            
                            if (error == nil && item != nil) {
                                [self addObject:item forKey:key withCompletion:^(UIImage *item) {
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
}

- (void)tryGetObjectFromDiskWithKey:(NSString *)key withCompletion:(LRUHandlerCompleteBlock)completion {
    
    if (completion) {
        NSString * mostRareKey = [self.keySet lastObject];
        if (mostRareKey != nil) {
            [self.diskCacher objectForKey:key withCompletion:^(UIImage *item, NSString *path, NSError *error) {
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
}

- (void)tryMoveMostRareUsageObjectToDiskWithCompletion:(LRUHandlerCompleteBlock)completion {
    
    NSString * mostRareKey = [self.keySet lastObject];
    if (mostRareKey != nil) {
        [self removeObjectForKey:mostRareKey withCompletion:^(UIImage *item) {
            
            if (self.diskCacher) {
                [self.diskCacher addItem:item forKey:mostRareKey withCompletion:^(UIImage *item, NSString *path, NSError *error) {
                    if (error) {
                        // TODO print error
                        NSLog(@"%@", error.localizedDescription);
                    }
                }];
            }
            // no need to check if move item to disk complete or not
            if (completion) {
                completion(item);
            }
        }];
    }
}

- (void)removeAllObjectWithCompletion:(LRUHandlerCompleteBlock)completion {
    
    [self.diskCacher removeAllObjectWithCompletion:^(UIImage *item, NSString *path, NSError *error) {
        [self.keySet removeAllObjects];
        [self.dictionary removeAllObjects];
        self.currentSize = 0;
        if (completion) {
            completion(nil);
        }
    }];
}

- (void)removeObjectForKey:(NSString *)key withCompletion:(LRUHandlerCompleteBlock)completion {
    
    if ([self.keySet containsObject:key]) {
        UIImage * item = [self.dictionary objectForKey:key];
        self.currentSize -= [item getSizeInBytes];
        [self.dictionary removeObjectForKey:key];
        if (completion) {
            completion(item);
        }
    }
}

- (void)removeMostRareUsageObjectWithCompletion:(LRUHandlerCompleteBlock)completion {
    
    NSString * mostRareKey = [self.keySet lastObject];
    if (mostRareKey != nil) {
        UIImage * item = [self.dictionary objectForKey:mostRareKey];
        self.currentSize -= [item getSizeInBytes];
        [self.dictionary removeObjectForKey:mostRareKey];
        if (completion) {
            completion(item);
        }
    }
}

@end
