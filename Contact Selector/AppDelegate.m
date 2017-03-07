//
//  AppDelegate.m
//  Contact Selector
//
//  Created by CPU11815 on 2/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "CallObserver.h"
#import "CallManager.h"
#import "CallProvider.h"

@import PushKit;

@interface AppDelegate () <PKPushRegistryDelegate>

@property (nonatomic) PKPushRegistry * pushRegistry;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //    [[FBSDKApplicationDelegate sharedInstance] application:application
    //                             didFinishLaunchingWithOptions:launchOptions];
    
    // PushKit setup
    self.pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    self.pushRegistry.delegate = self;
    
    // CallKit setup
    self.callManager = [[CallManager alloc] init];
    self.callProvider = [[CallProvider alloc] initWithManagement:self.callManager];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    return [[FBSDKApplicationDelegate sharedInstance] application:application
//                                                          openURL:url
//                                                sourceApplication:sourceApplication
//                                                       annotation:annotation];
//}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - PKPushRegistryDelegate

- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(PKPushType)type {
    // update token
}

- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type {
    if (type == PKPushTypeVoIP) {
        // just recive VoIP call
        NSString * idString = payload.dictionaryPayload[@"UUID"];
        NSString * handleString = payload.dictionaryPayload[@"Handle"];
        NSUUID * uuid = [[NSUUID alloc] initWithUUIDString:idString];
        
        // report incomming call to CallKit
        [self.callProvider reportIncommingCallUUID:uuid handle:handleString completion:nil];
        
    }
}

- (void)simulateIncommingCall:(NSUUID *)uuid handle:(NSString *)handle completion:(void (^)())completion {
    [self.callProvider reportIncommingCallUUID:uuid handle:handle completion:^(NSError *error) {
        if (completion) {
            completion();
        }
    }];
}

@end
