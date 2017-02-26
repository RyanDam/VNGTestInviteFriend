//
//  TestCSBlockDatabaseManager.m
//  Contact Selector
//
//  Created by Dam Vu Duy on 2/26/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CSBlockDatebaseManager.h"
#import "CSContact.h"

@interface TestCSBlockDatabaseManager : XCTestCase

@end

@implementation TestCSBlockDatabaseManager

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateDatabase {
    XCTAssertNotNil([CSBlockDatebaseManager manager]);
    
    CSBlockDatebaseManager * manager = [CSBlockDatebaseManager manager];
    
    CSContact * sample = [[CSContact alloc] init];
    sample.fullName = @"Duy Dam";
    sample.phoneNumbers = @[@"0966415722"];
    
    XCTAssertTrue([manager blockContact:sample]);
    
    NSArray * data = [manager getAllBlockContact];
    
    XCTAssertEqual(data.count, 1);
    
    CSContact * d = data[0];
    
    XCTAssertEqualObjects(@"Duy Dam", d.fullName);
    
    XCTAssertEqualObjects(@"0966415722", d.phoneNumbers[0]);
    
    sample = [[CSContact alloc] init];
    sample.fullName = @"Duy Dam";
    sample.phoneNumbers = @[@"0966415722"];
    XCTAssertTrue([manager unblockContact:sample]);
    
    NSArray * data2 = [manager getAllBlockContact];
    
    XCTAssertEqual(data2.count, 0);
    
}

@end
