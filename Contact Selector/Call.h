//
//  Call.h
//  Contact Selector
//
//  Created by CPU11815 on 3/6/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kConnecting,
    kConnected,
    kHeld,
    kEnd
} CallState;

@interface Call : NSObject

@property (nonatomic) NSUUID * uuid;
@property (nonatomic) NSString * handle;

@property (nonatomic) NSDate * connectedDate;
@property (nonatomic) BOOL isOutgoing;
@property (nonatomic) CallState callState;
@property (nonatomic, readonly) BOOL isHold;
@property (nonatomic, readonly) NSTimeInterval duration;

@property (nonatomic) void (^stateDidChange)(CallState);


- (instancetype)initWithUUID:(NSUUID *)uuid isOutgoing:(BOOL)flag;

- (void)startCallWithCompletion:(void (^)(BOOL success))completion;

- (void)answerCallWithCompletion:(void (^)(BOOL success))completion;

- (void)endCallWithCompletion:(void (^)(BOOL success))completion;

- (void)holdCallWithCompletion:(void (^)(BOOL success))completion;

- (void)unholdCallWithCompletion:(void (^)(BOOL success))completion;

@end
