//
//  Call.h
//  Contact Selector
//
//  Created by CPU11815 on 3/6/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Call : NSObject

@property (nonatomic) NSUUID * uuid;
@property (nonatomic) NSString * handle;
@property (nonatomic, readonly) BOOL isConnected;
@property (nonatomic, readonly) BOOL isHold;
@property (nonatomic, readonly) NSDate * connectedDate;
@property (nonatomic, readonly) BOOL isOutgoing;

- (instancetype)initWithUUID:(NSUUID *)uuid isOutgoing:(BOOL)flag;

- (void)startCallWithCompletion:(void (^)(BOOL success))completion;

- (void)answerCallWithCompletion:(void (^)(BOOL success))completion;

- (void)endCallWithCompletion:(void (^)(BOOL success))completion;

- (void)holdCallWithCompletion:(void (^)(BOOL success))completion;

- (void)unholdCallWithCompletion:(void (^)(BOOL success))completion;

@end
