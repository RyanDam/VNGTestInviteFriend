//
//  AppDelegate.h
//  Contact Selector
//
//  Created by CPU11815 on 2/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>

@import PushKit;

@class CallManager;
@class CallProvider;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) CallManager * callManager;
@property (nonatomic) CallProvider * callProvider;

- (void)simulateIncommingCall:(NSUUID *)uuid handle:(NSString *)handle;

@end

