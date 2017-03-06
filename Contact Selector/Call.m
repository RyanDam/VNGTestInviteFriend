//
//  Call.m
//  Contact Selector
//
//  Created by CPU11815 on 3/6/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "Call.h"

@interface Call ()

@property (nonatomic) NSUUID * internalID;
@property (nonatomic) NSDate * callConnectedDate;
@property (nonatomic) BOOL isHolded;
@property (nonatomic) BOOL isCallConnected;
@property (nonatomic) BOOL outgoing;

@end

@implementation Call

- (instancetype)initWithUUID:(NSUUID *)uuid isOutgoing:(BOOL)flag {
    self = [super init];
    if (self) {
        self.internalID = uuid;
        self.isHolded = NO;
        self.isCallConnected = NO;
        self.outgoing = flag;
    }
    return self;
}

- (NSUUID *)uuid {
    return self.internalID;
}

- (BOOL)isHold {
    return self.isHolded;
}

- (BOOL)isConnected {
    return self.isCallConnected;
}

- (NSDate *)connectedDate {
    return self.callConnectedDate;
}

- (BOOL)isOutgoing {
    return self.outgoing;
}

- (void)startCallWithCompletion:(void (^)(BOOL success))completion {
    self.isCallConnected = NO;
    
    // do something
    
    if (completion) {
        completion(YES);
    }
}

- (void)answerCallWithCompletion:(void (^)(BOOL success))completion {
    self.isCallConnected = YES;
    self.callConnectedDate = [NSDate date];
    // do something
    
    if (completion) {
        completion(YES);
    }
}

- (void)endCallWithCompletion:(void (^)(BOOL success))completion {
    self.isCallConnected = NO;
    
    // do something

    if (completion) {
        completion(YES);
    }
}

- (void)holdCallWithCompletion:(void (^)(BOOL success))completion {
    self.isHolded = YES;
    
    // do something

    if (completion) {
        completion(YES);
    }
}

- (void)unholdCallWithCompletion:(void (^)(BOOL success))completion {
    self.isHolded = NO;
    
    // do something
    
    if (completion) {
        completion(YES);
    }
}

@end
