//
//  CallProvider.m
//  Contact Selector
//
//  Created by CPU11815 on 3/6/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CallProvider.h"
#import "CallManager.h"
#import "Call.h"

@import CallKit;

@interface CallProvider () <CXProviderDelegate>

@property (nonatomic) CXProvider * provider;
@property (nonatomic) CallManager * manager;

@end

@implementation CallProvider

+ (CXProviderConfiguration *)getCallConfiguration {
    
    static CXProviderConfiguration * config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[CXProviderConfiguration alloc] initWithLocalizedName:@"ContactSelector"];
        config.supportsVideo = NO;
        config.maximumCallGroups = 2;
        config.maximumCallsPerCallGroup = 1;
    });
    return config;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.manager = [[CallManager alloc] init];
        [self initProvider];
    }
    return self;
}

- (instancetype)initWithManagement:(CallManager *)manager {
    self = [super init];
    if (self) {
        self.manager = manager;
        [self initProvider];
    }
    return self;
}

- (void)initProvider {
    self.provider = [[CXProvider alloc] initWithConfiguration:[CallProvider getCallConfiguration]];
    [self.provider setDelegate:self queue:dispatch_get_main_queue()];
}

- (void)reportIncommingCallUUID:(NSUUID *)uuid handle:(NSString *)handle completion:(void (^)(NSError * error))completion {
    if (uuid && handle) {
        CXCallUpdate * update = [[CXCallUpdate alloc] init];
        update.remoteHandle = [[CXHandle alloc] initWithType:CXHandleTypePhoneNumber value:handle];
        update.hasVideo = NO;
        [self.provider reportNewIncomingCallWithUUID:uuid update:update completion:^(NSError * _Nullable error) {
            if (error) {
                // TODO print error
                NSLog(@"%@", error.localizedDescription);
            } else {
                
                Call * call = [[Call alloc] initWithUUID:uuid isOutgoing:NO];
                call.handle = handle;
                [self.manager addCall:call];
            }
            
            if (completion) {
                completion(error);
            }
        }];
    }
}

#pragma mark - CXProviderDelegate

- (void)providerDidReset:(CXProvider *)provider {
    
    // disconect all call
    for (Call * call in self.manager.allCall) {
        [call endCallWithCompletion:nil];
    }
    
    [self.manager removeAllCall];
}

- (void)provider:(CXProvider *)provider performStartCallAction:(CXStartCallAction *)action {
    
    Call * call = [self.manager getCallByUUID:action.UUID];
    
    [call startCallWithCompletion:^(BOOL success) {
        if (success) {
            [action fulfill];
            
            [self.provider reportOutgoingCallWithUUID:call.uuid startedConnectingAtDate:[NSDate date]];
        } else {
            [action fail];
        }
    }];
}

- (void)provider:(CXProvider *)provider performAnswerCallAction:(CXAnswerCallAction *)action {

    Call * call = [self.manager getCallByUUID:action.callUUID];
    if (call) {
        [call answerCallWithCompletion:^(BOOL success) {
            if (success) {
                // can setup audio here
                [action fulfill];
                
                [self.provider reportOutgoingCallWithUUID:call.uuid connectedAtDate:call.connectedDate];
            } else {
                [action fail];
            }
        }];
    } else {
        [action fail];
    }
}

- (void)provider:(CXProvider *)provider performEndCallAction:(CXEndCallAction *)action {
    
    Call * call = [self.manager getCallByUUID:action.callUUID];
    if (call) {
        [call endCallWithCompletion:^(BOOL success) {
            if (success) {
                // can setup audio here
                
                [self.manager removeCall:call];
                
                [action fulfill];
            } else {
                [action fail];
            }
        }];
    } else {
        [action fail];
    }
}

- (void)provider:(CXProvider *)provider performSetHeldCallAction:(CXSetHeldCallAction *)action {
    
    Call * call = [self.manager getCallByUUID:action.callUUID];
    if (call) {
        if (action.isOnHold) {
            [call holdCallWithCompletion:^(BOOL success) {
                if (success) {
                    // can setup audio here
                    
                    [action fulfill];
                } else {
                    [action fail];
                }
            }];
        } else {
            [call unholdCallWithCompletion:^(BOOL success) {
                if (success) {
                    // can setup audio here
                    
                    [action fulfill];
                } else {
                    [action fail];
                }
            }];
        }
    } else {
        [action fail];
    }
}

- (void)provider:(CXProvider *)provider timedOutPerformingAction:(CXAction *)action {
    NSLog(@"Call timeout");
    
    [action fulfill];
}

- (void)provider:(CXProvider *)provider didActivateAudioSession:(AVAudioSession *)audioSession {
    // TODO, mute audio
}

- (void)provider:(CXProvider *)provider didDeactivateAudioSession:(AVAudioSession *)audioSession {
    // TODO, start audio
}

@end
