//
//  LRUFileUtils.m
//  Contact Selector
//
//  Created by CPU11815 on 2/21/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "LRUFileUtils.h"

#define CACHE_PATH_NAME @"LRUCacheDisk"
#define CACHE_INFO_FILE @"cache.info"

@implementation LRUFileUtils

+ (NSString *)getAppPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return paths[0];
}

+ (NSString *)getCachePathWithCacheName:(NSString *)cacheName {
    
    NSFileManager * manager = [NSFileManager defaultManager];
    
    NSString * appPath = [self getAppPath];
    NSString * grandCachePath = [appPath stringByAppendingPathComponent:CACHE_PATH_NAME];
    
    if ([manager fileExistsAtPath:grandCachePath] == NO) {
        // WARNING ERROR
        [manager createDirectoryAtPath:grandCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString * result = [grandCachePath stringByAppendingPathComponent:cacheName];
    if ([manager fileExistsAtPath:result] == NO) {
        // WARNING ERROR
        [manager createDirectoryAtPath:result withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return result;
}

+ (NSString *)getCacheInfoFilePathWithCacheName:(NSString *)cacheName {
    
//    NSFileManager * manager = [NSFileManager defaultManager];
    
    NSString * cachePath = [self getCachePathWithCacheName:cacheName];
    NSString * result = [cachePath stringByAppendingPathComponent:CACHE_INFO_FILE];
    
//    if ([manager fileExistsAtPath:result] == NO) {
//        // WARNING ERROR
//        [manager createFileAtPath:result contents:nil attributes:nil];
//    }
    
    NSLog(@"%@", result);
    
    return result;
}

+ (NSString *)getFilePathForKey:(NSString *)key withCacheName:(NSString *)cacheName {
    
    NSFileManager * manager = [NSFileManager defaultManager];
    
    NSString * cachePath = [self getCachePathWithCacheName:cacheName];
    NSString * result = [cachePath stringByAppendingPathComponent:key];
    
    if ([manager fileExistsAtPath:result] == NO) {
        // WARNING ERROR
        [manager createDirectoryAtPath:result withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return result;
}

@end
