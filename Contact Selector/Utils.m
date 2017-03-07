//
//  Utils.m
//  Contact Selector
//
//  Created by CPU11815 on 3/7/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "Utils.h"
@import CallKit;

@implementation Utils

+ (void)refreshCallDirectionBlockListWithCompletion:(void (^)(NSError * error))completion {
    CXCallDirectoryManager * manager = [CXCallDirectoryManager sharedInstance];
    
    NSString* appID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString * callDirectionID = [appID stringByAppendingString:@".Contact-Selector-Block"];
    
    [manager getEnabledStatusForExtensionWithIdentifier:callDirectionID completionHandler:^(CXCallDirectoryEnabledStatus enabledStatus, NSError * _Nullable error) {
        
        if (error) {
            if (completion) {
                completion(error);
            }
        } else {
            if (enabledStatus == CXCallDirectoryEnabledStatusDisabled || enabledStatus == CXCallDirectoryEnabledStatusUnknown) {
                if (completion) {
                    completion([NSError errorWithDomain:@"Refresh call directory extension" code:0 userInfo:@{NSLocalizedDescriptionKey: @"Please enable to block contact in \nSettings > Phone > Call Blocking & Identification > enable Contact Selector"}]);
                }
            } else {
                [manager reloadExtensionWithIdentifier:callDirectionID completionHandler:^(NSError * _Nullable error) {
                    if (error) {
                        if (completion) {
                            completion(error);
                        }
                    } else {
                        if (completion) {
                            completion(nil);
                        }
                    }
                }];
            }
        }
    }];
}

+ (void)showMessage:(NSString *)message inViewController:(UIViewController *)vc {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Message"
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * dismissAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:dismissAction];
    [vc presentViewController:alert animated:YES completion:nil];
}

@end
