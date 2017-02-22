//
//  FBContactProvider.m
//  Contact Selector
//
//  Created by CPU11808 on 2/22/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "FBContactProvider.h"
#import "CSContact.h"
@import FBSDKCoreKit;
@import AccountKit;

@implementation FBContactProvider

- (void)getDataArrayWithCompletion:(void (^)(NSArray<CSModel *> *, NSError *))completion {
    
    if (!completion) {
        return;
    }
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends" parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         
         if (error) {
             completion(nil, error);
             return;
         }
         
         NSArray *friends = [result objectForKey:@"data"];
         
         NSMutableArray* contacts = [NSMutableArray new];
         
         for (id user in friends) {
             CSContact *contact = [CSContact new];
             
             contact.fullName = [user objectForKey:@"name"];
             [contacts addObject:contact];
         }
         
         completion(contacts, nil);
     }];
}

@end
