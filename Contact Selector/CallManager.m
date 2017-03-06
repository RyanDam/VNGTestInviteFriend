//
//  CallManager.m
//  Contact Selector
//
//  Created by CPU11815 on 3/6/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CallManager.h"
#import "Call.h"

@import CallKit;

@interface CallManager ()

@property (nonatomic) CXCallController * controller;
@property (nonatomic) NSMutableArray * callList;

@end

@implementation CallManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.controller = [[CXCallController alloc] initWithQueue:dispatch_get_main_queue()];
        self.callList = [@[] mutableCopy];
    }
    return self;
}

- (void)startCall:(NSUUID *)uuid handle:(NSString *)handle {
    
    CXHandle * handlecx = [[CXHandle alloc] initWithType:CXHandleTypePhoneNumber value:handle];
    CXStartCallAction * callAct = [[CXStartCallAction alloc] initWithCallUUID:uuid handle:handlecx];
    [callAct setVideo:NO];
    [self requestAction:callAct];
}

- (void)endCall:(Call *)call {
    
    CXEndCallAction * endAct = [[CXEndCallAction alloc] initWithCallUUID:call.uuid];
    [self requestAction:endAct];
}

- (void)holdCall:(Call *)call {
    
    CXSetHeldCallAction * holdAct = [[CXSetHeldCallAction alloc] initWithCallUUID:call.uuid onHold:!call.isHold];
    [self requestAction:holdAct];
}

- (void)requestAction:(CXAction *)act {
    
    CXTransaction * trans = [[CXTransaction alloc] initWithAction:act];
    [self.controller requestTransaction:trans completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Transaction request failed: %@", error.localizedDescription);
        } else {
            NSLog(@"Transaction request sucessfully");
        }
    }];
}

#pragma mark - Call management

- (NSArray *)allCall {
    return self.callList;
}

- (Call *)getCallByUUID:(NSUUID *)uuid {
    Call * result = nil;
    if (uuid) {
        for (int i = 0; i < self.callList.count || result == nil; i++) {
            Call * call = self.callList[i];
            if ([call.uuid.UUIDString compare:uuid.UUIDString] == NSOrderedSame) {
                result = call;
            }
        }
    }
    return result;
}

- (void)addCall:(Call *)call {
    if (call) {
        [self.callList addObject:call];
    }
}

- (void)removeCall:(Call *)call {
    if (call && [self.callList containsObject:call]) {
        [self.callList removeObject:call];
    }
}

- (void)removeAllCall {
    [self.callList removeAllObjects];
}

@end
