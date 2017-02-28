//
//  CallObserver.m
//  Contact Selector
//
//  Created by CPU11815 on 2/28/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CallObserver.h"

@import CallKit;

@interface CallObserver() <CXCallObserverDelegate>

@property (nonatomic) CXCallObserver * observer;

@end

@implementation CallObserver

+ (instancetype)observer {
    
    static CallObserver * instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CallObserver alloc] init];
        instance.observer = [[CXCallObserver alloc] init];
        [instance.observer setDelegate:instance queue:nil];
    });
    
    return instance;
}

#pragma mark - CXCallObserverDelegate

- (void)callObserver:(CXCallObserver *)callObserver callChanged:(CXCall *)call {
    
    NSLog(@"Call income %@", call.UUID.UUIDString);
    
    if (call.hasEnded) {
        NSLog(@"Ended");
    }
    
    if (call.hasConnected) {
        NSLog(@"Connected");
    }
    
    if (call.isOutgoing) {
        NSLog(@"Outgoing");
    }
    
    if (call.isOnHold) {
        NSLog(@"Onhold");
    }

}

@end
