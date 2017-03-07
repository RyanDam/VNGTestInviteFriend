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


@end

@implementation Call

- (instancetype)initWithUUID:(NSUUID *)uuid isOutgoing:(BOOL)flag {
    self = [super init];
    if (self) {
        self.uuid = uuid;
        self.isOutgoing = flag;
        self.callState = kConnecting;
    }
    return self;
}

- (bool) isHold {
    return _callState == kHeld;
}

- (NSTimeInterval)duration {
    if (self.connectedDate) {
        NSDate *now = [NSDate new];
        
        NSTimeInterval nowInterval = [now timeIntervalSince1970];
        NSTimeInterval callInterval = [self.connectedDate timeIntervalSince1970];
        
        return nowInterval - callInterval;
    } else {
        return 0;
    }
}

- (void)startCallWithCompletion:(void (^)(BOOL success))completion {

    self.stateDidChange(kConnecting);
    
    if (completion) {
        completion(YES);
    }
}

- (void)answerCallWithCompletion:(void (^)(BOOL success))completion {
    
    self.callConnectedDate = [NSDate date];
    self.stateDidChange(kConnected);
    
    if (completion) {
        completion(YES);
    }
}

- (void)endCallWithCompletion:(void (^)(BOOL success))completion {
    
    self.stateDidChange(kEnd);

    if (completion) {
        completion(YES);
    }
}

- (void)holdCallWithCompletion:(void (^)(BOOL success))completion {
   
    self.stateDidChange(kHeld);

    if (completion) {
        completion(YES);
    }
}

- (void)unholdCallWithCompletion:(void (^)(BOOL success))completion {
        
    // do something
    
    if (completion) {
        completion(YES);
    }
}

@end
