//
//  CallProvider.h
//  Contact Selector
//
//  Created by CPU11815 on 3/6/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CallManager;

@class CXHandle;

@interface CallProvider : NSObject

- (instancetype)initWithManagement:(CallManager *)manager;

- (void)reportIncommingCallUUID:(NSUUID *)uuid handle:(NSString *)handle completion:(void (^)(NSError * error))completion;

@end
