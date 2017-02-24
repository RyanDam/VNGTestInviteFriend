//
//  Contact_SelectorTests.m
//  Contact SelectorTests
//
//  Created by CPU11815 on 2/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LRUCache.h"
#import "LRUCacheDisk.h"
#import "LRUCacheItem.h"

@interface LRUCache(test)

- (NSString *)printAll;

@end

@interface Contact_SelectorTests : XCTestCase

@end

@implementation Contact_SelectorTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)testAdd2Data {
//    
//    XCTestExpectation *ce1 = [self expectationWithDescription:@"1"];
//    XCTestExpectation *ce2 = [self expectationWithDescription:@"2"];
//    
//    LRUCache * cacher = [LRUCache getInstanceWithName:@"firstCache" hopeSize:2];
//    
//    [cacher addObject:@"abc" forKey:@"1" withCompletion:^(LRUCacheItem *item) {
//        XCTAssertNotNil(item, "Append 1 nil");
//        XCTAssertEqual(@"abc", item.value);
//        [ce1 fulfill];
//    }];
//    
//    [cacher addObject:@"def" forKey:@"2" withCompletion:^(LRUCacheItem *item) {
//        XCTAssertNotNil(item, "Append 2 nil");
//        XCTAssertEqual(@"def", item.value);
//        [ce2 fulfill];
//    }];
//    
//    [self waitForExpectationsWithTimeout:2.0 handler:nil];
//    
//    NSString * ret = [cacher printAll];
//    
//    XCTAssertEqualObjects(@",def,abc,", ret);
//}
//
//- (void)testRecallCacher {
//    
//    LRUCache * cacher = [LRUCache getInstanceWithName:@"firstCache" hopeSize:2];
//    
//    NSString * ret = [cacher printAll];
//    
//    XCTAssertEqualObjects(@",def,abc,", ret);
//}
//
//- (void)testRecent {
//    
//    XCTestExpectation *ce1 = [self expectationWithDescription:@"1"];
//    
//    LRUCache * cacher = [LRUCache getInstanceWithName:@"firstCache" hopeSize:2];
//    
//    [cacher objectForKey:@"1" withCompletion:^(LRUCacheItem *item) {
//        XCTAssertNotNil(item, "Append 1 nil");
//        XCTAssertEqual(@"abc", item.value);
//        [ce1 fulfill];
//    }];
//    
//    [self waitForExpectationsWithTimeout:2.0 handler:nil];
//    
//    NSString * ret = [cacher printAll];
//    
//    XCTAssertEqualObjects(@",abc,def,", ret);
//}
//
//- (void)testReSet {
//    
//    XCTestExpectation *ce2 = [self expectationWithDescription:@"2"];
//    
//    LRUCache * cacher = [LRUCache getInstanceWithName:@"firstCache" hopeSize:2];
//    
//    [cacher addObject:@"haha" forKey:@"2" withCompletion:^(LRUCacheItem *item) {
//        XCTAssertNotNil(item, "Reset 2 nil");
//        XCTAssertEqual(@"haha", item.value);
//        [ce2 fulfill];
//    }];
//    
//    [self waitForExpectationsWithTimeout:2.0 handler:nil];
//    
//    NSString * ret = [cacher printAll];
//    
//    XCTAssertEqualObjects(@",haha,abc,", ret);
//}

//- (void)testDiskAdd1Data {
//    
//    XCTestExpectation *ce1 = [self expectationWithDescription:@"1"];
//    
//    __block LRUCacheDisk * cacher;
//    
//     [LRUCacheDisk getInstanceWithName:@"diskCache" hopeMaxSize:2 withCompletion:^(LRUCacheDisk *diskCacher) {
//         cacher = diskCacher;
//         
//         LRUCacheItem * item = [[LRUCacheItem alloc] initWithObject:@"abc" andSize:1];
//         [cacher addItem:item forKey:@"1" withCompletion:^(LRUCacheItem *item, NSString *path, NSError *error) {
//             XCTAssertNotNil(item, "Append 1 nil");
//             XCTAssertEqual(@"abc", item.value);
//             
//             [ce1 fulfill];
//         }];
//    }];
//    
//    [self waitForExpectationsWithTimeout:5.0 handler:nil];
//    
//    NSString * ret = [cacher printAll];
//    
//    XCTAssertEqualObjects(@":abc", ret);
//}
//
//- (void)testDiskAdd2Data {
//    
//    XCTestExpectation *ce2 = [self expectationWithDescription:@"2"];
//    
//    __block LRUCacheDisk * cacher;
//    
//    [LRUCacheDisk getInstanceWithName:@"diskCache" hopeMaxSize:2 withCompletion:^(LRUCacheDisk *diskCacher) {
//
//        cacher = diskCacher;
//        
//        LRUCacheItem * item2 = [[LRUCacheItem alloc] initWithObject:@"def" andSize:1];
//        [cacher addItem:item2 forKey:@"2" withCompletion:^(LRUCacheItem *item, NSString *path, NSError *error) {
//            XCTAssertNotNil(item, "Append 2 nil");
//            XCTAssertEqual(@"def", item.value);
//            [ce2 fulfill];
//        }];
//    }];
//    
//    [self waitForExpectationsWithTimeout:5.0 handler:nil];
//    
//    NSString * ret = [cacher printAll];
//    
//    XCTAssertEqualObjects(@":def:abc", ret);
//}

//- (void)testAddDisk {
//    
//    XCTestExpectation *ce3 = [self expectationWithDescription:@"3"];
//    
//    LRUCache * cacher = [LRUCache getInstanceWithName:@"firstCache" hopeSize:2];
//    
//    [cacher addObject:@"hahahi" forKey:@"3" withCompletion:^(LRUCacheItem *item) {
//        XCTAssertNotNil(item, "Add 3 nil");
//        XCTAssertEqual(@"hahahi", item.value);
//        [ce3 fulfill];
//    }];
//    
//    [self waitForExpectationsWithTimeout:5.0 handler:nil];
//    
//    NSString * ret = [cacher printAll];
//    
//    XCTAssertEqualObjects(@",hahahi,haha,:abc", ret);
//}

//- (void)testGetDisk {
//    
//    XCTestExpectation *ce3 = [self expectationWithDescription:@"3"];
//    
//    LRUCache * cacher = [LRUCache getInstanceWithName:@"firstCache" hopeSize:2];
//    
//    [cacher objectForKey:@"1" withCompletion:^(LRUCacheItem *item) {
//        XCTAssertNotNil(item, "Add 3 nil");
//        XCTAssertEqual(@"abc", item.value);
//        [ce3 fulfill];
//    }];
//    
//    [self waitForExpectationsWithTimeout:2.0 handler:nil];
//    
//    NSString * ret = [cacher printAll];
//    
//    XCTAssertEqualObjects(@",abc,hahahi,:haha", ret);
//}
//
//- (void)testAddDisk2 {
//    XCTestExpectation *ce3 = [self expectationWithDescription:@"4"];
//    
//    LRUCache * cacher = [LRUCache getInstanceWithName:@"firstCache" hopeSize:2];
//    
//    [cacher addObject:@"ho" forKey:@"4" withCompletion:^(LRUCacheItem *item) {
//        XCTAssertNotNil(item, "Add 4 nil");
//        XCTAssertEqual(@"ho", item.value);
//        [ce3 fulfill];
//    }];
//    
//    [self waitForExpectationsWithTimeout:2.0 handler:nil];
//    
//    NSString * ret = [cacher printAll];
//    
//    XCTAssertEqualObjects(@",ho,hahahi,:haha:abc", ret);
//}
//
//- (void)testAddDisk3 {
//    XCTestExpectation *ce3 = [self expectationWithDescription:@"5"];
//    
//    LRUCache * cacher = [LRUCache getInstanceWithName:@"firstCache" hopeSize:2];
//    
//    [cacher addObject:@"hohi" forKey:@"5" withCompletion:^(LRUCacheItem *item) {
//        XCTAssertNotNil(item, "Add 4 nil");
//        XCTAssertEqual(@"hohi", item.value);
//        [ce3 fulfill];
//    }];
//    
//    [self waitForExpectationsWithTimeout:2.0 handler:nil];
//    
//    NSString * ret = [cacher printAll];
//    
//    XCTAssertEqualObjects(@",hohi,ho,:hahahi:haha", ret);
//}
//
//- (void)testGetDisk2 {
//    
//    XCTestExpectation *ce3 = [self expectationWithDescription:@"3"];
//    
//    LRUCache * cacher = [LRUCache getInstanceWithName:@"firstCache" hopeSize:2];
//    
//    [cacher objectForKey:@"1" withCompletion:^(LRUCacheItem *item) {
//        XCTAssertNil(item, "Get 1 not nil");
//        [ce3 fulfill];
//    }];
//    
//    [self waitForExpectationsWithTimeout:2.0 handler:nil];
//    
//    NSString * ret = [cacher printAll];
//    
//    XCTAssertEqualObjects(@",hohi,ho,:hahahi:haha", ret);
//}
//
//- (void)testGetDisk3 {
//    
//    XCTestExpectation *ce3 = [self expectationWithDescription:@"3"];
//    
//    LRUCache * cacher = [LRUCache getInstanceWithName:@"firstCache" hopeSize:2];
//    
//    [cacher objectForKey:@"2" withCompletion:^(LRUCacheItem *item) {
//        XCTAssertNotNil(item, "Get 2 nil");
//        XCTAssertEqual(@"haha", item.value);
//        [ce3 fulfill];
//    }];
//    
//    [self waitForExpectationsWithTimeout:2.0 handler:nil];
//    
//    NSString * ret = [cacher printAll];
//    
//    XCTAssertEqualObjects(@",haha,hohi,:ho:hahahi", ret);
//}

@end
