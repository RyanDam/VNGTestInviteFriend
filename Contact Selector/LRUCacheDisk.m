//
//  LRUCacheDisk.m
//  Contact Selector
//
//  Created by CPU11815 on 2/21/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "LRUCacheDisk.h"
#import "LRUFileUtils.h"
#import "UIImage+Size.h"
#import "UIImage+IO.h"

NSTimeInterval const kTimeToRefresh = 7*24*60*60*1000;
NSTimeInterval const kTimeToRemove = 7*24*60*60*1000;

@interface LRUCacheDisk()

@property (nonatomic) dispatch_queue_t internalQueue;
@property (nonatomic) NSString * internalCacheName;
@property (nonatomic) NSTimeInterval lastCheckedTime;

@end

@implementation LRUCacheDisk

+ (void)getInstanceWithName:(NSString *)cacheName withCompletion:(void(^)(LRUCacheDisk * diskCacher))completion {
    
    static NSMutableDictionary * diskCacheDictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        diskCacheDictionary = [NSMutableDictionary dictionary];
    });
    
    if (completion) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            LRUCacheDisk * cacheDisk = [diskCacheDictionary objectForKey:cacheName];
            
            if (cacheDisk == nil) {
                cacheDisk = [[LRUCacheDisk alloc] initFreshCacheDiskWithName:cacheName];
                
                NSFileManager * manager = [NSFileManager defaultManager];
                NSString * cacheInfoFilePath = [LRUFileUtils getCacheInfoFilePathWithCacheName:cacheName];
                
                if ([manager fileExistsAtPath:cacheInfoFilePath]) {
                    
                    // last cache disk exist in disk
                    
                    NSError * error;
                    NSString * info = [NSString stringWithContentsOfFile:cacheInfoFilePath encoding:NSUTF8StringEncoding error:&error];
                    
                    if (error) {
                        // TODO print error
                        NSLog(@"%@", error.localizedDescription);
                        completion(cacheDisk);
                    } else {
                        NSTimeInterval time = info.doubleValue;
                        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
                        
                        if (currentTime - time > kTimeToRefresh) {
                            // let check outdate file
                            cacheDisk.lastCheckedTime = currentTime;
                            [cacheDisk startDeleteOutDateFileWithCompareTime:currentTime];
                        } else {
                            cacheDisk.lastCheckedTime = time;
                        }
                        
                        completion(cacheDisk);
                    }
                } else {
                    // fresh cache disk
                    completion(cacheDisk);
                }
            } else {
                completion(cacheDisk);
            }
        });
    }
}

- (instancetype)initFreshCacheDiskWithName:(NSString *)name {
    
    self = [super init];
    if (self) {
        self.internalCacheName = name;
        NSString * cacheDiskQueue = [NSString stringWithFormat:@"cacheDiskQueue#%@", name];
        self.internalQueue = dispatch_queue_create([cacheDiskQueue UTF8String], DISPATCH_QUEUE_CONCURRENT);
        self.lastCheckedTime = [[NSDate date] timeIntervalSince1970];
    }
    return self;
}

- (void)addItem:(UIImage *)item forKey:(NSString *)key withCompletion:(ReadWriteCacheItemCompletion)completion {
    
    dispatch_async(self.internalQueue, ^{
    
        NSString * path = [LRUFileUtils getFilePathForKey:key withCacheName:self.cacheName];
        
        [item writeToFilePath:path WithComplete:^(UIImage *data, NSError *error) {
            if (completion) {
                completion(data, path, error);
            }
        }];
    });
}

- (void)objectForKey:(NSString *)key withCompletion:(ReadWriteCacheItemCompletion)completion {
    if (completion) {
        dispatch_async(self.internalQueue, ^{
            
            NSString * path = [LRUFileUtils getFilePathForKey:key withCacheName:self.cacheName];
            
            NSFileManager * manager = [NSFileManager defaultManager];
            if ([manager fileExistsAtPath:path]) {
                [UIImage readFromFilePath:path WithComplete:^(UIImage *data, NSError *error) {
                    completion(data, path, error);
                }];
            } else {
                completion(nil, path, [NSError errorWithDomain:@"Cache read"
                                                          code:0
                                                      userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Cache not found for key: %@", key]}]);
            }
        });
    }
}

- (void)removeObjectForKey:(NSString *)key withCompletion:(ReadWriteCacheItemCompletion)completion {
    
    dispatch_barrier_async(self.internalQueue, ^{
        
        NSString * path = [LRUFileUtils getFilePathForKey:key withCacheName:self.cacheName];
        
        NSFileManager * manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:path]) {
            NSError * error;
            [manager removeItemAtPath:path error:&error];
            if (completion) {
                completion(nil, path, error);
            } else {
                completion(nil, path, nil);
            }
        }
    });
}

- (void)removeAllObjectWithCompletion:(ReadWriteCacheItemCompletion)completion {
    dispatch_barrier_async(self.internalQueue, ^{
        NSString * path = [LRUFileUtils getCachePathWithCacheName:self.cacheName];
        NSFileManager * manager = [NSFileManager defaultManager];
        
        if ([manager fileExistsAtPath:path]) {
            
            NSError * error;
            NSArray * contents = [manager contentsOfDirectoryAtPath:path error:&error];
            
            if (error) {
                if (completion) {
                    completion(nil, path, error);
                }
            } else {
                for (NSString * file in contents) {
                    [manager removeItemAtPath:file error:&error];
                    if (error) {
                        // TODO nothing to do, just log
                        NSLog(@"Remove file: %@", error.localizedDescription);
                        error = nil;
                    }
                }
                if (completion) {
                    completion(nil, path, nil);
                }
            }
        } else {
            if (completion) {
                completion(nil, path, nil);
            }
        }
    });
}

- (void)startDeleteOutDateFileWithCompareTime:(NSTimeInterval)time {
    dispatch_barrier_async(self.internalQueue, ^{
        NSString * path = [LRUFileUtils getCachePathWithCacheName:self.cacheName];
        NSFileManager * manager = [NSFileManager defaultManager];
        
        if ([manager fileExistsAtPath:path]) {
            
            NSError * error;
            NSArray * contents = [manager contentsOfDirectoryAtPath:path error:&error];
            
            if (error) {
                // TODO just log
                NSLog(@"%@", error.localizedDescription);
            } else {
                for (NSString * file in contents) {
                    NSError * error;
                    NSDictionary* fileAttribs = [[NSFileManager defaultManager] attributesOfItemAtPath:file error:&error];
                    
                    if (error) {
                        NSLog(@"Get attribute of file: %@", error.localizedDescription);
                    } else {
                        NSDate *result = [fileAttribs objectForKey:NSFileCreationDate];
                        NSTimeInterval creationTime = [result timeIntervalSince1970];
                        if (fabs(creationTime - time) > kTimeToRemove) {
                            // remove outdate file
                            
                            NSError * error;
                            [manager removeItemAtPath:file error:&error];
                            if (error) {
                                NSLog(@"Delete outdate file: %@", error.localizedDescription);
                            }
                        }
                    }
                }
            }
        }
    });
}

@end

