//
//  LRUCacheDisk.m
//  Contact Selector
//
//  Created by CPU11815 on 2/21/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "LRUCacheDisk.h"
#import "LRUCacheItem.h"
#import "LRUFileUtils.h"


@interface LRUCacheDisk()

@property (nonatomic) NSMutableOrderedSet * keySet;
@property (nonatomic) NSMutableDictionary * dictionary;
@property (nonatomic) dispatch_queue_t internalQueue;

@property (nonatomic) NSUInteger internalMaxSize;
@property (nonatomic) NSUInteger currentSize;
@property (nonatomic) NSString * internalCacheName;


@end

@implementation LRUCacheDisk

+ (void)getInstanceWithName:(NSString *)cacheName hopeMaxSize:(NSUInteger)maxSize withCompletion:(void(^)(LRUCacheDisk * diskCacher))completion {
    
    static NSMutableDictionary * diskCacheDictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        diskCacheDictionary = [NSMutableDictionary dictionary];
    });
    
    if (completion == nil) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        LRUCacheDisk * cacheDisk = [diskCacheDictionary objectForKey:cacheName];
        
        if (cacheDisk == nil) {
            NSFileManager * manger = [NSFileManager defaultManager];
            
            NSString * cacheInfoFilePath = [LRUFileUtils getCacheInfoFilePathWithCacheName:cacheName];
            
            if ([manger fileExistsAtPath:cacheInfoFilePath]) {
                NSError * error;
                NSString * cacheInfoContent = [NSString stringWithContentsOfFile:cacheInfoFilePath encoding:NSUTF8StringEncoding error:&error];
                
                if (error) {
                    // TODO handle error
                } else if (cacheInfoContent == nil || cacheInfoContent.length == 0) {
                    LRUCacheDisk * cacheDisk = [[LRUCacheDisk alloc] initCacheDiskName:cacheName withMaxSize:maxSize];
                    [diskCacheDictionary setObject:cacheDisk forKey:cacheName];
                    completion(cacheDisk);
                } else {
                    LRUCacheDisk * cacheDisk = [[LRUCacheDisk alloc] initCacheDiskName:cacheName fromStringInfo:cacheInfoContent];
                    [diskCacheDictionary setObject:cacheDisk forKey:cacheName];
                    completion(cacheDisk);
                }
            } else {
                LRUCacheDisk * cacheDisk = [[LRUCacheDisk alloc] initCacheDiskName:cacheName withMaxSize:maxSize];
                [diskCacheDictionary setObject:cacheDisk forKey:cacheName];
                completion(cacheDisk);
            }
        } else {
            completion(cacheDisk);
        }
    });
}

- (instancetype)initCacheDiskName:(NSString *)cacheName fromStringInfo:(NSString *)cacheInfoContent {
    
    self = [super init];
    if (self) {
        NSArray * contents = [cacheInfoContent componentsSeparatedByString:@"\n"];
        NSString * info = contents[0];
        NSArray * infos = [info componentsSeparatedByString:@","];
        
        NSUInteger totalSize = [infos[1] integerValue];
        NSUInteger maxSize = [infos[2] integerValue];
        NSArray * itemStrings = [contents subarrayWithRange:NSMakeRange(1, contents.count - 1)];
        
        NSMutableOrderedSet * keySet = [NSMutableOrderedSet orderedSet];
        NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
        
        for (NSString * itemString in itemStrings) {
            if (itemString == nil || itemString.length == 0) {
                continue;
            }
            NSArray * infos = [itemString componentsSeparatedByString:@","];
            NSString * key = infos[0];
            NSNumber * size = [NSNumber numberWithUnsignedInteger:[infos[1] integerValue]];
            [keySet insertObject:key atIndex:0];
            [dictionary setObject:size forKey:key];
        }
        
        self.internalMaxSize = maxSize;
        self.internalCacheName = cacheName;
        self.keySet = keySet;
        self.dictionary = dictionary;
        self.currentSize = totalSize;
        
        NSString * queueName = [NSString stringWithFormat:@"queueDisk#%@", cacheName];
        self.internalQueue = dispatch_queue_create(queueName.UTF8String, DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (instancetype)initCacheDiskName:(NSString *)cacheName withMaxSize:(NSUInteger)maxSize {
    
    self = [super init];
    if (self) {
        self.internalMaxSize = maxSize;
        self.internalCacheName = cacheName;
        self.keySet = [NSMutableOrderedSet orderedSet];
        self.dictionary = [NSMutableDictionary dictionary];
        self.currentSize = 0;
        
        NSString * queueName = [NSString stringWithFormat:@"queueDisk#%@", cacheName];
        self.internalQueue = dispatch_queue_create(queueName.UTF8String, DISPATCH_QUEUE_CONCURRENT);
        
        [self writeCurrentCacheDiskState];
    }
    return self;
}

- (NSUInteger)maxSize {
    
    return self.internalMaxSize;
}

- (NSString *)cacheName {
    
    return self.internalCacheName;
}

- (void)addItem:(LRUCacheItem *)item forKey:(NSString *)key withCompletion:(ReadWriteCacheItemCompletion)completion {

    dispatch_barrier_async(self.internalQueue, ^{
       
        while (self.currentSize + item.size > self.maxSize) {
            [self removeRareUsageData];
        }
        
        NSError * error;
        
        NSString * dataPath = [LRUFileUtils getFilePathForKey:key withCacheName:self.cacheName];
        
        if ([self.keySet containsObject:key]) {
            [self.keySet moveObjectsAtIndexes:[NSIndexSet indexSetWithIndex:[self.keySet indexOfObject:key]] toIndex:0];
            
            NSNumber * size = [self.dictionary objectForKey:key];
            [self.dictionary removeObjectForKey:key];
            self.currentSize -= size.unsignedIntegerValue;
        } else {
            [self.keySet insertObject:key atIndex:0];
        }
        
        NSFileManager * manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:dataPath]) {
            [manager removeItemAtPath:dataPath error:&error];
            if (error) {
                if (completion) {
                    completion(nil, nil, error);
                }
                return;
            }
        }
        
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        [item writeToFilePath:dataPath withCompletion:^(LRUCacheItem * data) {
            if (data != nil) {
                self.currentSize += data.size;
                [self.dictionary setObject:[NSNumber numberWithUnsignedInteger:data.size] forKey:key];
                if (completion) {
                    completion(data, dataPath, nil);
                }
            } else {
                if (completion) {
                    completion(nil, nil, [self getErrorWithMessage:@"Can't write LRUCacheItem"]);
                }
            }
            dispatch_group_leave(group);
        }];
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        
        [self writeCurrentCacheDiskState];
    });
}

- (void)objectForKey:(NSString *)key withCompletion:(ReadWriteCacheItemCompletion)completion {
    
    if (completion == nil) {
        return;
    }
    
    dispatch_async(self.internalQueue, ^{
        NSString * dataPath = [LRUFileUtils getFilePathForKey:key withCacheName:self.cacheName];
        
        if ([self.keySet containsObject:key]) {
            [self.keySet moveObjectsAtIndexes:[NSIndexSet indexSetWithIndex:[self.keySet indexOfObject:key]] toIndex:0];
            NSNumber * size = [self.dictionary objectForKey:key];
            [self.dictionary removeObjectForKey:key];
            self.currentSize -= size.unsignedIntegerValue;
            
            [LRUCacheItem readFromFilePath:dataPath size:size.unsignedIntegerValue withCompletion:^(LRUCacheItem * data) {
                if (data != nil) {
                    self.currentSize += data.size;
                    [self.dictionary setObject:[NSNumber numberWithUnsignedInteger:data.size] forKey:key];
                    completion(data, dataPath, nil);
                } else {
                    completion(nil, nil, [self getErrorWithMessage:@"Can't read LRUCacheItem"]);
                }
            }];
        } else {
            completion(nil, nil, [self getErrorWithMessage:@"LRUCacheItem not exist"]);
        }
        
        [self writeCurrentCacheDiskState];
    });
}

- (void)removeObjectForKey:(NSString *)key withCompletion:(ReadWriteCacheItemCompletion)completion {
    
    dispatch_barrier_async(self.internalQueue, ^{
        NSError * error;
        
        NSString * dataPath = [LRUFileUtils getFilePathForKey:key withCacheName:self.cacheName];
        
        if ([self.keySet containsObject:key]) {
            
            [self.keySet removeObject:key];
            NSNumber * size = [self.dictionary objectForKey:key];
            self.currentSize -= size.unsignedIntegerValue;
            [self.dictionary removeObjectForKey:key];
            
            NSFileManager * manager = [NSFileManager defaultManager];
            if ([manager fileExistsAtPath:dataPath]) {
                [manager removeItemAtPath:dataPath error:&error];
                if (error) {
                    completion(nil, nil, error);
                    return;
                }
            }
            if (completion) {
                completion(nil, dataPath, nil);
            }
        } else {
            // do nothing
            if (completion) {
                completion(nil, dataPath, nil);
            }
        }
        
        [self writeCurrentCacheDiskState];
    });
}

- (void)removeAllObjectWithCompletion:(ReadWriteCacheItemCompletion)completion {
    
    if (completion == nil) {
        return;
    }
    
    dispatch_barrier_async(self.internalQueue, ^{
        dispatch_group_t group = dispatch_group_create();
        
        for (NSString * key in self.keySet) {
            dispatch_group_enter(group);
            [self removeObjectForKey:key withCompletion:^(LRUCacheItem *item, NSString *path, NSError *error) {
                dispatch_group_leave(group);
            }];
            dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        }
        
        [self.keySet removeAllObjects];
        [self.dictionary removeAllObjects];
        self.currentSize = 0;
        
        completion(nil, nil, nil);
        
        [self writeCurrentCacheDiskState];
    });
    
}

- (void)removeRareUsageData {
    
    NSString * key = [self.keySet lastObject];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [self removeObjectForKey:key withCompletion:^(LRUCacheItem *item, NSString *path, NSError *error) {
        dispatch_group_leave(group);
    }];
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

- (NSError *)getErrorWithMessage:(NSString *)message {
    
    return [NSError errorWithDomain:@"writeCache" code:1 userInfo:@{NSLocalizedDescriptionKey:message}];
}

- (void)writeCurrentCacheDiskState {
    
    dispatch_barrier_async(self.internalQueue, ^{
        NSFileManager * manager = [NSFileManager defaultManager];
        NSString * cacheFile = [LRUFileUtils getCacheInfoFilePathWithCacheName:self.cacheName];
        
        NSString * info = [NSString stringWithFormat:@"%lu,%lu,%lu\n", (unsigned long)self.keySet.count, (unsigned long)self.currentSize, (unsigned long)self.maxSize];
        
        for (NSString * key in self.keySet) {
            NSNumber * size = [self.dictionary objectForKey:key];
            info = [NSString stringWithFormat:@"%@%@,%ld\n", info, key, size.unsignedIntegerValue];
        }
        
        if ([manager fileExistsAtPath:cacheFile]) {
            // WARNING ERROR
            [manager removeItemAtPath:cacheFile error:nil];
        }
        
        [info writeToFile:cacheFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    });
}

#pragma mark - Testing

- (NSString *)printAll {
    
    dispatch_group_t group = dispatch_group_create();
    
    [self printSelf];
    
    __block NSString * ret = @"";
    for (NSString * key in self.keySet) {
        dispatch_group_enter(group);
        [self objectForKey:key withCompletion:^(LRUCacheItem *item, NSString *path, NSError *error) {
            if (error) {
                // not yet done writing object for reading
                return;
            }
            ret = [NSString stringWithFormat:@"%@:%@", ret, item.value];
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    return ret == nil ? @"": ret;
}

- (void)printSelf {
    NSLog(@"%ld, %ld, %@", self.currentSize, self.maxSize, self.cacheName);
    for (NSString * key in self.keySet) {
        NSNumber * size = [self.dictionary objectForKey:key];
        NSLog(@"%@, %ld", key, size.unsignedIntegerValue);
    }
}

@end

