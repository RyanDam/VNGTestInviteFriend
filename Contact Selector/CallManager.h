//
//  CallManager.h
//  Contact Selector
//
//  Created by CPU11815 on 3/6/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Call;

@interface CallManager : NSObject

@property (nonatomic, readonly) NSArray * allCall;

- (Call *)startCall:(NSUUID *)uuid handle:(NSString *)handle;

- (void)answerCall:(Call *)call;

- (void)endCall:(Call *)call;

- (void)holdCall:(Call *)call;

- (Call *)getCallByUUID:(NSUUID *)uuid;

- (void)addCall:(Call *)call;

- (void)removeCall:(Call *)call;

- (void)removeAllCall;

@end
